import 'package:sports/features/event/domain/entity/sport.dart';

/// How [Sport] is spelled on the wire.
extension SportWire on Sport {
  /// Null for unknown, which the backend has no name for.
  ///  All is null for filter
  String? get fromDomain =>
      this == Sport.unknown || this == Sport.all ? null : name.toUpperCase();

  static Sport toDomain(String? value) {
    if (value == null) {
      return Sport.unknown;
    }

    return Sport.values.firstWhere(
      (sport) => sport.fromDomain == value.toUpperCase(),
      orElse: () => Sport.unknown,
    );
  }
}
