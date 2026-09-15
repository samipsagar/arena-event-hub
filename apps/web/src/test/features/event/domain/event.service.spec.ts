import { TestBed } from '@angular/core/testing';
import { EventRepository } from '@features/event/data/event.repository';
import { EventService } from '@features/event/domain/event.service';
import { firstValueFrom, of } from 'rxjs';
import { EventMock } from '../../../mocks/event-mock';

function repositoryStub() {
  return {
    getAll: vi.fn(),
    getById: vi.fn(),
    create: vi.fn(),
    update: vi.fn(),
    remove: vi.fn(),
  };
}

describe('EventService', () => {
  let repository: ReturnType<typeof repositoryStub>;
  let service: EventService;

  beforeEach(() => {
    repository = repositoryStub();

    TestBed.configureTestingModule({
      providers: [EventService, { provide: EventRepository, useValue: repository }],
    });

    service = TestBed.inject(EventService);
  });

  describe('save', () => {
    it('creates when the form has no id', async () => {
      repository.create.mockReturnValue(of(EventMock.dto({ id: 'evt-new' })));

      const saved = await firstValueFrom(service.save(EventMock.formData()));

      expect(saved.id).toBe('evt-new');
      expect(repository.create).toHaveBeenCalledOnce();
      expect(repository.update).not.toHaveBeenCalled();
    });

    it('updates against the form id when one is present', async () => {
      repository.update.mockReturnValue(of(EventMock.dto({ id: 'evt-7' })));

      const saved = await firstValueFrom(
        service.save(EventMock.formData({ id: 'evt-7', title: 'Moved to Pitch 3' })),
      );

      expect(saved.id).toBe('evt-7');
      expect(repository.create).not.toHaveBeenCalled();
      expect(repository.update).toHaveBeenCalledWith(
        'evt-7',
        expect.objectContaining({ title: 'Moved to Pitch 3' }),
      );
    });

    it('sends a status only when updating', async () => {
      repository.create.mockReturnValue(of(EventMock.dto()));
      repository.update.mockReturnValue(of(EventMock.dto()));

      await firstValueFrom(service.save(EventMock.formData()));
      await firstValueFrom(service.save(EventMock.formData({ id: 'evt-7', status: 'LIVE' })));

      expect(repository.create.mock.calls[0][0]).not.toHaveProperty('status');
      expect(repository.update.mock.calls[0][1]).toMatchObject({ status: 'LIVE' });
    });
  });

  describe('loadEvents', () => {
    it('passes the query, cursor and limit straight through', async () => {
      repository.getAll.mockReturnValue(of({ data: [], nextCursor: null, hasNext: false }));

      const query = { status: 'LIVE', sport: 'TENNIS', title: 'open' } as const;
      await firstValueFrom(service.loadEvents({ query, cursor: 'cur-1', limit: 5 }));

      expect(repository.getAll).toHaveBeenCalledWith({ query, cursor: 'cur-1', limit: 5 });
    });

    it('maps the page to domain events, keeping the cursor', async () => {
      repository.getAll.mockReturnValue(
        of({
          data: [EventMock.dto({ id: 'a' }), EventMock.dto({ id: 'b', sport: 'CHESS' })],
          nextCursor: 'cur-2',
          hasNext: true,
        }),
      );

      const page = await firstValueFrom(service.loadEvents({ query: {} }));

      expect(page.events).toEqual([
        EventMock.entity({ id: 'a' }),
        EventMock.entity({ id: 'b', sport: 'CHESS' }),
      ]);
      expect(page.nextCursor).toBe('cur-2');
      expect(page.hasNext).toBe(true);
    });
  });

  describe('loadEvent', () => {
    it('maps the dto it fetches', async () => {
      repository.getById.mockReturnValue(of(EventMock.dto({ id: 'evt-7' })));

      await expect(firstValueFrom(service.loadEvent('evt-7'))).resolves.toEqual(
        EventMock.entity({ id: 'evt-7' }),
      );
      expect(repository.getById).toHaveBeenCalledWith('evt-7');
    });
  });
});
