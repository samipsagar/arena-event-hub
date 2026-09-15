import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';
import { API_BASE_URL } from '@core/config/config';
import { errorInterceptor } from '@core/http/error.interceptor';
import { ObservabilityService } from '@core/observability/observability.service';
import { EventService } from '@features/event/domain/event.service';
import { firstValueFrom } from 'rxjs';
import { EventMock } from '../mocks/event-mock';

const BASE_URL = 'https://api.test';
const PATH = `${BASE_URL}/api/v1/events`;

/**
 * The events stack end to end, with only the socket replaced:
 * `EventService` -> `EventRepository` -> `ApiClient` -> `errorInterceptor`.
 */
describe('events api', () => {
  let service: EventService;
  let http: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        provideHttpClient(withInterceptors([errorInterceptor])),
        provideHttpClientTesting(),
        { provide: API_BASE_URL, useValue: BASE_URL },
        { provide: ObservabilityService, useValue: { log: vi.fn() } },
      ],
    });

    service = TestBed.inject(EventService);
    http = TestBed.inject(HttpTestingController);
  });

  afterEach(() => http.verify());

  function page(...items: Record<string, unknown>[]) {
    return { data: items, nextCursor: 'cur-2', hasNext: true };
  }

  describe('loadEvents', () => {
    it('sends the filters and the default limit', async () => {
      const events = firstValueFrom(
        service.loadEvents({ query: { status: 'LIVE', sport: 'TENNIS', title: 'open' } }),
      );

      const request = http.expectOne((candidate) => candidate.url === PATH);
      expect(request.request.method).toBe('GET');
      expect(request.request.params.get('status')).toBe('LIVE');
      expect(request.request.params.get('sport')).toBe('TENNIS');
      expect(request.request.params.get('title')).toBe('open');
      expect(request.request.params.get('limit')).toBe('10');

      request.flush(page());
      await events;
    });

    it('sends the cursor it is given and maps the page back', async () => {
      const events = firstValueFrom(service.loadEvents({ query: {}, cursor: 'cur-1' }));

      const request = http.expectOne((candidate) => candidate.url === PATH);
      expect(request.request.params.get('cursor')).toBe('cur-1');

      request.flush(page(EventMock.json({ id: 'a' })));

      await expect(events).resolves.toEqual({
        events: [EventMock.entity({ id: 'a' })],
        nextCursor: 'cur-2',
        hasNext: true,
      });
    });

    it('fails with a parsing error when the body is not a page', async () => {
      const events = firstValueFrom(service.loadEvents({ query: {} }));

      http.expectOne((candidate) => candidate.url === PATH).flush({ nope: true });

      await expect(events).rejects.toMatchObject({ kind: 'parsing' });
    });
  });

  describe('save', () => {
    it('posts a body without a status when creating', async () => {
      const saved = firstValueFrom(service.save(EventMock.formData()));

      const request = http.expectOne(PATH);
      expect(request.request.method).toBe('POST');
      expect(request.request.body).not.toHaveProperty('status');
      expect(request.request.body).toMatchObject({
        title: 'Sunday Five-a-side',
        sport: 'FOOTBALL',
        startsAt: '2026-03-14T18:30:00.000Z',
      });

      request.flush(EventMock.json({ id: 'evt-new' }));

      await expect(saved).resolves.toEqual(EventMock.entity({ id: 'evt-new' }));
    });

    it('puts a body with a status when updating', async () => {
      const saved = firstValueFrom(
        service.save(EventMock.formData({ id: 'evt-7', status: 'LIVE' })),
      );

      const request = http.expectOne(`${PATH}/evt-7`);
      expect(request.request.method).toBe('PUT');
      expect(request.request.body).toMatchObject({ status: 'LIVE' });

      request.flush(EventMock.json({ id: 'evt-7', status: 'LIVE' }));
      await saved;
    });
  });

  describe('remove', () => {
    it('deletes by id', async () => {
      const removed = firstValueFrom(service.remove('evt-7'));

      const request = http.expectOne(`${PATH}/evt-7`);
      expect(request.request.method).toBe('DELETE');

      request.flush(null);
      await removed;
    });
  });

  describe('failures', () => {
    it('surfaces the detail a 4xx problem document carries', async () => {
      const saved = firstValueFrom(service.save(EventMock.formData()));

      http.expectOne(PATH).flush(
        {
          detail: 'Participant limit 5 is below the 8 already registered.',
          errors: { participantLimit: 'must not be below registered participants' },
        },
        { status: 400, statusText: 'Bad Request' },
      );

      await expect(saved).rejects.toMatchObject({
        kind: 'client',
        statusCode: 400,
        message: 'Participant limit 5 is below the 8 already registered.',
        fieldErrors: ['participantLimit: must not be below registered participants'],
      });
    });

    it('keeps a 5xx body out of the message it shows', async () => {
      const events = firstValueFrom(service.loadEvents({ query: {} }));

      http
        .expectOne((candidate) => candidate.url === PATH)
        .flush('<html>proxy error</html>', { status: 503, statusText: 'Service Unavailable' });

      await expect(events).rejects.toMatchObject({
        kind: 'server',
        statusCode: 503,
        message: 'Something went wrong on our side. Please try again.',
      });
    });

    it('reports a request that never reached the server as a network error', async () => {
      const events = firstValueFrom(service.loadEvents({ query: {} }));

      http
        .expectOne((candidate) => candidate.url === PATH)
        .error(new ProgressEvent('error'), { status: 0, statusText: 'Unknown Error' });

      await expect(events).rejects.toMatchObject({
        kind: 'network',
        message: 'Unable to connect to the server.',
      });
    });
  });
});
