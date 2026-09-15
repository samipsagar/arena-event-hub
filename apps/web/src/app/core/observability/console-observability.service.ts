import { Service } from '@angular/core';
import { LogContext, LogLevel, ObservabilityService } from './observability.service';

/** Which `console` method each level lands on. */
const SINKS: Record<LogLevel, (message: string, ...rest: unknown[]) => void> = {
  debug: console.debug,
  info: console.info,
  warning: console.warn,
  error: console.error,
};

/** Writes to the browser console. The only implementation today. */
@Service()
export class ConsoleObservabilityService extends ObservabilityService {
  override log(level: LogLevel, message: string, context?: LogContext): void {
    const line = `[arena] ${message}`;

    // Passed as a second argument rather than interpolated so DevTools renders
    // it as an inspectable object.
    if (context === undefined) {
      SINKS[level](line);
    } else {
      SINKS[level](line, context);
    }
  }
}
