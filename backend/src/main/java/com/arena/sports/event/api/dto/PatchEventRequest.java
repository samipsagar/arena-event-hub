package com.arena.sports.event.api.dto;

import java.time.Instant;

import com.arena.sports.event.domain.EventStatus;
import com.arena.sports.event.domain.Sport;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

/**
 * Every field is optional: null means "leave unchanged". Numbers are boxed so that an omitted
 * value arrives as null rather than 0.
 */
public record PatchEventRequest(

                @Size(min = 3, max = 120) String title,

                String description,

                @Size(min = 2, max = 120) String venue,

                Sport sport,

                EventStatus status,

                Instant startsAt,

                @Positive @Max(600) Integer durationInMinutes,

                @Positive @Max(100000) Integer participantLimit) {
}
