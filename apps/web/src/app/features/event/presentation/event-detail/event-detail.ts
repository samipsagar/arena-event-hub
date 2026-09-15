import { DatePipe } from '@angular/common';
import { Component, effect, inject, input } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { displayMessage } from '@core/error/app-error';
import { toAppError } from '@core/error/error-mapper';
import { Routes } from '@core/routing/routes';
import { ConfirmDialog } from '@shared/ui/confirm-dialog/confirm-dialog';
import { Router, RouterLink } from '@angular/router';
import { EVENT_STATUS_LABELS } from '../../domain/entity/event-status';
import { SPORT_LABELS } from '../../domain/entity/sport';
import { EventDeleteViewModel } from './event-delete.view-model';
import { EventDetailViewModel } from './event-detail.view-model';

@Component({
  selector: 'arena-event-detail',
  imports: [DatePipe, RouterLink, MatButtonModule, MatCardModule, MatProgressSpinnerModule],
  providers: [EventDetailViewModel, EventDeleteViewModel],
  host: { class: 'mx-auto block max-w-3xl p-6' },
  templateUrl: './event-detail.html',
})
export class EventDetail {
  /** Bound from the `:id` route param via `withComponentInputBinding()`. */
  readonly id = input.required<string>();

  protected readonly viewModel = inject(EventDetailViewModel);
  protected readonly deleteViewModel = inject(EventDeleteViewModel);

  private readonly router = inject(Router);
  private readonly confirmDialog = inject(ConfirmDialog);

  protected readonly sportLabels = SPORT_LABELS;
  protected readonly statusLabels = EVENT_STATUS_LABELS;
  protected readonly routes = Routes;
  protected readonly displayMessage = displayMessage;
  protected readonly toAppError = toAppError;

  constructor() {
    effect(() => this.viewModel.eventId.set(this.id()));
  }

  protected async confirmDelete(): Promise<void> {
    const confirmed = await this.confirmDialog.ask({
      title: 'Delete event?',
      message: 'This cannot be undone.',
      confirmLabel: 'Delete',
    });
    if (!confirmed) {
      return;
    }

    if (await this.deleteViewModel.remove(this.id())) {
      void this.router.navigateByUrl(Routes.events);
    }
  }
}
