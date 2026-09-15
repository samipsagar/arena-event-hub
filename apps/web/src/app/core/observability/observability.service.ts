/** Matches mobile's `LogLevel` so the two apps read alike. */
export type LogLevel = 'debug' | 'info' | 'warning' | 'error';

export type LogContext = Readonly<Record<string, unknown>>;

/**
 * Single logging entry point, so callers never reach for `console` directly
 * and the sink stays swappable. The logging half of mobile's
 * `ObservabilityService` — breadcrumbs, event capture and context tagging are
 * deliberately absent until something needs them.
 */
export abstract class ObservabilityService {
  abstract log(level: LogLevel, message: string, context?: LogContext): void;

  debug(message: string, context?: LogContext): void {
    this.log('debug', message, context);
  }

  info(message: string, context?: LogContext): void {
    this.log('info', message, context);
  }

  warning(message: string, context?: LogContext): void {
    this.log('warning', message, context);
  }

  error(message: string, context?: LogContext): void {
    this.log('error', message, context);
  }
}
