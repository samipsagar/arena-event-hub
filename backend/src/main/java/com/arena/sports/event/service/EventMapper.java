package com.arena.sports.event.service;

import java.time.Instant;
import java.util.UUID;

import com.arena.sports.event.api.dto.CreateEventRequest;
import com.arena.sports.event.api.dto.PatchEventRequest;
import com.arena.sports.event.api.dto.EventResponse;
import com.arena.sports.event.api.dto.UpdateEventRequest;
import com.arena.sports.event.domain.Event;
import com.arena.sports.event.domain.EventStatus;
import org.springframework.stereotype.Component;

@Component
public class EventMapper {
    public Event toEntity(CreateEventRequest request) {
        Instant now = Instant.now();
        return Event.builder().id(UUID.randomUUID()).title(request.title())
                .description(request.description()).sport(request.sport())
                .status(EventStatus.SCHEDULED).venue(request.venue()).startsAt(request.startsAt())
                .durationInMinutes(request.durationInMinutes())
                .participantLimit(request.participantLimit())
                .registeredParticipants(request.registeredParticipants()).createdAt(now)
                .updatedAt(now).build();
    }

    public EventResponse toResponse(Event event) {
        return new EventResponse(event.getId(), event.getTitle(), event.getDescription(),
                event.getSport(), event.getStatus(), event.getVenue(), event.getStartsAt(),
                event.endsAt(), event.getDurationInMinutes(), event.getParticipantLimit(),
                event.getRegisteredParticipants(),
                Math.max(0, event.getParticipantLimit() - event.getRegisteredParticipants()), // remaining
                                                                                              // participants
                event.getCreatedAt(), event.getUpdatedAt());
    }


    public Event fromUpdateRequest(Event existingEvent, UpdateEventRequest request) {
        existingEvent.setTitle(request.title());
        existingEvent.setDescription(request.description());
        existingEvent.setSport(request.sport());
        existingEvent.setStatus(request.status());
        existingEvent.setVenue(request.venue());
        existingEvent.setStartsAt(request.startsAt());
        existingEvent.setDurationInMinutes(request.durationInMinutes());
        existingEvent.setParticipantLimit(request.participantLimit());
        existingEvent.setRegisteredParticipants(request.registeredParticipants());
        existingEvent.setUpdatedAt(Instant.now());
        return existingEvent;
    }

    public Event applyPatch(Event existingEvent, PatchEventRequest request) {
        if (request.title() != null) {
            existingEvent.setTitle(request.title());
        }
        if (request.description() != null) {
            existingEvent.setDescription(request.description());
        }
        if (request.venue() != null) {
            existingEvent.setVenue(request.venue());
        }
        if (request.sport() != null) {
            existingEvent.setSport(request.sport());
        }
        if (request.status() != null) {
            existingEvent.setStatus(request.status());
        }
        if (request.startsAt() != null) {
            existingEvent.setStartsAt(request.startsAt());
        }
        if (request.durationInMinutes() != null) {
            existingEvent.setDurationInMinutes(request.durationInMinutes());
        }
        if (request.participantLimit() != null) {
            existingEvent.setParticipantLimit(request.participantLimit());
        }

        existingEvent.setUpdatedAt(Instant.now());
        return existingEvent;
    }
}
