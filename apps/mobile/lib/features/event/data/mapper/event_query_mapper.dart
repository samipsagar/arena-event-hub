import 'package:sports/features/event/data/mapper/event_status_mapper.dart';
import 'package:sports/features/event/data/mapper/sport_mapper.dart';
import 'package:sports/features/event/domain/event_query.dart';

extension EventQueryWire on EventQuery {
  Map<String, dynamic> toQueryParameters() {
    final title = search?.trim() ?? '';

    return {
      'status': ?status?.fromDomain,
      'sport': ?sport?.fromDomain,
      if (title.isNotEmpty) 'title': title,
    };
  }
}
