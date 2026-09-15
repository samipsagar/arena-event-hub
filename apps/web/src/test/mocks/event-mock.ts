import { EventDto, eventDtoSchema } from '@features/event/data/dto/event.dto';
import { Event } from '@features/event/domain/entity/event';
import { EventFormData } from '@features/event/domain/entity/event-form-data';
import { EventStatus } from '@features/event/domain/entity/event-status';
import { Sport } from '@features/event/domain/entity/sport';

const DESCRIPTION = 'Casual game, all levels welcome.';
const VENUE = 'Riverside Pitch 2';
const STARTS_AT = '2026-03-14T18:30:00.000Z';
const ENDS_AT = '2026-03-14T20:00:00.000Z';
const TIMESTAMP = '2026-02-01T09:00:00.000Z';

interface Overrides {
  id?: string;
  title?: string;
  sport?: Sport;
  status?: EventStatus;
  participantLimit?: number;
  registeredParticipants?: number;
}

/**
 * The same event at every layer it exists in, so a test can hand `json` to a
 * fake backend and assert the result equals `entity`.
 */
export const EventMock = {
  json({
    id = 'evt-1',
    title = 'Sunday Five-a-side',
    sport = 'FOOTBALL',
    status = 'SCHEDULED',
    participantLimit = 10,
    registeredParticipants = 4,
  }: Overrides = {}): Record<string, unknown> {
    return {
      id,
      title,
      description: DESCRIPTION,
      sport,
      status,
      venue: VENUE,
      startsAt: STARTS_AT,
      endsAt: ENDS_AT,
      durationInMinutes: 90,
      participantLimit,
      registeredParticipants,
      spotsRemaining: participantLimit - registeredParticipants,
      createdAt: TIMESTAMP,
      updatedAt: TIMESTAMP,
    };
  },

  /** Parsed from `json` so the fixture and the wire format cannot drift apart. */
  dto(overrides: Overrides = {}): EventDto {
    return eventDtoSchema.parse(EventMock.json(overrides));
  },

  entity({
    id = 'evt-1',
    title = 'Sunday Five-a-side',
    sport = 'FOOTBALL',
    status = 'SCHEDULED',
    participantLimit = 10,
    registeredParticipants = 4,
  }: Overrides = {}): Event {
    return {
      id,
      title,
      description: DESCRIPTION,
      sport,
      status,
      venue: VENUE,
      startsAt: new Date(STARTS_AT),
      endsAt: new Date(ENDS_AT),
      durationInMinutes: 90,
      participantLimit,
      registeredParticipants,
      spotsRemaining: participantLimit - registeredParticipants,
    };
  },

  /** `id` is the field under test in most uses — absent means "create". */
  formData({
    id,
    title = 'Sunday Five-a-side',
    sport = 'FOOTBALL',
    status = 'SCHEDULED',
  }: Overrides = {}): EventFormData {
    return {
      id,
      title,
      description: DESCRIPTION,
      venue: VENUE,
      sport,
      status,
      startsAt: new Date(STARTS_AT),
      durationInMinutes: 90,
      participantLimit: 10,
      registeredParticipants: 4,
    };
  },
};
