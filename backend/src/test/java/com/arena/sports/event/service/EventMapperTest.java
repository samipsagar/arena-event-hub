package com.arena.sports.event.service;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Instant;
import java.util.UUID;

import org.junit.jupiter.api.Test;

import com.arena.sports.event.api.dto.CreateEventRequest;
import com.arena.sports.event.api.dto.EventResponse;
import com.arena.sports.event.api.dto.PatchEventRequest;
import com.arena.sports.event.api.dto.UpdateEventRequest;
import com.arena.sports.event.domain.Event;
import com.arena.sports.event.domain.EventStatus;
import com.arena.sports.event.domain.Sport;

/**
 * Unit tests: no Spring context, no database. The mapper and the status enum
 * are the only places
 * with real branching logic, so they are the only things worth testing in
 * isolation.
 */
class EventMapperTest {

    private static final Instant STARTS_AT = Instant.parse("2027-01-01T10:00:00Z");

    private final EventMapper mapper = new EventMapper();

    @Test
    void aNewEventStartsOutScheduled() {
        Event event = mapper.toEntity(new CreateEventRequest("Final", "The decider", "Arena",
                Sport.FOOTBALL, STARTS_AT, 90, 20, 0));

        assertThat(event.getStatus()).isEqualTo(EventStatus.SCHEDULED);
        assertThat(event.getId()).isNotNull();
        assertThat(event.getTitle()).isEqualTo("Final");
    }

    @Test
    void theResponseWorksOutHowManySpotsAreLeft() {
        EventResponse response = mapper.toResponse(existingEvent());

        assertThat(response.participantLimit()).isEqualTo(10);
        assertThat(response.registeredParticipants()).isEqualTo(4);
        assertThat(response.spotsRemaining()).isEqualTo(6);
    }

    @Test
    void aFullUpdateReplacesEveryEditableField() {
        Event event = existingEvent();

        mapper.fromUpdateRequest(event, new UpdateEventRequest("Renamed", "New desc", "New Arena",
                Sport.BASKETBALL, EventStatus.LIVE, STARTS_AT.plusSeconds(3600), 45, 20, 5));

        assertThat(event.getTitle()).isEqualTo("Renamed");
        assertThat(event.getVenue()).isEqualTo("New Arena");
        assertThat(event.getSport()).isEqualTo(Sport.BASKETBALL);
        assertThat(event.getStatus()).isEqualTo(EventStatus.LIVE);
        assertThat(event.getParticipantLimit()).isEqualTo(20);
        assertThat(event.getRegisteredParticipants()).isEqualTo(5);
    }

    @Test
    void aPatchLeavesOmittedFieldsAlone() {
        Event event = existingEvent();

        // Every field but the title is null, which has to mean "unchanged" rather than
        // "set to 0".
        mapper.applyPatch(event,
                new PatchEventRequest("Renamed", null, null, null, null, null, null, null));

        assertThat(event.getTitle()).isEqualTo("Renamed");
        assertThat(event.getVenue()).isEqualTo("Original Arena");
        assertThat(event.getDurationInMinutes()).isEqualTo(90);
        assertThat(event.getParticipantLimit()).isEqualTo(10);
        assertThat(event.getStatus()).isEqualTo(EventStatus.SCHEDULED);
    }

    @Test
    void theStatusLifecycleAllowsOnlyLegalMoves() {
        assertThat(EventStatus.SCHEDULED.canTransitionTo(EventStatus.LIVE)).isTrue();
        assertThat(EventStatus.SCHEDULED.canTransitionTo(EventStatus.CANCELLED)).isTrue();
        assertThat(EventStatus.LIVE.canTransitionTo(EventStatus.COMPLETED)).isTrue();

        // Skipping a step, and reviving a finished event, are both refused.
        assertThat(EventStatus.SCHEDULED.canTransitionTo(EventStatus.COMPLETED)).isFalse();
        assertThat(EventStatus.COMPLETED.canTransitionTo(EventStatus.SCHEDULED)).isFalse();

        // Staying put always counts, so a PUT can restate the current status.
        assertThat(EventStatus.LIVE.canTransitionTo(EventStatus.LIVE)).isTrue();
    }

    private static Event existingEvent() {
        return Event.builder().id(UUID.randomUUID()).title("Original").description("Original desc")
                .sport(Sport.FOOTBALL).status(EventStatus.SCHEDULED).venue("Original Arena")
                .startsAt(STARTS_AT).durationInMinutes(90).participantLimit(10)
                .registeredParticipants(4).createdAt(STARTS_AT).updatedAt(STARTS_AT).build();
    }
}
