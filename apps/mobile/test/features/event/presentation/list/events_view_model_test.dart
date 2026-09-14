import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/core/feedback/feedback_service.dart';
import 'package:sports/core/feedback/providers.dart';
import 'package:sports/features/event/domain/entity/events_page.dart';
import 'package:sports/features/event/domain/event_query.dart';
import 'package:sports/features/event/domain/event_service.dart';
import 'package:sports/features/event/presentation/list/events_view_model.dart';
import 'package:sports/features/event/providers.dart';

import '../../../../mocks/event_mock.dart';

class MockEventService extends Mock implements EventService {}

class MockFeedbackService extends Mock implements FeedbackService {}

void main() {
  late MockEventService service;
  late MockFeedbackService feedback;

  final firstPage = EventsPage(
    events: [EventMock.entity(id: 'a')],
    nextCursor: 'cur-1',
    hasNext: true,
  );

  final secondPage = EventsPage(
    events: [EventMock.entity(id: 'b')],
    nextCursor: null,
    hasNext: false,
  );

  setUpAll(() {
    registerFallbackValue(const EventQuery());
    registerFallbackValue(FeedbackSeverity.info);
  });

  setUp(() {
    service = MockEventService();
    feedback = MockFeedbackService();
  });

  /// Stubs `loadEvents` so the answer depends on the cursor: null is the
  /// first page, anything else is the page after it.
  void stubPages({required FutureOr<EventsPage> Function() next}) {
    when(
      () => service.loadEvents(
        query: any(named: 'query'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((invocation) async {
      final cursor = invocation.namedArguments[#cursor];
      return cursor == null ? firstPage : await next();
    });
  }

  /// A container with the first page already loaded. The listener keeps the
  /// auto-disposed provider alive for the length of the test.
  Future<ProviderContainer> loadedContainer() async {
    final container = ProviderContainer.test(
      overrides: [
        eventServiceProvider.overrideWithValue(service),
        feedbackServiceProvider.overrideWithValue(feedback),
      ],
    );

    container.listen(eventsViewModelProvider, (_, _) {});

    return container;
  }

  group('loadMore', () {
    test('appends the next page and takes over its cursor', () async {
      stubPages(next: () => secondPage);

      final container = await loadedContainer();
      await container.read(eventsViewModelProvider.notifier).loadMore();

      final state = container.read(eventsViewModelProvider).requireValue;

      expect(state.events, [...firstPage.events, ...secondPage.events]);
      expect(state.nextCursor, isNull);
      expect(state.hasNext, isFalse);
      expect(state.isLoadingMore, isFalse);
    });

    test('does nothing once there is no next page', () async {
      when(
        () => service.loadEvents(
          query: any(named: 'query'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => secondPage);

      final container = await loadedContainer();
      clearInteractions(service);

      await container.read(eventsViewModelProvider.notifier).loadMore();

      verifyNever(
        () => service.loadEvents(
          query: any(named: 'query'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      );
    });

    test('keeps the loaded page and reports a failure', () async {
      stubPages(
        next: () => throw const ServerException(
          message: 'Something went wrong on our side. Please try again.',
          statusCode: 503,
        ),
      );

      final container = await loadedContainer();
      await container.read(eventsViewModelProvider.notifier).loadMore();

      final state = container.read(eventsViewModelProvider).requireValue;

      expect(state.events, [...firstPage.events]);
      expect(state.isLoadingMore, isFalse);

      verify(
        () => feedback.show(
          FeedbackSeverity.error,
          'Something went wrong on our side. Please try again.',
        ),
      ).called(1);
    });

    test('stays silent when the app cancelled the request itself', () async {
      stubPages(next: () => throw const CancelledException());

      final container = await loadedContainer();
      await container.read(eventsViewModelProvider.notifier).loadMore();

      expect(
        container.read(eventsViewModelProvider).requireValue.isLoadingMore,
        isFalse,
      );
      verifyNever(() => feedback.show(any(), any()));
    });
  });
}
