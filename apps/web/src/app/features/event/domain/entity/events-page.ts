import { Event } from './event';

export interface EventsPage {
  readonly events: readonly Event[];
  readonly nextCursor: string | null;
  readonly hasNext: boolean;
}
