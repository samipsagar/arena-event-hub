import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { REQUEST_TIMEOUT_MS } from '@core/config/config';
import { catchError, throwError, timeout } from 'rxjs';
import { ObservabilityService } from '../observability/observability.service';
import { toAppError } from '../error/error-mapper';

/**
 * Turns every HTTP failure into an `AppError` before it leaves the network
 * layer, so nothing above `core/http` has to know `HttpErrorResponse` exists.
 *
 * Also the one place every failure is guaranteed to pass through: upstream
 * callers swallow `cancelled` and surface the rest as toasts or error panels,
 * so logging here is what makes any of it visible.
 */
export const errorInterceptor: HttpInterceptorFn = (req, next) => {
  const observability = inject(ObservabilityService);

  return next(req).pipe(
    timeout(REQUEST_TIMEOUT_MS),
    catchError((error: unknown) => {
      const appError = toAppError(error);

      // A cancelled request is routine — a superseded search keystroke, a
      // navigation away — so it is noise at anything above debug.
      const level = appError.kind === 'cancelled' ? 'debug' : 'error';
      observability.log(level, `${req.method} ${req.urlWithParams} failed`, {
        kind: appError.kind,
        message: appError.message,
        cause: appError.cause,
      });

      return throwError(() => appError);
    }),
  );
};
