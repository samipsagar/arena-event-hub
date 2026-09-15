import { DestroyRef, Service, computed, inject, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { AppError, displayMessage } from '@core/error/app-error';
import { toAppError } from '@core/error/error-mapper';
import { FeedbackService } from '@core/feedback/feedback.service';
import { EMPTY, Subject, catchError, switchMap } from 'rxjs';
import { Event } from '../../domain/entity/event';
import { EventsPage } from '../../domain/entity/events-page';
import { EventQuery } from '../../domain/event-query';
import { EventService } from '../../domain/event.service';

export type EventsStatus = 'idle' | 'loading' | 'ready' | 'error';

/**
 * Shared list state for the events feature. Provided on the `/events` parent
 * route, not at root, so it lives only while inside the events area — scroll
 * depth and accumulated pages survive list → detail → back, the way Flutter
 * keeps the list screen alive beneath the pushed route on mobile.
 */
@Service({ autoProvided: false })
export class EventStore {
  private readonly service = inject(EventService);
  private readonly feedback = inject(FeedbackService);
  private readonly destroyRef = inject(DestroyRef);

  private readonly _events = signal<readonly Event[]>([]);
  private readonly _nextCursor = signal<string | null>(null);
  private readonly _hasNext = signal(false);
  private readonly _isLoadingMore = signal(false);
  private readonly _status = signal<EventsStatus>('idle');
  private readonly _error = signal<AppError | null>(null);
  private readonly _query = signal<EventQuery>({});

  readonly events = this._events.asReadonly();
  readonly hasNext = this._hasNext.asReadonly();
  readonly isLoadingMore = this._isLoadingMore.asReadonly();
  readonly status = this._status.asReadonly();
  readonly error = this._error.asReadonly();
  readonly query = this._query.asReadonly();

  readonly isEmpty = computed(() => this._status() === 'ready' && this._events().length === 0);

  /**
   * First-page loads go through a subject so `switchMap` cancels a superseded
   * request — typing in the search box must not let an older response win.
   */
  private readonly firstPage$ = new Subject<EventQuery>();

  constructor() {
    this.firstPage$
      .pipe(
        switchMap((query) =>
          this.service.loadEvents({ query }).pipe(
            // Caught inside the switchMap on purpose: an error reaching the
            // outer subscription would terminate it, leaving load() dead for
            // the rest of the store's life.
            catchError((error: unknown) => {
              this.failFirstPage(error);
              return EMPTY;
            }),
          ),
        ),
        takeUntilDestroyed(this.destroyRef),
      )
      .subscribe((page) => this.acceptFirstPage(page));
  }

  load(query: EventQuery): void {
    this._query.set(query);
    this._status.set('loading');
    this._error.set(null);
    this.firstPage$.next(query);
  }

  refresh(): void {
    this.load(this._query());
  }

  loadMore(): void {
    if (!this._hasNext() || this._isLoadingMore()) {
      return;
    }

    this._isLoadingMore.set(true);

    this.service
      .loadEvents({ query: this._query(), cursor: this._nextCursor() ?? undefined })
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (page) => {
          this._events.update((events) => [...events, ...page.events]);
          this._nextCursor.set(page.nextCursor);
          this._hasNext.set(page.hasNext);
          this._isLoadingMore.set(false);
        },
        error: (error: unknown) => {
          // Keep what is already on screen: a failed "load more" must not
          // discard the pages someone already scrolled through.
          this._isLoadingMore.set(false);
          this.report(error);
        },
      });
  }

  /** Replaces an event in place, or prepends one the list has not seen. */
  upsert(event: Event): void {
    this._events.update((events) => {
      const index = events.findIndex((candidate) => candidate.id === event.id);
      if (index === -1) {
        return [event, ...events];
      }

      const next = [...events];
      next[index] = event;
      return next;
    });

    if (this._status() === 'idle') {
      this._status.set('ready');
    }
  }

  remove(id: string): void {
    this._events.update((events) => events.filter((event) => event.id !== id));
  }

  private acceptFirstPage(page: EventsPage): void {
    this._events.set(page.events);
    this._nextCursor.set(page.nextCursor);
    this._hasNext.set(page.hasNext);
    this._isLoadingMore.set(false);
    this._status.set('ready');
    this._error.set(null);
  }

  private failFirstPage(error: unknown): void {
    const appError = toAppError(error);
    if (appError.kind === 'cancelled') {
      return;
    }

    this._error.set(appError);
    this._status.set('error');
  }

  private report(error: unknown): void {
    const appError = toAppError(error);
    if (appError.kind === 'cancelled') {
      return;
    }

    this.feedback.showError(displayMessage(appError));
  }
}
