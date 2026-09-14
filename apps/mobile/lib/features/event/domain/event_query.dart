import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sports/features/event/domain/entity/event_status.dart';
import 'package:sports/features/event/domain/entity/sport.dart';

part 'event_query.freezed.dart';

/// What the list is currently filtered down to.
@freezed
abstract class EventQuery with _$EventQuery {
  const factory EventQuery({
    EventStatus? status,
    Sport? sport,
    String? search,
  }) = _EventQuery;

  const EventQuery._();

  /// Lets an empty result say "nothing matched" rather than "nothing exists".
  bool get hasFilters =>
      (status != null && status != EventStatus.unknown) ||
      (sport != null && sport != Sport.unknown) ||
      (search?.trim().isNotEmpty ?? false);

  EventQuery withStatus(EventStatus? status) =>
      EventQuery(status: status, sport: sport, search: search);

  EventQuery withSport(Sport? sport) =>
      EventQuery(status: status, sport: sport, search: search);

  EventQuery withSearch(String? search) =>
      EventQuery(status: status, sport: sport, search: search);
}
