import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/core/feedback/feedback_service.dart';
import 'package:sports/core/feedback/providers.dart';
import 'package:sports/core/observability/providers.dart';
import 'package:sports/features/event/domain/entity/event_form_data.dart';
import 'package:sports/features/event/presentation/form/event_form_state.dart';
import 'package:sports/features/event/providers.dart';

part 'event_form_view_model.g.dart';

/// Drives a single create/update submission.
@riverpod
class EventFormViewModel extends _$EventFormViewModel {
  @override
  EventFormState build() => const EventFormState.idle();

  Future<void> save(EventFormData formData) async {
    final feedbackService = ref.read(feedbackServiceProvider);
    final eventService = ref.read(eventServiceProvider);
    final observabilityService = ref.read(observabilityServiceProvider);
    final mode = formData.id == null ? 'create' : 'update';

    state = const EventFormState.submitting();

    try {
      observabilityService.addBreadcrumb(
        'Submitting event form',
        category: 'event_form',
        data: {'mode': mode, 'eventId': formData.id},
      );

      final event = await eventService.save(formData);
      state = EventFormState.success(event);

      feedbackService.showInfo(
        formData.id == null ? 'Event created' : 'Event updated',
      );

      observabilityService.captureEvent(
        'event_saved',
        properties: {'mode': mode, 'eventId': event.id},
      );
    } on AppException catch (error) {
      state = EventFormState.failure(error);

      observabilityService.captureException(
        error,
        error.stackTrace ?? StackTrace.current,
        context: {'mode': mode, 'eventId': formData.id},
      );
    }
  }
}
