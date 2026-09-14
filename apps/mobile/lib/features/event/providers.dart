import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/core/network/providers.dart';
import 'package:sports/features/event/data/event_repository.dart';
import 'package:sports/features/event/data/mapper/event_mapper.dart';
import 'package:sports/features/event/domain/event_service.dart';

final eventMapperProvider = Provider<EventMapper>((ref) => const EventMapper());

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(ref.watch(apiClientProvider));
});

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService(
    ref.watch(eventRepositoryProvider),
    ref.watch(eventMapperProvider),
  );
});
