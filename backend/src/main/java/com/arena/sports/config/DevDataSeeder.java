package com.arena.sports.config;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import com.arena.sports.event.domain.Event;
import com.arena.sports.event.domain.EventRepository;
import com.arena.sports.event.domain.EventStatus;
import com.arena.sports.event.domain.Sport;


/**
 * Seeds development data into the database when the application is run with the "dev" profile.
 */
@Component
@Profile("dev")
public class DevDataSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DevDataSeeder.class);

    private static final String VENUE_A = "VenueA";
    private static final String VENUE_B = "VenueB";
    private static final String VENUE_C = "VenueC";

    private final EventRepository eventRepository;

    DevDataSeeder(EventRepository eventRepository) {
        this.eventRepository = eventRepository;
    }

    @Override
    public void run(String... args) {
        if (eventRepository.count() > 0) {
            return;
        }

        Instant now = Instant.now();

        // Every event sits on its own day, so no two share a venue and an overlapping
        // window — the same rule VenueAvailabilityRule enforces on real writes.
        eventRepository.saveAll(List.of(
                basketball(now, -7, "Pre-Season Exhibition", VENUE_C, 10)
                        .status(EventStatus.COMPLETED).build(),
                football(now, 1, "Monday Night Derby", VENUE_A, 14).build(),
                basketball(now, 2, "City League Tip-Off", VENUE_B, 10).build(),
                football(now, 3, "Reserves Friendly", VENUE_C, 8).build(),
                basketball(now, 4, "Midweek Shootout", VENUE_A, 5).build(),
                football(now, 5, "Cup Quarter Final", VENUE_B, 20).build(),
                basketball(now, 6, "Junior Development Game", VENUE_C, 1).build(),
                football(now, 7, "Saturday Grand Final", VENUE_A, 11).build(),
                basketball(now, 8, "Inter-Club Playoff", VENUE_B, 9).build(),
                football(now, 9, "Summer Sevens", VENUE_C, 0).build(),
                basketball(now, 10, "Weekend Classic", VENUE_A, 6).build(),
                football(now, 11, "Charity Match", VENUE_B, 3)
                        .status(EventStatus.CANCELLED).build()));

        log.info("Seeded {} development events", eventRepository.count());
    }

    private static Event.Builder football(Instant now, int daysFromNow, String title, String venue,
            int registered) {
        return seed(now, daysFromNow, title, venue, registered)
                .description("Eleven a side, full match.")
                .sport(Sport.FOOTBALL).durationInMinutes(90).participantLimit(22);
    }

    private static Event.Builder basketball(Instant now, int daysFromNow, String title,
            String venue, int registered) {
        return seed(now, daysFromNow, title, venue, registered)
                .description("Four quarters, running clock.")
                .sport(Sport.BASKETBALL).durationInMinutes(48).participantLimit(10);
    }

    private static Event.Builder seed(Instant now, int daysFromNow, String title, String venue,
            int registered) {
        return Event.builder().id(UUID.randomUUID()).status(EventStatus.SCHEDULED).title(title)
                .venue(venue).startsAt(now.plus(daysFromNow, ChronoUnit.DAYS))
                .registeredParticipants(registered).createdAt(now).updatedAt(now);
    }
}
