import { QueryParams } from '@core/http/api-client';
import { EventQuery } from '../../domain/event-query';

export function queryToParams(query: EventQuery): QueryParams {
  const title = query.title?.trim() ?? '';

  return {
    status: query.status,
    sport: query.sport,
    ...(title.length > 0 ? { title } : {}),
  };
}
