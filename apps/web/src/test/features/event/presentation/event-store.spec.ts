import { TestBed } from '@angular/core/testing';
import { cancelledError, serverError } from '@core/error/app-error';
import { FeedbackService, FeedbackSeverity } from '@core/feedback/feedback.service';
import { EventsPage } from '@features/event/domain/entity/events-page';
import { EventService } from '@features/event/domain/event.service';
import { EventStore } from '@features/event/presentation/store/event-store';
import { Observable, of, throwError } from 'rxjs';
import { EventMock } from '../../../mocks/event-mock';

class FakeFeedbackService extends FeedbackService {
  readonly show = vi.fn<(severity: FeedbackSeverity, message: string) => void>();
}

const firstPage: EventsPage = {
  events: [EventMock.entity({ id: 'a' })],
  nextCursor: 'cur-1',
  hasNext: true,
};

const secondPage: EventsPage = {
  events: [EventMock.entity({ id: 'b' })],
  nextCursor: null,
  hasNext: false,
};

describe('EventStore', () => {
  let service: { loadEvents: ReturnType<typeof vi.fn> };
  let feedback: FakeFeedbackService;

  beforeEach(() => {
    service = { loadEvents: vi.fn() };
    feedback = new FakeFeedbackService();

    TestBed.configureTestingModule({
      providers: [
        EventStore,
        { provide: EventService, useValue: service },
        { provide: FeedbackService, useValue: feedback },
      ],
    });
  });

  /** First page always succeeds; `next` decides what the page after it does. */
  function stubPages(next: () => Observable<EventsPage>): void {
    service.loadEvents.mockImplementation((options: { cursor?: string }) =>
      options.cursor === undefined ? of(firstPage) : next(),
    );
  }

  function loadedStore(): EventStore {
    const store = TestBed.inject(EventStore);
    store.load({});
    return store;
  }

  describe('load', () => {
    it('holds the first page once it arrives', () => {
      stubPages(() => of(secondPage));

      const store = loadedStore();

      expect(store.events()).toEqual(firstPage.events);
      expect(store.status()).toBe('ready');
      expect(store.hasNext()).toBe(true);
    });

    it('surfaces a first-page failure as an error state', () => {
      service.loadEvents.mockReturnValue(throwError(() => serverError({ statusCode: 503 })));

      const store = loadedStore();

      expect(store.status()).toBe('error');
      expect(store.error()?.kind).toBe('server');
    });

    it('keeps serving after a failure', () => {
      service.loadEvents.mockReturnValueOnce(throwError(() => serverError({ statusCode: 503 })));
      service.loadEvents.mockReturnValueOnce(of(firstPage));

      const store = loadedStore();
      store.refresh();

      expect(store.status()).toBe('ready');
      expect(store.events()).toEqual(firstPage.events);
    });
  });

  describe('loadMore', () => {
    it('appends the next page and takes over its cursor', () => {
      stubPages(() => of(secondPage));

      const store = loadedStore();
      store.loadMore();

      expect(store.events()).toEqual([...firstPage.events, ...secondPage.events]);
      expect(store.hasNext()).toBe(false);
      expect(store.isLoadingMore()).toBe(false);
    });

    it('does nothing once there is no next page', () => {
      service.loadEvents.mockReturnValue(of(secondPage));

      const store = loadedStore();
      service.loadEvents.mockClear();

      store.loadMore();

      expect(service.loadEvents).not.toHaveBeenCalled();
    });

    it('keeps the loaded page and reports a failure', () => {
      stubPages(() => throwError(() => serverError({ statusCode: 503 })));

      const store = loadedStore();
      store.loadMore();

      expect(store.events()).toEqual(firstPage.events);
      expect(store.isLoadingMore()).toBe(false);
      expect(feedback.show).toHaveBeenCalledWith(
        'error',
        'Something went wrong on our side. Please try again.',
      );
    });

    it('stays silent when the app cancelled the request itself', () => {
      stubPages(() => throwError(() => cancelledError()));

      const store = loadedStore();
      store.loadMore();

      expect(store.isLoadingMore()).toBe(false);
      expect(feedback.show).not.toHaveBeenCalled();
    });
  });

  describe('upsert', () => {
    it('replaces an event already on the list', () => {
      stubPages(() => of(secondPage));

      const store = loadedStore();
      store.upsert(EventMock.entity({ id: 'a', title: 'Moved to Pitch 3' }));

      expect(store.events()).toHaveLength(1);
      expect(store.events()[0].title).toBe('Moved to Pitch 3');
    });

    it('prepends one the list has not seen', () => {
      stubPages(() => of(secondPage));

      const store = loadedStore();
      store.upsert(EventMock.entity({ id: 'z' }));

      expect(store.events().map((event) => event.id)).toEqual(['z', 'a']);
    });
  });

  describe('remove', () => {
    it('drops the event it names', () => {
      stubPages(() => of(secondPage));

      const store = loadedStore();
      store.remove('a');

      expect(store.events()).toEqual([]);
    });
  });
});
