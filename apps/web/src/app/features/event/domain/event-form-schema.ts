import { z } from 'zod';
import { EVENT_STATUSES } from './entity/event-status';
import { SPORTS } from './entity/sport';

const eventFormObject = z.object({
  title: z.string().trim().min(1, 'Title is required.'),
  description: z.string(),
  venue: z.string().trim().min(1, 'Venue is required.'),
  sport: z.enum(SPORTS, 'Sport is required.'),
  status: z.enum(EVENT_STATUSES, 'Status is required.'),
  startsAt: z.coerce.date('Start time is required.'),
  durationInMinutes: z.number().int().positive('Enter a duration greater than 0.'),
  participantLimit: z.number().int().positive('Enter a limit greater than 0.'),
  registeredParticipants: z.number().int().min(0, 'Enter 0 or more.'),
});

export const eventFormFields = eventFormObject.shape;

export const eventFormSchema = eventFormObject.refine(
  (value) => value.registeredParticipants <= value.participantLimit,
  {
    message: 'Cannot exceed the participant limit.',
    path: ['registeredParticipants'],
  },
);
