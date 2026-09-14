import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/features/event/domain/entity/event_status.dart';
import 'package:sports/features/event/domain/entity/sport.dart';
import 'package:sports/features/event/domain/event_query.dart';

part 'events_filter_view_model.g.dart';

/// Event filter using sport, status or search text
@riverpod
class EventsFilterViewModel extends _$EventsFilterViewModel {
  static const searchDebounce = Duration(milliseconds: 300);

  Timer? _searchTimer;

  @override
  EventQuery build() {
    ref.onDispose(_cancelPendingSearch);

    return const EventQuery();
  }

  void setStatus(EventStatus? status) => state = state.withStatus(status);

  void setSport(Sport? sport) => state = state.withSport(sport);

  void search(String term) {
    _cancelPendingSearch();

    _searchTimer = Timer(searchDebounce, () => state = state.withSearch(term));
  }

  /// Drops every filter, including a search term still waiting to land.
  void clear() {
    _cancelPendingSearch();

    state = const EventQuery();
  }

  void _cancelPendingSearch() {
    _searchTimer?.cancel();
    _searchTimer = null;
  }
}
