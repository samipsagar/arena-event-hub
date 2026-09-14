import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sports/features/event/domain/entity/event_status.dart';
import 'package:sports/features/event/domain/entity/sport.dart';

part 'event.freezed.dart';

/// An event, as the app thinks about one.
///
/// No `createdAt`/`updatedAt`: nothing shows them, so they stop at the DTO.
@freezed
abstract class Event with _$Event {
  const factory Event({
    required String id,
    required String title,
    required String description,
    required Sport sport,
    required EventStatus status,
    required String venue,

    /// In the device's timezone, ready to format.
    required DateTime startsAt,
    required DateTime endsAt,
    required int durationMinutes,
    required int participantLimit,
    required int registeredParticipants,
    required int spotsRemaining,
  }) = _Event;

  const Event._();

  bool get isFull => spotsRemaining <= 0;
}
