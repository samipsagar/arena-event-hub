import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/core/network/api_client.dart';
import 'package:sports/core/network/dio_factory.dart';
import 'package:sports/features/event/data/event_repository.dart';
import 'package:sports/features/event/data/mapper/event_mapper.dart';
import 'package:sports/features/event/domain/entity/event_status.dart';
import 'package:sports/features/event/domain/entity/sport.dart';
import 'package:sports/features/event/domain/event_query.dart';
import 'package:sports/features/event/domain/event_service.dart';

import '../mocks/event_mock.dart';

/// The events stack end to end, with only the socket replaced.
///
/// `EventService` -> `EventRepository` -> `ApiClient` -> the real
/// `createAppDio` and its `ErrorInterceptor`, against a `DioAdapter` serving
/// canned HTTP responses.
void main() {
  late DioAdapter adapter;
  late EventService service;

  /// The request that actually reached the adapter, recorded by the handlers
  /// below so each test can assert on it.
  late RequestOptions sent;

  setUp(() {
    final dio = createAppDio(baseUrl: 'https://api.test');

    adapter = DioAdapter(
      dio: dio,
      matcher: const UrlRequestMatcher(matchMethod: true),
    );

    service = EventService(
      EventRepository(ApiClient(dio)),
      const EventMapper(),
    );
  });

  /// Each handler records the request on its way past, then answers with
  /// [body] as JSON.
  void onGet(Object? body, {String route = '/api/v1/events'}) => adapter.onGet(
    route,
    (server) => server.replyCallback(200, (options) {
      sent = options;
      return body;
    }),
  );

  void onPost(Object? body, {String route = '/api/v1/events'}) =>
      adapter.onPost(
        route,
        (server) => server.replyCallback(201, (options) {
          sent = options;
          return body;
        }),
      );

  void onPut(Object? body, {required String route}) => adapter.onPut(
    route,
    (server) => server.replyCallback(200, (options) {
      sent = options;
      return body;
    }),
  );

  const emptyPage = {'data': [], 'nextCursor': null, 'hasNext': false};

  group('GET /api/v1/events', () {
    test('sends every filter under the name the backend expects', () async {
      onGet(emptyPage);

      await service.loadEvents(
        query: const EventQuery(
          status: EventStatus.live,
          sport: Sport.tennis,
          // Padded, to prove the trim happens before the wire.
          search: '  open  ',
        ),
        cursor: 'cur-1',
        limit: 5,
      );

      expect(sent.method, 'GET');
      expect(sent.path, '/api/v1/events');
      expect(sent.uri.toString(), startsWith('https://api.test/'));
      expect(sent.queryParameters, {
        'status': 'LIVE',
        'sport': 'TENNIS',
        'title': 'open',
        'limit': 5,
        'cursor': 'cur-1',
      });
    });

    test(
      'omits filters that are not set, and cursor on a first page',
      () async {
        onGet(emptyPage);

        await service.loadEvents();

        expect(sent.queryParameters, {'limit': 20});
      },
    );

    test('parses a page into domain events', () async {
      onGet({
        'data': [
          EventMock.json(id: 'a'),
          EventMock.json(id: 'b', sport: 'CHESS', status: 'LIVE'),
        ],
        'nextCursor': 'cur-2',
        'hasNext': true,
      });

      final page = await service.loadEvents();

      expect(page.events, [
        EventMock.entity(id: 'a'),
        EventMock.entity(id: 'b', sport: Sport.chess, status: EventStatus.live),
      ]);
      expect(page.nextCursor, 'cur-2');
      expect(page.hasNext, isTrue);
    });
  });

  group('writes', () {
    test('posts the request body the backend documents', () async {
      onPost(EventMock.json(id: 'evt-new'));

      final created = await service.save(EventMock.formData(id: null));

      expect(sent.method, 'POST');
      expect(sent.path, '/api/v1/events');
      expect(sent.data, {
        'title': 'Sunday Five-a-side',
        'description': 'Casual game, all levels welcome.',
        'venue': 'Riverside Pitch 2',
        'sport': 'FOOTBALL',
        'status': 'SCHEDULED',
        'startsAt': '2026-03-14T18:30:00.000Z',
        'durationInMinutes': 90,
        'participantLimit': 10,
        'registeredParticipants': 4,
      });
      expect(created.id, 'evt-new');
    });

    test('puts an update against the event id', () async {
      onPut(EventMock.json(id: 'evt-7'), route: '/api/v1/events/evt-7');

      await service.save(EventMock.formData(id: 'evt-7'));

      expect(sent.method, 'PUT');
      expect(sent.path, '/api/v1/events/evt-7');
    });

    test('puts the status the form selected, not the one it arrived with', () async {
      onPut(EventMock.json(id: 'evt-7', status: 'LIVE'), route: '/api/v1/events/evt-7');

      await service.save(
        EventMock.formData(id: 'evt-7', status: EventStatus.live),
      );

      expect((sent.data as Map<String, dynamic>)['status'], 'LIVE');
    });
  });

  group('failures', () {
    test('surfaces a 4xx problem document, fields and all', () async {
      adapter.onPost(
        '/api/v1/events',
        (server) => server.reply(
          409,
          jsonEncode({
            'type': 'about:blank',
            'title': 'Conflict',
            'status': 409,
            'detail': 'Participant limit 5 is below the 8 already registered.',
            'errors': {'participantLimit': 'must be at least 8'},
          }),
          headers: {
            Headers.contentTypeHeader: ['application/problem+json'],
          },
        ),
      );

      await expectLater(
        service.save(EventMock.formData(id: null)),
        throwsA(
          isA<ClientException>()
              .having((error) => error.statusCode, 'statusCode', 409)
              .having(
                (error) => error.message,
                'message',
                'Participant limit 5 is below the 8 already registered.\n'
                    'participantLimit: must be at least 8',
              ),
        ),
      );
    });

    test('never shows a 5xx body to the user', () async {
      adapter.onGet(
        '/api/v1/events',
        (server) => server.reply(
          502,
          '<html><body>502 Bad Gateway — upstream sports-api-7f4b</body></html>',
          headers: {
            Headers.contentTypeHeader: ['text/html'],
          },
        ),
      );

      await expectLater(
        service.loadEvents(),
        throwsA(
          isA<ServerException>().having(
            (error) => error.statusCode,
            'statusCode',
            502,
          ),
        ),
      );
    });

    test('reports a lost connection as a network failure', () async {
      adapter.onGet(
        '/api/v1/events',
        (server) => server.throws(
          0,
          DioException.connectionError(
            requestOptions: RequestOptions(path: '/api/v1/events'),
            reason: 'the socket went away',
          ),
        ),
      );

      await expectLater(service.loadEvents(), throwsA(isA<NetworkException>()));
    });

    test('reports a body that is not the shape we expect', () async {
      onGet({'data': 'not a list'});

      await expectLater(service.loadEvents(), throwsA(isA<ParsingException>()));
    });
  });
}
