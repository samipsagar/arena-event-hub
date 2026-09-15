import { DatePipe } from '@angular/common';
import { Component, computed, input } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { RouterLink } from '@angular/router';
import { Event } from '../../domain/entity/event';
import { EVENT_STATUS_LABELS } from '../../domain/entity/event-status';
import { SPORT_LABELS } from '../../domain/entity/sport';

/** Presentational: takes an event, emits nothing, injects nothing. */
@Component({
  selector: 'arena-event-card',
  imports: [DatePipe, MatCardModule, RouterLink],
  template: `
    <a class="contents" [routerLink]="['/events', event().id]" [attr.aria-label]="ariaLabel()">
      <mat-card class="h-full">
        <mat-card-content class="flex h-full flex-col gap-2">
          <h2 class="m-0 text-lg font-medium">{{ event().title }}</h2>
          <p class="m-0">{{ event().venue }}</p>
          <p class="m-0">{{ event().startsAt | date: 'medium' }}</p>
          <ul class="m-0 flex list-none flex-wrap gap-2 p-0">
            <li class="rounded border px-2 py-0.5">{{ sportLabel() }}</li>
            <li class="rounded border px-2 py-0.5">{{ statusLabel() }}</li>
            <li class="rounded border px-2 py-0.5">{{ spotsLabel() }}</li>
          </ul>
        </mat-card-content>
      </mat-card>
    </a>
  `,
})
export class EventCard {
  readonly event = input.required<Event>();

  protected readonly sportLabel = computed(() => SPORT_LABELS[this.event().sport]);
  protected readonly statusLabel = computed(() => EVENT_STATUS_LABELS[this.event().status]);

  protected readonly spotsLabel = computed(() => {
    const spots = this.event().spotsRemaining;
    if (spots <= 0) {
      return 'Full';
    }

    return spots === 1 ? '1 spot left' : `${spots} spots left`;
  });

  protected readonly ariaLabel = computed(() => `${this.event().title}, ${this.statusLabel()}`);
}
