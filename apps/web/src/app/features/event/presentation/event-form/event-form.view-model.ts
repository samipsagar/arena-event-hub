import { Service, inject, signal } from '@angular/core';
import { AppError, displayMessage } from '@core/error/app-error';
import { toAppError } from '@core/error/error-mapper';
import { FeedbackService } from '@core/feedback/feedback.service';
import { firstValueFrom } from 'rxjs';
import { Event } from '../../domain/entity/event';
import { EventFormData } from '../../domain/entity/event-form-data';
import { EventService } from '../../domain/event.service';
import { EventStore } from '../store/event-store';

export type FormState =
  | { readonly kind: 'idle' }
  | { readonly kind: 'submitting' }
  | { readonly kind: 'success'; readonly event: Event }
  | { readonly kind: 'failure'; readonly error: AppError };

/** Drives a single create/update submission. */
@Service({ autoProvided: false })
export class EventFormViewModel {
  private readonly service = inject(EventService);
  private readonly store = inject(EventStore);
  private readonly feedback = inject(FeedbackService);

  private readonly _state = signal<FormState>({ kind: 'idle' });
  readonly state = this._state.asReadonly();

  async save(formData: EventFormData): Promise<Event | null> {
    this._state.set({ kind: 'submitting' });

    try {
      const event = await firstValueFrom(this.service.save(formData));

      // Write back so the list reflects the change with no refetch.
      this.store.upsert(event);
      this._state.set({ kind: 'success', event });
      this.feedback.showInfo(formData.id ? 'Event updated' : 'Event created');
      return event;
    } catch (error: unknown) {
      const appError = toAppError(error);
      this._state.set({ kind: 'failure', error: appError });

      if (appError.kind !== 'cancelled') {
        this.feedback.showError(displayMessage(appError));
      }
      return null;
    }
  }

  /**
   * Field errors the backend reported — the `errors` map `ProblemDetail`
   * carries on a 400, already parsed into `"field: message"` strings.
   */
  serverFieldErrors(): readonly string[] {
    const state = this._state();
    if (state.kind !== 'failure' || state.error.kind !== 'client') {
      return [];
    }

    return state.error.fieldErrors;
  }
}
