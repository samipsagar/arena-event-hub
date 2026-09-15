import { z } from 'zod';
import { eventStatusSchema } from './event-status.dto';
import { sportsDtoSchema } from './event.sports.dto';

export const eventDtoSchema = z.object({
  id: z.string(),
  title: z.string(),
  description: z.string().default(''),
  sport: sportsDtoSchema,
  status: eventStatusSchema,
  venue: z.string(),
  startsAt: z.coerce.date(),
  endsAt: z.coerce.date(),
  durationInMinutes: z.number().int(),
  participantLimit: z.number().int(),
  registeredParticipants: z.number().int(),
  spotsRemaining: z.number().int(),
  createdAt: z.coerce.date(),
  updatedAt: z.coerce.date(),
});

export type EventDto = z.infer<typeof eventDtoSchema>;
