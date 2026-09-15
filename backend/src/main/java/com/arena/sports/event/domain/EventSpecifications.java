package com.arena.sports.event.domain;

import java.time.Instant;

import org.springframework.data.jpa.domain.Specification;

public class EventSpecifications {

    private EventSpecifications() {}

    public static Specification<Event> titleContains(String title) {
        return (root, query, cb) -> (title == null || title.isBlank()) ? null
                : cb.like(cb.lower(root.get("title")), "%" + title.toLowerCase() + "%");
    }

    public static Specification<Event> hasStatus(EventStatus status) {
        return (root, query, cb) -> status == null ? null : cb.equal(root.get("status"), status);
    }

    public static Specification<Event> hasSport(Sport sport) {
        return (root, query, cb) -> sport == null ? null : cb.equal(root.get("sport"), sport);
    }

    public static Specification<Event> venueContains(String venue) {
        return (root, query, cb) -> (venue == null || venue.isBlank()) ? null
                : cb.like(cb.lower(root.get("venue")), "%" + venue.toLowerCase() + "%");
    }

    public static Specification<Event> startsBetween(Instant from, Instant to) {
        return (root, query, cb) -> {
            if (from == null && to == null) {
                return null;
            }
            if (from == null) {
                return cb.lessThanOrEqualTo(root.get("startsAt"), to);
            }
            if (to == null) {
                return cb.greaterThanOrEqualTo(root.get("startsAt"), from);
            }
            return cb.between(root.get("startsAt"), from, to);
        };
    }
}
