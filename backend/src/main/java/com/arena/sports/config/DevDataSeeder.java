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

        eventRepository.saveAll(List.of(
                seed(now).title("A League Final").description("The season decider.")
                        .sport(Sport.FOOTBALL).venue("Melbourne Arena")
                        .startsAt(now.plus(7, ChronoUnit.DAYS)).durationInMinutes(90)
                        .participantLimit(22).build(),
                seed(now).title("Open Singles Semi").description("Best of three sets.")
                        .sport(Sport.TENNIS).venue("Centre Court")
                        .startsAt(now.plus(14, ChronoUnit.DAYS)).durationInMinutes(120)
                        .participantLimit(2).build()));

        log.info("Seeded {} development events", eventRepository.count());
    }

    private static Event.Builder seed(Instant now) {
        return Event.builder().id(UUID.randomUUID()).status(EventStatus.SCHEDULED)
                .registeredParticipants(0).createdAt(now).updatedAt(now);
    }
}
