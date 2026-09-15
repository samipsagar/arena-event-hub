import { z } from 'zod';
import { eventStatusSchema } from './event-status.dto';
import { sportsDtoSchema } from './event.sports.dto';

const requestFields = {
  title: z.string(),
  description: z.string(),
  venue: z.string(),
  sport: sportsDtoSchema,
  /** ISO-8601 UTC. */
  startsAt: z.string(),
  durationInMinutes: z.number().int(),
  participantLimit: z.number().int(),
  registeredParticipants: z.number().int(),
};

export const createEventRequestDtoSchema = z.object(requestFields);

export const updateEventRequestDtoSchema = z.object({
  ...requestFields,
  status: eventStatusSchema,
});

export type CreateEventRequestDto = z.infer<typeof createEventRequestDtoSchema>;
export type UpdateEventRequestDto = z.infer<typeof updateEventRequestDtoSchema>;
