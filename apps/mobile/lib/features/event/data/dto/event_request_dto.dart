import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_request_dto.freezed.dart';
part 'event_request_dto.g.dart';

/// `CreateEventRequest`/`UpdateEventRequest`
///

@freezed
abstract class EventRequestDto with _$EventRequestDto {
  const factory EventRequestDto({
    required String title,
    required String description,
    required String venue,
    required String sport,
    required String status,
    required DateTime startsAt,
    required int durationInMinutes,
    required int participantLimit,
    required int registeredParticipants,
  }) = _EventRequestDto;

  factory EventRequestDto.fromJson(Map<String, dynamic> json) =>
      _$EventRequestDtoFromJson(json);
}
