import { Service, inject, signal } from '@angular/core';
import { rxResource } from '@angular/core/rxjs-interop';
import { EventService } from '../../domain/event.service';

/**
 * Loads one event, keyed on the route id. `rxResource` unsubscribes when the
 * id changes, cancelling the in-flight request — that is where a `cancelled`
 * AppError comes from. The id starts `undefined` so the resource stays idle
 * until the route binds one.
 */
@Service({ autoProvided: false })
export class EventDetailViewModel {
  private readonly service = inject(EventService);

  readonly eventId = signal<string | undefined>(undefined);

  readonly event = rxResource({
    params: () => this.eventId(),
    stream: ({ params: id }) => this.service.loadEvent(id),
  });
}
