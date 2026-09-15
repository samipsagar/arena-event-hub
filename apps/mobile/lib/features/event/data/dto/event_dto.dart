import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_dto.freezed.dart';
part 'event_dto.g.dart';

/// One event as the backend's `EventResponse` sends it.
///
/// `sport` and `status` stay [String] so an unrecognised value still parses;
/// `EventMapper` decides what it means.
@freezed
abstract class EventDto with _$EventDto {
  const factory EventDto({
    required String id,
    required String title,
    @Default('') String description,
    required String sport,
    required String status,
    required String venue,
    required DateTime startsAt,
    required DateTime endsAt,
    required int durationInMinutes,
    required int participantLimit,
    required int registeredParticipants,
    required int spotsRemaining,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EventDto;

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);
}
