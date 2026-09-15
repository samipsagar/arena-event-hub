package com.arena.sports.event.api.dto;

import java.time.Instant;
import java.util.UUID;

import com.arena.sports.event.domain.EventStatus;
import com.arena.sports.event.domain.Sport;

public record EventResponse(UUID id,

                String title,

                String description,

                Sport sport,

                EventStatus status,

                String venue,

                Instant startsAt,

                Instant endsAt,

                int durationInMinutes,

                int participantLimit,

                int registeredParticipants,

                int spotsRemaining,

                Instant createdAt,

                Instant updatedAt) {
}
