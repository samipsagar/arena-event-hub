import { Service, inject, signal } from '@angular/core';
import { AppError, displayMessage } from '@core/error/app-error';
import { toAppError } from '@core/error/error-mapper';
import { FeedbackService } from '@core/feedback/feedback.service';
import { firstValueFrom } from 'rxjs';
import { EventService } from '../../domain/event.service';
import { EventStore } from '../store/event-store';

export type DeleteState =
  | { readonly kind: 'idle' }
  | { readonly kind: 'running' }
  | { readonly kind: 'success' }
  | { readonly kind: 'failure'; readonly error: AppError };

/** Drives a single delete. A command, not a data source — hence a state union. */
@Service({ autoProvided: false })
export class EventDeleteViewModel {
  private readonly service = inject(EventService);
  private readonly store = inject(EventStore);
  private readonly feedback = inject(FeedbackService);

  private readonly _state = signal<DeleteState>({ kind: 'idle' });
  readonly state = this._state.asReadonly();

  async remove(id: string): Promise<boolean> {
    this._state.set({ kind: 'running' });

    try {
      await firstValueFrom(this.service.remove(id));
      // Write back so returning to the list shows the removal with no refetch.
      this.store.remove(id);
      this._state.set({ kind: 'success' });
      this.feedback.showInfo('Event deleted');
      return true;
    } catch (error: unknown) {
      const appError = toAppError(error);
      this._state.set({ kind: 'failure', error: appError });

      if (appError.kind !== 'cancelled') {
        this.feedback.showError(displayMessage(appError));
      }
      return false;
    }
  }
}
