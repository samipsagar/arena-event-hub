package com.arena.sports.event.api.dto;

import java.time.Instant;
import com.arena.sports.event.domain.Sport;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import jakarta.validation.constraints.Size;


public record CreateEventRequest(


        @NotBlank @Size(min = 3, max = 120) String title,

        String description,

        @NotBlank @Size(min = 2, max = 120) String venue,

        @NotNull Sport sport,

        @NotNull Instant startsAt,

        @Positive @Max(600) int durationInMinutes,

        @Positive @Max(100000) int participantLimit,

        @PositiveOrZero @Max(100000) int registeredParticipants) {
}
