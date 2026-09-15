import { Routes } from '@angular/router';
import { EventStore } from '@features/event/presentation/store/event-store';

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'events' },
  {
    path: 'events',
    // Component-less parent: one EventStore shared by every child, so
    // accumulated pages survive list -> detail -> back.
    providers: [EventStore],
    children: [
      {
        path: '',
        title: 'Events',
        loadComponent: () =>
          import('@features/event/presentation/event-list/event-list').then((m) => m.EventList),
      },
      {
        // Must precede ':id', or /events/new matches it with id === 'new'.
        path: 'new',
        title: 'New event',
        loadComponent: () =>
          import('@features/event/presentation/event-form/event-form').then((m) => m.EventForm),
      },
      {
        path: ':id',
        title: 'Event',
        loadComponent: () =>
          import('@features/event/presentation/event-detail/event-detail').then(
            (m) => m.EventDetail,
          ),
      },
      {
        path: ':id/edit',
        title: 'Edit event',
        loadComponent: () =>
          import('@features/event/presentation/event-form/event-form').then((m) => m.EventForm),
      },
    ],
  },
  { path: '**', redirectTo: 'events' },
];
