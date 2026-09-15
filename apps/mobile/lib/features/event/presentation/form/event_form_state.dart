import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/features/event/domain/entity/event.dart';

part 'event_form_state.freezed.dart';

@freezed
sealed class EventFormState with _$EventFormState {
  const factory EventFormState.idle() = EventFormIdle;
  const factory EventFormState.submitting() = EventFormSubmitting;
  const factory EventFormState.success(Event event) = EventFormSuccess;
  const factory EventFormState.failure(AppException error) = EventFormFailure;
}
