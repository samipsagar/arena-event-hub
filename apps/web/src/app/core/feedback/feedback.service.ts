export type FeedbackSeverity = 'info' | 'warning' | 'error';

/**
 * Single feedback entry point for the app — a toast/snackbar, without every
 * caller needing to know what shows it.
 */
export abstract class FeedbackService {
  abstract show(severity: FeedbackSeverity, message: string): void;

  showInfo(message: string): void {
    this.show('info', message);
  }

  showWarning(message: string): void {
    this.show('warning', message);
  }

  showError(message: string): void {
    this.show('error', message);
  }
}
