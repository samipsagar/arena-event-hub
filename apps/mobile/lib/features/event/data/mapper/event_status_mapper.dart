import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/features/event/domain/entity/event_status.dart';

/// How [EventStatus] is spelled on the wire.
extension EventStatusWire on EventStatus {
  ///  All is also null on backend filter
  String? get fromDomain => this == EventStatus.all ? null : name.toUpperCase();

  static EventStatus toDomain(String value) {
    return EventStatus.values.firstWhere(
      (status) => status.fromDomain == value.toUpperCase(),
      orElse: () =>
          throw ParsingException(message: 'Unknown event status $value'),
    );
  }
}
