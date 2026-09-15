import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/features/event/domain/entity/sport.dart';

/// How [Sport] is spelled on the wire.
extension SportWire on Sport {
  ///  All is null for filter
  String? get fromDomain => this == Sport.all ? null : name.toUpperCase();

  static Sport toDomain(String value) {
    return Sport.values.firstWhere(
      (sport) => sport.fromDomain == value.toUpperCase(),
      orElse: () => throw ParsingException(message: 'Unknown sport $value'),
    );
  }
}
