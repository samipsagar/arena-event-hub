import { Service, inject } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { FeedbackService, FeedbackSeverity } from './feedback.service';

/** How long each severity lingers before it dismisses itself. */
function durationMs(severity: FeedbackSeverity): number {
  return severity === 'error' ? 5000 : 3000;
}

/** Backs `FeedbackService` with Material's snack bar. */
@Service()
export class ToastFeedbackService extends FeedbackService {
  private readonly snackBar = inject(MatSnackBar);

  override show(severity: FeedbackSeverity, message: string): void {
    this.snackBar.open(message, 'Dismiss', {
      duration: durationMs(severity),
      panelClass: `feedback-${severity}`,
      politeness: severity === 'error' ? 'assertive' : 'polite',
    });
  }
}
