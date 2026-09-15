import { EventStatus } from './event-status';
import { Sport } from './sport';

/**
 * What the create/edit form edits. `id` is the only optional field: it is
 * absent when creating and identifies the endpoint, never the body.
 */
export interface EventFormData {
  readonly id?: string;
  readonly title: string;
  readonly description: string;
  readonly venue: string;
  readonly sport: Sport;
  readonly status: EventStatus;
  readonly startsAt: Date;
  readonly durationInMinutes: number;
  readonly participantLimit: number;
  readonly registeredParticipants: number;
}
