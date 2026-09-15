export const EVENT_STATUSES = ['SCHEDULED', 'LIVE', 'COMPLETED', 'CANCELLED'] as const;

export type EventStatus = (typeof EVENT_STATUSES)[number];

export const EVENT_STATUS_LABELS: Record<EventStatus, string> = {
  SCHEDULED: 'Scheduled',
  LIVE: 'Live',
  COMPLETED: 'Completed',
  CANCELLED: 'Cancelled',
};

/** Mirrors the backend's `EventStatus.ALLOWED_TRANSITIONS`. */
const TRANSITIONS: Record<EventStatus, readonly EventStatus[]> = {
  SCHEDULED: ['LIVE', 'CANCELLED'],
  LIVE: ['COMPLETED', 'CANCELLED'],
  COMPLETED: [],
  CANCELLED: [],
};

export function allowedTransitions(from: EventStatus): readonly EventStatus[] {
  return [from, ...TRANSITIONS[from]];
}
