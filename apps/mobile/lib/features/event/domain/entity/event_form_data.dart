import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sports/features/event/domain/entity/event_status.dart';
import 'package:sports/features/event/domain/entity/sport.dart';

part 'event_form_data.freezed.dart';

@freezed
abstract class EventFormData with _$EventFormData {
  const factory EventFormData({
    required String? id,
    required String title,
    required String? description,
    required Sport sport,
    required EventStatus status,
    required String venue,
    required DateTime startsAt,
    required int durationMinutes,
    required int participantLimit,
    required int registeredParticipants,
  }) = _EventFormData;

  const EventFormData._();
}
