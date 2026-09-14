import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sports/features/event/domain/entity/event.dart';

part 'events_page.freezed.dart';

@freezed
abstract class EventsPage with _$EventsPage {
  const factory EventsPage({
    required List<Event> events,
    required String? nextCursor,
    required bool hasNext,
  }) = _EventsPage;
}
