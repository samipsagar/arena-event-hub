import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sports/core/network/cursor_page.dart';
import 'package:sports/features/event/data/dto/event_dto.dart';
import 'package:sports/features/event/data/dto/event_request_dto.dart';
import 'package:sports/features/event/data/event_repository.dart';
import 'package:sports/features/event/data/mapper/event_mapper.dart';
import 'package:sports/features/event/domain/entity/event_status.dart';
import 'package:sports/features/event/domain/entity/sport.dart';
import 'package:sports/features/event/domain/event_query.dart';
import 'package:sports/features/event/domain/event_service.dart';

import '../../../mocks/event_mock.dart';

class MockEventRepository extends Mock implements EventRepository {}

void main() {
  late MockEventRepository repository;
  late EventService service;

  setUpAll(() {
    registerFallbackValue(const EventQuery());
    registerFallbackValue(
      EventRequestDto(
        title: '',
        description: '',
        venue: '',
        sport: 'FOOTBALL',
        status: 'SCHEDULED',
        startsAt: DateTime.utc(2026),
        durationInMinutes: 1,
        participantLimit: 1,
        registeredParticipants: 0,
      ),
    );
  });

  setUp(() {
    repository = MockEventRepository();
    service = EventService(repository, const EventMapper());
  });

  void stubGetAll(CursorPage<EventDto> page) {
    when(
      () => repository.getAll(
        query: any(named: 'query'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => page);
  }

  group('save', () {
    test('creates when the form has no id', () async {
      when(
        () => repository.create(any()),
      ).thenAnswer((_) async => EventMock.dto(id: 'evt-new'));

      final saved = await service.save(EventMock.formData(id: null));

      expect(saved.id, 'evt-new');
      verify(() => repository.create(any())).called(1);
      verifyNever(() => repository.update(any(), any()));
    });

    test('updates against the form id when one is present', () async {
      when(
        () => repository.update(any(), any()),
      ).thenAnswer((_) async => EventMock.dto(id: 'evt-7'));

      final saved = await service.save(
        EventMock.formData(id: 'evt-7', title: 'Moved to Pitch 3'),
      );

      expect(saved.id, 'evt-7');
      verifyNever(() => repository.create(any()));

      final captured = verify(
        () => repository.update(captureAny(), captureAny()),
      ).captured;

      expect(captured.first, 'evt-7');
      expect((captured.last as EventRequestDto).title, 'Moved to Pitch 3');
    });

    test('sends the sport as the backend spells it', () async {
      when(
        () => repository.create(any()),
      ).thenAnswer((_) async => EventMock.dto());

      await service.save(EventMock.formData(sport: Sport.basketball));

      final sent =
          verify(() => repository.create(captureAny())).captured.single
              as EventRequestDto;

      expect(sent.sport, 'BASKETBALL');
    });
  });

  group('loadEvents', () {
    test('passes the query, cursor and limit straight through', () async {
      stubGetAll(
        const CursorPage<EventDto>(data: [], nextCursor: null, hasNext: false),
      );

      const query = EventQuery(
        status: EventStatus.live,
        sport: Sport.tennis,
        search: 'open',
      );

      await service.loadEvents(query: query, cursor: 'cur-1', limit: 5);

      verify(
        () => repository.getAll(query: query, cursor: 'cur-1', limit: 5),
      ).called(1);
    });

    test('maps the page to domain events, keeping the cursor', () async {
      stubGetAll(
        CursorPage<EventDto>(
          data: [
            EventMock.dto(id: 'a'),
            EventMock.dto(id: 'b', sport: 'CHESS'),
          ],
          nextCursor: 'cur-2',
          hasNext: true,
        ),
      );

      final page = await service.loadEvents();

      expect(page.events, [
        EventMock.entity(id: 'a'),
        EventMock.entity(id: 'b', sport: Sport.chess),
      ]);
      expect(page.nextCursor, 'cur-2');
      expect(page.hasNext, isTrue);
    });

    test('maps a sport the app does not know to unknown', () async {
      stubGetAll(
        CursorPage<EventDto>(
          data: [EventMock.dto(sport: 'KABADDI')],
          nextCursor: null,
          hasNext: false,
        ),
      );

      final page = await service.loadEvents();

      expect(page.events.single, EventMock.entity(sport: Sport.unknown));
    });
  });
}
