import 'package:sports/features/event/domain/entity/event_status.dart';

/// How [EventStatus] is spelled on the wire.
extension EventStatusWire on EventStatus {
  /// Null for unknown, which the backend has no name for.
  ///  All is also null on backend filter
  String? get fromDomain =>
      this == EventStatus.unknown || this == EventStatus.all
      ? null
      : name.toUpperCase();

  static EventStatus toDomain(String? value) {
    if (value == null) {
      return EventStatus.unknown;
    }

    return EventStatus.values.firstWhere(
      (status) => status.fromDomain == value.toUpperCase(),
      orElse: () => EventStatus.unknown,
    );
  }
}
