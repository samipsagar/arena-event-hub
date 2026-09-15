import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sports/features/event/domain/entity/event.dart';
import 'package:sports/features/event/domain/entity/events_page.dart';

part 'events_state.freezed.dart';

/// ViewState for [events].
@freezed
abstract class EventsState with _$EventsState {
  const factory EventsState({
    required List<Event> events,
    required String? nextCursor,
    required bool hasNext,
    @Default(false) bool isLoadingMore,
  }) = _EventsState;

  const EventsState._();

  factory EventsState.fromPage(EventsPage page) => EventsState(
    events: page.events,
    nextCursor: page.nextCursor,
    hasNext: page.hasNext,
  );

  EventsState appending(EventsPage page) => EventsState(
    events: [...events, ...page.events],
    nextCursor: page.nextCursor,
    hasNext: page.hasNext,
  );

  bool get isEmpty => events.isEmpty;
}
