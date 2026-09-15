import { Sport } from '../../domain/entity/sport';
import { SportDto } from '../dto/event.sports.dto';

export function sportToDomain(value: SportDto): Sport {
  return value;
}

export function sportToDto(sport: Sport): SportDto {
  return sport;
}
