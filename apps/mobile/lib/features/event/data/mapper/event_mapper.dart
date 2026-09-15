import 'package:sports/features/event/data/dto/event_dto.dart';
import 'package:sports/features/event/data/dto/event_request_dto.dart';
import 'package:sports/features/event/data/mapper/event_status_mapper.dart';
import 'package:sports/features/event/data/mapper/sport_mapper.dart';
import 'package:sports/features/event/domain/entity/event.dart';
import 'package:sports/features/event/domain/entity/event_form_data.dart';

class EventMapper {
  const EventMapper();

  Event toDomain(EventDto dto) {
    return Event(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      sport: SportWire.toDomain(dto.sport),
      status: EventStatusWire.toDomain(dto.status),
      venue: dto.venue,
      startsAt: dto.startsAt.toLocal(),
      endsAt: dto.endsAt.toLocal(),
      durationInMinutes: dto.durationInMinutes,
      participantLimit: dto.participantLimit,
      registeredParticipants: dto.registeredParticipants,
      spotsRemaining: dto.spotsRemaining,
    );
  }

  List<Event> toDomainList(Iterable<EventDto> dtos) =>
      dtos.map(toDomain).toList(growable: false);

  /// The body for `create`/`update`.
  ///
  EventRequestDto toRequestDto(EventFormData formData) {
    return EventRequestDto(
      title: formData.title,
      description: formData.description ?? '',
      venue: formData.venue,
      sport: formData.sport.fromDomain!,
      status: formData.status.fromDomain!,
      startsAt: formData.startsAt.toUtc(),
      durationInMinutes: formData.durationInMinutes,
      participantLimit: formData.participantLimit,
      registeredParticipants: formData.registeredParticipants,
    );
  }
}
