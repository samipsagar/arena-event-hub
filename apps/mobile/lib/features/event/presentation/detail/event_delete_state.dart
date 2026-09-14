import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sports/core/exception/app_exception.dart';

part 'event_delete_state.freezed.dart';

@freezed
sealed class EventDeleteState with _$EventDeleteState {
  const factory EventDeleteState.idle() = EventDeleteIdle;
  const factory EventDeleteState.deleting() = EventDeleteDeleting;
  const factory EventDeleteState.success() = EventDeleteSuccess;
  const factory EventDeleteState.failure(AppException error) =
      EventDeleteFailure;
}
