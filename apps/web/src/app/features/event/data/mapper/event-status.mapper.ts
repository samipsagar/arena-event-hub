import { EventStatus } from '../../domain/entity/event-status';
import { EventStatusDto } from '../dto/event-status.dto';

/** Identity at runtime; see `sport.mapper.ts` for why both directions are total. */
export function statusToDomain(value: EventStatusDto): EventStatus {
  return value;
}

export function statusToDto(status: EventStatus): EventStatusDto {
  return status;
}
