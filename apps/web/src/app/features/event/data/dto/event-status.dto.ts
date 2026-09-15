import { z } from 'zod';

export const EVENT_STATUSES_DTO = ['SCHEDULED', 'LIVE', 'COMPLETED', 'CANCELLED'] as const;

export const eventStatusSchema = z.enum(EVENT_STATUSES_DTO);
export type EventStatusDto = z.infer<typeof eventStatusSchema>;
