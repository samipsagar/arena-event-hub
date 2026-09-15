import { Component, computed, input } from '@angular/core';

/**
 * Renders a control's validation messages, once it has been touched — so a
 * blank form does not open covered in complaints.
 *
 * Point the control's `aria-describedby` at this element's id: the host is
 * always in the DOM, so the reference stays valid whether or not it has
 * anything to say.
 */
@Component({
  selector: 'arena-field-errors',
  template: `
    @if (show()) {
      <ul class="m-0 list-none p-0 text-sm" role="alert">
        @for (message of messages(); track message) {
          <li>{{ message }}</li>
        }
      </ul>
    }
  `,
})
export class FieldErrors {
  readonly messages = input.required<readonly string[]>();
  readonly touched = input.required<boolean>();

  protected readonly show = computed(() => this.touched() && this.messages().length > 0);
}
