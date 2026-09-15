export const Routes = {
  events: '/events',
  newEvent: '/events/new',
  eventDetail: (id: string) => `/events/${id}`,
  editEvent: (id: string) => `/events/${id}/edit`,
} as const;
