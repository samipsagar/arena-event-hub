import { Service, inject } from '@angular/core';
import { ApiClient } from '@core/http/api-client';
import { CursorPage, parseCursorPage } from '@core/http/cursor-page';
import { Observable } from 'rxjs';
import { EventQuery } from '../domain/event-query';
import { CreateEventRequestDto, UpdateEventRequestDto } from './dto/event-request.dto';
import { EventDto, eventDtoSchema } from './dto/event.dto';
import { queryToParams } from './mapper/event-query.mapper';

const PATH = '/api/v1/events';

/** Knows the endpoints and the dto shapes. Never sees an `Event`. */
@Service()
export class EventRepository {
  static readonly DEFAULT_LIMIT = 10;

  private readonly client = inject(ApiClient);

  getAll(options: {
    query: EventQuery;
    cursor?: string;
    limit?: number;
  }): Observable<CursorPage<EventDto>> {
    return this.client.get(PATH, {
      params: {
        ...queryToParams(options.query),
        limit: options.limit ?? EventRepository.DEFAULT_LIMIT,
        cursor: options.cursor,
      },
      parser: (data) => parseCursorPage(data, (item) => eventDtoSchema.parse(item)),
    });
  }

  getById(id: string): Observable<EventDto> {
    return this.client.get(`${PATH}/${id}`, { parser: (data) => eventDtoSchema.parse(data) });
  }

  create(body: CreateEventRequestDto): Observable<EventDto> {
    return this.client.post(PATH, { body, parser: (data) => eventDtoSchema.parse(data) });
  }

  update(id: string, body: UpdateEventRequestDto): Observable<EventDto> {
    return this.client.put(`${PATH}/${id}`, { body, parser: (data) => eventDtoSchema.parse(data) });
  }

  remove(id: string): Observable<void> {
    return this.client.delete(`${PATH}/${id}`, { parser: () => undefined });
  }
}
