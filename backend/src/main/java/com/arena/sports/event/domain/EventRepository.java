package com.arena.sports.event.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.UUID;

public interface EventRepository
                extends JpaRepository<Event, UUID>, JpaSpecificationExecutor<Event> {

        /**
         * Whether another event already occupies {@code venue} during {@code [startsAt, endsAt)}.
         */
        @Query("""
                        select count(e) > 0 from Event e
                        where lower(e.venue) = lower(:venue)
                          and e.status <> :cancelled
                          and e.id <> :excludedId
                          and e.startsAt < :endsAt
                          and timestampadd(minute, e.durationInMinutes, e.startsAt) > :startsAt
                        """)
        boolean existsClashingEvent(@Param("venue") String venue,
                        @Param("startsAt") Instant startsAt, @Param("endsAt") Instant endsAt,
                        @Param("excludedId") UUID excludedId,
                        @Param("cancelled") EventStatus cancelled);
}
