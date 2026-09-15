import { HttpErrorResponse } from '@angular/common/http';
import { TimeoutError } from 'rxjs';
import {
  AppError,
  cancelledError,
  clientError,
  networkError,
  serverError,
  unexpectedError,
} from './app-error';
import { parseProblemDetail } from './problem-detail';

/**
 * Normalises anything that can reach an HTTP call site into an `AppError`.
 *
 * Used by `error.interceptor` at the network edge, and again in `ApiClient`'s
 * `catchError` as a backstop — the same role `toAppException` plays in
 * mobile's repositories and notifiers, so callers only ever switch over the
 * closed union.
 */
export function toAppError(error: unknown): AppError {
  if (isAppError(error)) {
    return error;
  }

  if (error instanceof TimeoutError) {
    return networkError({ message: 'Request timed out.', cause: error });
  }

  if (error instanceof HttpErrorResponse) {
    return mapHttpErrorResponse(error);
  }

  if (error instanceof DOMException && error.name === 'AbortError') {
    return cancelledError({ cause: error });
  }

  return unexpectedError({ cause: error });
}

/**
 * Translates a failing HTTP response into an `AppError`.
 *
 * The backend answers errors with RFC 9457 problem documents
 * (`application/problem+json`), whose `detail` is written for a person to
 * read — "Participant limit 5 is below the 8 already registered." That text
 * is worth far more than a generic string, so 4xx responses surface it.
 *
 * Unlike Dio, Angular's `HttpClient` already separates 2xx from everything
 * else, so — unlike mobile's `ErrorInterceptor`, which has to reject
 * non-2xx responses itself — this is the only mapping step needed.
 */
function mapHttpErrorResponse(response: HttpErrorResponse): AppError {
  // status 0: the request never reached the server at all — no
  // connectivity, a DNS failure, a CORS preflight the browser refused to
  // even report the real reason for. Angular reports all three this way.
  if (response.status === 0) {
    return networkError({ message: 'Unable to connect to the server.', cause: response });
  }

  if (response.status >= 400 && response.status < 500) {
    const problem = parseProblemDetail(response.error);

    return clientError({
      statusCode: response.status,
      message: problem?.detail ?? undefined,
      fieldErrors: problem?.errors,
      cause: response,
    });
  }

  // 5xx, or a non-2xx we have no better name for. Report the status the
  // server actually sent rather than inventing a 500, and keep the body out
  // of the user-facing message: on a 5xx it is either the backend's own
  // generic text or a proxy's error page — neither is ours to trust.
  return serverError({ statusCode: response.status, cause: response });
}

function isAppError(error: unknown): error is AppError {
  return (
    typeof error === 'object' &&
    error !== null &&
    typeof (error as { kind?: unknown }).kind === 'string'
  );
}
