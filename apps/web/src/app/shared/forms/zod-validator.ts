import { AbstractControl, ValidationErrors, ValidatorFn } from '@angular/forms';
import { ZodType } from 'zod';

/** The single key every Zod-sourced failure is filed under. */
export const ZOD_ERROR_KEY = 'zod';

/**
 * Bridges a Zod schema into a Reactive Forms validator, so the schema stays the
 * one place validation rules live rather than being retyped as `Validators.*`
 * and drifting from it.
 */
export function zodValidator(schema: ZodType): ValidatorFn {
  return (control: AbstractControl): ValidationErrors | null => {
    const result = schema.safeParse(control.value);

    return result.success
      ? null
      : { [ZOD_ERROR_KEY]: result.error.issues.map((issue) => issue.message) };
  };
}

/** The messages a control is currently failing on, for display. */
export function zodMessages(control: AbstractControl | null): readonly string[] {
  const errors = control?.errors;
  if (errors === null || errors === undefined) {
    return [];
  }

  return (errors[ZOD_ERROR_KEY] as readonly string[] | undefined) ?? [];
}
