import { EventStatus } from './event-status';
import { Sport } from './sport';

export interface Event {
  id: string;
  title: string;
  description: string;
  sport: Sport;
  status: EventStatus;
  venue: string;
  startsAt: Date;
  endsAt: Date;
  durationInMinutes: number;
  participantLimit: number;
  registeredParticipants: number;
  spotsRemaining: number;
}
