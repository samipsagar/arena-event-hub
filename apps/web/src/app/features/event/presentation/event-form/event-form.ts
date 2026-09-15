import { DestroyRef, Component, computed, effect, inject, input, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import {
  AbstractControl,
  FormBuilder,
  ReactiveFormsModule,
  ValidationErrors,
  ValidatorFn,
} from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { Router, RouterLink } from '@angular/router';
import { Routes } from '@core/routing/routes';
import { FieldErrors } from '@shared/ui/field-errors/field-errors';
import { ZOD_ERROR_KEY, zodMessages, zodValidator } from '@shared/forms/zod-validator';
import { addDays, format, parse } from 'date-fns';
import {
  EVENT_STATUS_LABELS,
  EventStatus,
  allowedTransitions,
} from '../../domain/entity/event-status';
import { EventFormData } from '../../domain/entity/event-form-data';
import { SPORTS, SPORT_LABELS, Sport } from '../../domain/entity/sport';
import { eventFormFields } from '../../domain/event-form-schema';
import { EventService } from '../../domain/event.service';
import { EventFormViewModel } from './event-form.view-model';

const DATE_TIME_LOCAL = "yyyy-MM-dd'T'HH:mm";

function toDateTimeLocal(date: Date): string {
  return format(date, DATE_TIME_LOCAL);
}

function fromDateTimeLocal(value: string): Date {
  return parse(value, DATE_TIME_LOCAL, new Date());
}

/**
 * Mobile checks this inside the registered-participants validator, reading the
 * limit field alongside it, so this does the same rather than hanging a
 * group-level validator off the form.
 */
const withinParticipantLimit: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
  const limit: unknown = control.parent?.get('participantLimit')?.value;
  const registered: unknown = control.value;

  if (typeof limit !== 'number' || typeof registered !== 'number' || registered <= limit) {
    return null;
  }

  return { [ZOD_ERROR_KEY]: ['Cannot exceed the participant limit.'] };
};

@Component({
  selector: 'arena-event-form',
  imports: [
    FieldErrors,
    ReactiveFormsModule,
    RouterLink,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
  ],
  providers: [EventFormViewModel],
  host: { class: 'mx-auto block max-w-3xl p-6' },
  templateUrl: './event-form.html',
})
export class EventForm {
  /** Present on `/events/:id/edit`, absent on `/events/new`. */
  readonly id = input<string | undefined>(undefined);

  protected readonly viewModel = inject(EventFormViewModel);
  private readonly service = inject(EventService);
  private readonly router = inject(Router);
  private readonly destroyRef = inject(DestroyRef);
  private readonly formBuilder = inject(FormBuilder);

  protected readonly sports = SPORTS;
  protected readonly sportLabels = SPORT_LABELS;
  protected readonly statusLabels = EVENT_STATUS_LABELS;
  protected readonly routes = Routes;
  protected readonly zodMessages = zodMessages;

  protected readonly form = this.formBuilder.nonNullable.group({
    title: ['', zodValidator(eventFormFields.title)],
    description: ['', zodValidator(eventFormFields.description)],
    venue: ['', zodValidator(eventFormFields.venue)],
    sport: ['FOOTBALL' as Sport, zodValidator(eventFormFields.sport)],
    status: ['SCHEDULED' as EventStatus, zodValidator(eventFormFields.status)],
    startsAt: [
      // Matches mobile's default: same time tomorrow, not "start of next day".
      toDateTimeLocal(addDays(new Date(), 1)),
      zodValidator(eventFormFields.startsAt),
    ],
    durationInMinutes: [60, zodValidator(eventFormFields.durationInMinutes)],
    participantLimit: [10, zodValidator(eventFormFields.participantLimit)],
    registeredParticipants: [
      0,
      [zodValidator(eventFormFields.registeredParticipants), withinParticipantLimit],
    ],
  });

  protected readonly isEdit = computed(() => this.id() !== undefined);

  /** The status the event arrived with — what legal transitions are measured from. */
  private readonly loadedStatus = signal<EventStatus | null>(null);

  /**
   * Editing renders before the event arrives. Submitting in that window would
   * send a blank status, which `formDataToUpdateRequest` throws on.
   */
  protected readonly isSeeding = computed(() => this.isEdit() && this.loadedStatus() === null);

  /** Legal targets from the current status, mirroring the backend's transition map. */
  protected readonly statusOptions = computed<readonly EventStatus[]>(() => {
    if (!this.isEdit()) {
      return ['SCHEDULED'];
    }

    const status = this.loadedStatus();
    return status === null ? [] : allowedTransitions(status);
  });

  constructor() {
    // Reactive, not a one-shot check: `id` isn't set yet when the
    // constructor runs, so `isEdit()` would read false even on the edit
    // route and disable the control before the real id ever arrives.
    effect(() => {
      if (this.statusOptions().length > 1) {
        this.form.controls.status.enable();
      } else {
        this.form.controls.status.disable();
      }
    });

    // The capacity rule reads its sibling, so it has to be re-run when that
    // sibling changes rather than only when its own control does.
    this.form.controls.participantLimit.valueChanges
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe(() =>
        this.form.controls.registeredParticipants.updateValueAndValidity({ emitEvent: false }),
      );

    effect(() => {
      const id = this.id();
      if (id === undefined) {
        return;
      }

      // Editing: seed from the server rather than trusting whatever the list
      // happened to have.
      this.service
        .loadEvent(id)
        .pipe(takeUntilDestroyed(this.destroyRef))
        .subscribe((event) => {
          this.loadedStatus.set(event.status);
          this.form.setValue({
            title: event.title,
            description: event.description,
            venue: event.venue,
            sport: event.sport,
            status: event.status,
            startsAt: toDateTimeLocal(event.startsAt),
            durationInMinutes: event.durationInMinutes,
            participantLimit: event.participantLimit,
            registeredParticipants: event.registeredParticipants,
          });
        });
    });
  }

  protected async submit(): Promise<void> {
    if (this.viewModel.state().kind === 'submitting' || this.isSeeding()) {
      return;
    }

    // Touching every control is what makes the messages visible: an untouched
    // control stays quiet, so an invalid form would otherwise just do nothing.
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    const saved = await this.viewModel.save(this.toFormData());
    if (saved) {
      void this.router.navigateByUrl(Routes.eventDetail(saved.id));
    }
  }

  private toFormData(): EventFormData {
    const value = this.form.getRawValue();

    return {
      id: this.id(),
      title: value.title,
      description: value.description,
      venue: value.venue,
      sport: value.sport,
      status: value.status,
      startsAt: fromDateTimeLocal(value.startsAt),
      durationInMinutes: value.durationInMinutes,
      participantLimit: value.participantLimit,
      registeredParticipants: value.registeredParticipants,
    };
  }
}
