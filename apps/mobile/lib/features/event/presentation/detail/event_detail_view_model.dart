import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/features/event/domain/entity/event.dart';
import 'package:sports/features/event/providers.dart';

part 'event_detail_view_model.g.dart';

@riverpod
class EventDetailViewModel extends _$EventDetailViewModel {
  @override
  Future<Event> build(String eventId) {
    final service = ref.watch(eventServiceProvider);
    return service.loadEvent(eventId);
  }
}
