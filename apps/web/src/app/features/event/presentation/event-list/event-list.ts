import { Component, computed, effect, inject, linkedSignal } from '@angular/core';
import { takeUntilDestroyed, toObservable, toSignal } from '@angular/core/rxjs-interop';
import { FormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { ActivatedRoute, ParamMap, Router, RouterLink } from '@angular/router';
import { displayMessage } from '@core/error/app-error';
import { debounceTime, distinctUntilChanged } from 'rxjs';
import { EVENT_STATUSES, EVENT_STATUS_LABELS } from '../../domain/entity/event-status';
import { SPORTS, SPORT_LABELS } from '../../domain/entity/sport';
import { EventQuery, hasFilters, parseEventQuery, toUrlParams } from '../../domain/event-query';
import { EventCard } from '../components/event-card';
import { EventStore } from '../store/event-store';

@Component({
  selector: 'arena-event-list',
  imports: [
    EventCard,
    FormsModule,
    RouterLink,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    MatProgressSpinnerModule,
    MatSelectModule,
  ],
  host: { class: 'mx-auto block max-w-6xl p-6' },
  templateUrl: './event-list.html',
})
export class EventList {
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);

  protected readonly store = inject(EventStore);

  protected readonly sports = SPORTS;
  protected readonly statuses = EVENT_STATUSES;
  protected readonly sportLabels = SPORT_LABELS;
  protected readonly statusLabels = EVENT_STATUS_LABELS;
  protected readonly displayMessage = displayMessage;

  /**
   * The URL is the source of truth for filters, not a signal mirroring it —
   * so a filtered list is shareable and Back restores what you had.
   */
  private readonly params = toSignal(this.route.queryParamMap, { requireSync: true });

  protected readonly query = computed(() => parseEventQuery(toSearchParams(this.params())));
  protected readonly isFiltered = computed(() => hasFilters(this.query()));

  /** Mirrors `query().title` so typing feels instant while the URL update (and thus the search) is debounced. */
  protected readonly titleFilter = linkedSignal(() => this.query().title ?? '');

  constructor() {
    effect(() => this.store.load(this.query()));

    toObservable(this.titleFilter)
      .pipe(debounceTime(300), distinctUntilChanged(), takeUntilDestroyed())
      .subscribe((title) => this.applyFilter({ title }));
  }

  protected applyFilter(patch: Partial<EventQuery>): void {
    void this.router.navigate([], {
      relativeTo: this.route,
      queryParams: toUrlParams({ ...this.query(), ...patch }),
      // Typing in the search box must not fill the back stack.
      replaceUrl: true,
    });
  }
}

function toSearchParams(map: ParamMap): URLSearchParams {
  const params = new URLSearchParams();
  for (const key of map.keys) {
    const value = map.get(key);
    if (value !== null) {
      params.set(key, value);
    }
  }
  return params;
}
