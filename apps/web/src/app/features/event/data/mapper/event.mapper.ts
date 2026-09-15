import { Event } from '../../domain/entity/event';
import { EventFormData } from '../../domain/entity/event-form-data';
import { CreateEventRequestDto, UpdateEventRequestDto } from '../dto/event-request.dto';
import { EventDto } from '../dto/event.dto';
import { statusToDomain, statusToDto } from './event-status.mapper';
import { sportToDomain, sportToDto } from './sport.mapper';

export function eventToDomain(dto: EventDto): Event {
  return {
    id: dto.id,
    title: dto.title,
    description: dto.description,
    sport: sportToDomain(dto.sport),
    status: statusToDomain(dto.status),
    venue: dto.venue,
    startsAt: dto.startsAt,
    endsAt: dto.endsAt,
    durationInMinutes: dto.durationInMinutes,
    participantLimit: dto.participantLimit,
    registeredParticipants: dto.registeredParticipants,
    spotsRemaining: dto.spotsRemaining,
  };
}

export function eventsToDomain(dtos: readonly EventDto[]): readonly Event[] {
  return dtos.map(eventToDomain);
}

function sharedRequestFields(formData: EventFormData) {
  return {
    title: formData.title,
    description: formData.description,
    venue: formData.venue,
    sport: sportToDto(formData.sport),
    startsAt: formData.startsAt.toISOString(),
    durationInMinutes: formData.durationInMinutes,
    participantLimit: formData.participantLimit,
    registeredParticipants: formData.registeredParticipants,
  };
}

export function formDataToCreateRequest(formData: EventFormData): CreateEventRequestDto {
  return sharedRequestFields(formData);
}

export function formDataToUpdateRequest(formData: EventFormData): UpdateEventRequestDto {
  return {
    ...sharedRequestFields(formData),
    status: statusToDto(formData.status),
  };
}
