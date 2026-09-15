import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/core/feedback/feedback_service.dart';
import 'package:sports/core/feedback/providers.dart';
import 'package:sports/core/observability/providers.dart';
import 'package:sports/features/event/presentation/detail/event_delete_state.dart';
import 'package:sports/features/event/providers.dart';

part 'event_delete_view_model.g.dart';

/// Drives a single event deletion.
@riverpod
class EventDeleteViewModel extends _$EventDeleteViewModel {
  @override
  EventDeleteState build() => const EventDeleteState.idle();

  Future<void> delete(String eventId) async {
    final eventService = ref.read(eventServiceProvider);
    final observabilityService = ref.read(observabilityServiceProvider);
    final feedbackService = ref.read(feedbackServiceProvider);

    state = const EventDeleteState.deleting();

    try {
      observabilityService.addBreadcrumb(
        'Deleting event',
        category: 'event_delete',
        data: {'eventId': eventId},
      );

      await eventService.delete(eventId);
      state = const EventDeleteState.success();

      observabilityService.captureEvent(
        'event_deleted',
        properties: {'eventId': eventId},
      );

      feedbackService.showInfo('Event deleted');
    } on AppException catch (error) {
      state = EventDeleteState.failure(error);

      observabilityService.captureException(
        error,
        error.stackTrace ?? StackTrace.current,
        context: {'eventId': eventId},
      );
    }
  }
}
