import { EVENT_STATUSES, EventStatus } from './entity/event-status';
import { Sport, SPORTS } from './entity/sport';

export interface EventQuery {
  readonly status?: EventStatus;
  readonly sport?: Sport;
  readonly title?: string;
}

export const EMPTY_QUERY: EventQuery = {};

/** Lets an empty result say "nothing matched" rather than "nothing exists". */
export function hasFilters(query: EventQuery): boolean {
  return (
    query.status !== undefined || query.sport !== undefined || (query.title?.trim().length ?? 0) > 0
  );
}

/**
 * Reads a query out of the URL, ignoring anything it does not recognise.
 */
export function parseEventQuery(params: URLSearchParams): EventQuery {
  const status = params.get('status');
  const sport = params.get('sport');
  const title = params.get('title')?.trim() ?? '';

  return {
    ...(isStatus(status) ? { status } : {}),
    ...(isSport(sport) ? { sport } : {}),
    ...(title.length > 0 ? { title } : {}),
  };
}

/** The inverse of `parseEventQuery`. Blank entries are dropped, not sent empty. */
export function toUrlParams(query: EventQuery): Record<string, string> {
  const title = query.title?.trim() ?? '';

  return {
    ...(query.status ? { status: query.status } : {}),
    ...(query.sport ? { sport: query.sport } : {}),
    ...(title.length > 0 ? { title } : {}),
  };
}

function isStatus(value: string | null): value is EventStatus {
  return value !== null && (EVENT_STATUSES as readonly string[]).includes(value);
}

function isSport(value: string | null): value is Sport {
  return value !== null && (SPORTS as readonly string[]).includes(value);
}
