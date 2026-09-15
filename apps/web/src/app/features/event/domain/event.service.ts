import { Service, inject } from '@angular/core';
import { Observable, map } from 'rxjs';
import { EventRepository } from '../data/event.repository';
import {
  eventToDomain,
  eventsToDomain,
  formDataToCreateRequest,
  formDataToUpdateRequest,
} from '../data/mapper/event.mapper';
import { Event } from './entity/event';
import { EventFormData } from './entity/event-form-data';
import { EventsPage } from './entity/events-page';
import { EventQuery } from './event-query';

/**
 * The only events API presentation sees: entities and `EventQuery`, never DTOs
 * or endpoints.
 *
 * Depends on `EventRepository` directly rather than on an interface the domain
 * owns — with one backend and one implementation the indirection buys nothing
 * today, the same deviation mobile's ARCHITECTURE.md records.
 */
@Service()
export class EventService {
  private readonly repository = inject(EventRepository);

  loadEvents(options: {
    query: EventQuery;
    cursor?: string;
    limit?: number;
  }): Observable<EventsPage> {
    return this.repository.getAll(options).pipe(
      map((page) => ({
        events: eventsToDomain(page.data),
        nextCursor: page.nextCursor,
        hasNext: page.hasNext,
      })),
    );
  }

  loadEvent(id: string): Observable<Event> {
    return this.repository.getById(id).pipe(map(eventToDomain));
  }

  /**
   * Creates when `formData` has no id, replaces the one it names otherwise.
   *
   * The two branches build different bodies on purpose: POST takes no status,
   * PUT requires one.
   */
  save(formData: EventFormData): Observable<Event> {
    const saved = formData.id
      ? this.repository.update(formData.id, formDataToUpdateRequest(formData))
      : this.repository.create(formDataToCreateRequest(formData));

    return saved.pipe(map(eventToDomain));
  }

  remove(id: string): Observable<void> {
    return this.repository.remove(id);
  }
}
