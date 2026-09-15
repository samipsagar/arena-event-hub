import { z } from 'zod';

export const SPORTS_DTO = [
  'FOOTBALL',
  'CRICKET',
  'RUGBY',
  'BASKETBALL',
  'TENNIS',
  'CHESS',
] as const;

export const sportsDtoSchema = z.enum(SPORTS_DTO);

export type SportDto = z.infer<typeof sportsDtoSchema>;
