/**
 * An RFC 9457 problem+json body, as the backend's `GlobalExceptionHandler`
 * sends it.
 *
 * Hand-written rather than generated: this is only ever parsed, never built,
 * and `errors` comes in two shapes depending on which handler produced it —
 * a map of field name to message (validation failures), or a list of
 * `{detail, pointer}` objects (the SmartBear problem-details convention).
 */
export interface ProblemDetail {
  /** Safe to show to a user as-is. */
  readonly detail: string | null;

  /**
   * Field-level messages, formatted as `"field: message"` (or just the
   * message when there's no field name to attach). Empty when the body
   * carried no `errors`, or `errors` wasn't a shape we recognise.
   */
  readonly errors: readonly string[];
}

/** Parses a problem document, or returns null if `json` isn't one. */
export function parseProblemDetail(json: unknown): ProblemDetail | null {
  if (!isRecord(json)) {
    return null;
  }

  const detail = typeof json['detail'] === 'string' ? json['detail'].trim() : '';

  return {
    detail: detail.length === 0 ? null : detail,
    errors: parseErrors(json['errors']),
  };
}

function parseErrors(errors: unknown): readonly string[] {
  if (isRecord(errors)) {
    return Object.entries(errors)
      .filter((entry): entry is [string, string] => typeof entry[1] === 'string')
      .map(([field, message]) => `${field}: ${message}`);
  }

  if (Array.isArray(errors)) {
    return errors.flatMap((item) => {
      if (typeof item === 'string') return [item];
      if (isRecord(item)) return errorFromPointer(item);
      return [];
    });
  }

  return [];
}

function errorFromPointer(item: Record<string, unknown>): readonly string[] {
  const detail = typeof item['detail'] === 'string' ? item['detail'].trim() : '';
  if (detail.length === 0) {
    return [];
  }

  const pointer = item['pointer'];
  if (typeof pointer === 'string' && pointer.length > 0) {
    const field = pointer
      .split('/')
      .filter((segment) => segment.length > 0)
      .join('.');
    if (field.length > 0) {
      return [`${field}: ${detail}`];
    }
  }

  return [detail];
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}
