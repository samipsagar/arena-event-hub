/** One page of a cursor-paginated endpoint. */
export interface CursorPage<T> {
  readonly data: readonly T[];
  readonly nextCursor: string | null;
  readonly hasNext: boolean;
}

/**
 * Parses a page whose items are read by `parseItem`.
 *
 * Hand-written rather than generated — this shape is only ever parsed, never
 * built, same reasoning as `ProblemDetail`.
 */
export function parseCursorPage<T>(json: unknown, parseItem: (item: unknown) => T): CursorPage<T> {
  if (!isRecord(json) || !Array.isArray(json['data'])) {
    throw new Error('Expected a cursor page: an object with a "data" array.');
  }

  const nextCursor = json['nextCursor'];
  const hasNext = json['hasNext'];

  return {
    data: json['data'].map(parseItem),
    nextCursor: typeof nextCursor === 'string' ? nextCursor : null,
    hasNext: typeof hasNext === 'boolean' ? hasNext : false,
  };
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}
