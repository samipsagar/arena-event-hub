package com.arena.sports.event.domain;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Instant;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest;
import org.springframework.boot.jdbc.test.autoconfigure.AutoConfigureTestDatabase;
import org.springframework.boot.jdbc.test.autoconfigure.AutoConfigureTestDatabase.Replace;

/**
 * Integration tests for the persistence layer: a real schema built by Flyway and real SQL, but no
 * HTTP. {@code replace = NONE} keeps the application's own H2 datasource so the migrations under
 * test are the ones that ship.
 */
@DataJpaTest
@AutoConfigureTestDatabase(replace = Replace.NONE)
class EventRepositoryTest {

    private static final Instant KICK_OFF = Instant.parse("2027-01-01T10:00:00Z");

    @Autowired
    private EventRepository eventRepository;

    @Test
    void savesAnEventAndReadsItBack() {
        Event saved = eventRepository.save(event("Final", "Wembley", KICK_OFF, 90));

        Event found = eventRepository.findById(saved.getId()).orElseThrow();

        assertThat(found.getTitle()).isEqualTo("Final");
        assertThat(found.getVenue()).isEqualTo("Wembley");
        assertThat(found.getSport()).isEqualTo(Sport.FOOTBALL);
        assertThat(found.getStatus()).isEqualTo(EventStatus.SCHEDULED);
    }

    @Test
    void findsAnEventAlreadyBookedIntoTheSameVenueAndSlot() {
        eventRepository.save(event("Final", "Wembley", KICK_OFF, 90));

        // Starts 30 minutes in, so it overlaps the 90-minute booking above.
        boolean clashes = eventRepository.existsClashingEvent("Wembley",
                KICK_OFF.plusSeconds(1800), KICK_OFF.plusSeconds(5400), UUID.randomUUID(),
                EventStatus.CANCELLED);

        assertThat(clashes).isTrue();
    }

    @Test
    void ignoresACancelledEventWhenLookingForAClash() {
        Event cancelled = event("Called off", "Wembley", KICK_OFF, 90);
        cancelled.setStatus(EventStatus.CANCELLED);
        eventRepository.save(cancelled);

        boolean clashes = eventRepository.existsClashingEvent("Wembley", KICK_OFF,
                KICK_OFF.plusSeconds(5400), UUID.randomUUID(), EventStatus.CANCELLED);

        assertThat(clashes).isFalse();
    }

    @Test
    void doesNotSeeAClashInADifferentVenue() {
        eventRepository.save(event("Final", "Wembley", KICK_OFF, 90));

        boolean clashes = eventRepository.existsClashingEvent("Old Trafford", KICK_OFF,
                KICK_OFF.plusSeconds(5400), UUID.randomUUID(), EventStatus.CANCELLED);

        assertThat(clashes).isFalse();
    }

    private static Event event(String title, String venue, Instant startsAt, int minutes) {
        Instant now = Instant.parse("2026-01-01T00:00:00Z");
        return Event.builder().id(UUID.randomUUID()).title(title).description("A match")
                .sport(Sport.FOOTBALL).status(EventStatus.SCHEDULED).venue(venue)
                .startsAt(startsAt).durationInMinutes(minutes).participantLimit(20)
                .registeredParticipants(0).createdAt(now).updatedAt(now).build();
    }
}
