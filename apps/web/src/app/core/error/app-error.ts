/** Every failure the app surfaces, in one closed union. */
export type AppError =
  ClientError | ServerError | NetworkError | CancelledError | ParsingError | UnexpectedError;

interface AppBaseError {
  readonly message: string;
  readonly cause?: unknown;
}

/** A 4xx: the request was wrong, and the backend usually says how. */
export interface ClientError extends AppBaseError {
  readonly kind: 'client';
  readonly statusCode: number;
  /** Field-level messages from the backend's `ProblemDetail.errors`. */
  readonly fieldErrors: readonly string[];
}

/** A 5xx, or a status we have no better name for. */
export interface ServerError extends AppBaseError {
  readonly kind: 'server';
  readonly statusCode: number;
}

/** The request never produced a response: no connectivity, timeout, bad TLS. */
export interface NetworkError extends AppBaseError {
  readonly kind: 'network';
}

export interface CancelledError extends AppBaseError {
  readonly kind: 'cancelled';
}

/** The response arrived but did not look the way we expected. */
export interface ParsingError extends AppBaseError {
  readonly kind: 'parsing';
}

/** Something failed that we have no mapping for. */
export interface UnexpectedError extends AppBaseError {
  readonly kind: 'unexpected';
}

export function clientError(options: {
  statusCode: number;
  message?: string;
  fieldErrors?: readonly string[];
  cause?: unknown;
}): ClientError {
  return {
    kind: 'client',
    statusCode: options.statusCode,
    message: options.message ?? 'The request could not be completed.',
    fieldErrors: options.fieldErrors ?? [],
    cause: options.cause,
  };
}

export function serverError(options: {
  statusCode: number;
  message?: string;
  cause?: unknown;
}): ServerError {
  return {
    kind: 'server',
    statusCode: options.statusCode,
    message: options.message ?? 'Something went wrong on our side. Please try again.',
    cause: options.cause,
  };
}

export function networkError(options: { message?: string; cause?: unknown } = {}): NetworkError {
  return {
    kind: 'network',
    message: options.message ?? 'Network error. Please check your connection and try again.',
    cause: options.cause,
  };
}

export function cancelledError(
  options: { message?: string; cause?: unknown } = {},
): CancelledError {
  return {
    kind: 'cancelled',
    message: options.message ?? 'The request was cancelled.',
    cause: options.cause,
  };
}

export function parsingError(options: { message?: string; cause?: unknown } = {}): ParsingError {
  return {
    kind: 'parsing',
    message: options.message ?? 'Failed to parse the response.',
    cause: options.cause,
  };
}

export function unexpectedError(
  options: { message?: string; cause?: unknown } = {},
): UnexpectedError {
  return {
    kind: 'unexpected',
    message: options.message ?? 'Unexpected error. Please try again.',
    cause: options.cause,
  };
}

/** The message plus any field errors, one per line */
export function displayMessage(error: AppError): string {
  if (error.kind === 'client' && error.fieldErrors.length > 0) {
    return [error.message, ...error.fieldErrors].join('\n');
  }

  return error.message;
}
