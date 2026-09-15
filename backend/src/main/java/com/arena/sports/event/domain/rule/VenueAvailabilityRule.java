package com.arena.sports.event.domain.rule;

import com.arena.sports.common.exception.BusinessRuleException;
import com.arena.sports.event.domain.Event;
import com.arena.sports.event.domain.EventRepository;
import com.arena.sports.event.domain.EventStatus;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * A venue can host only one event at a time.
 */
@Order(40)
@Component
public class VenueAvailabilityRule implements EventRule {

    private final EventRepository eventRepository;

    VenueAvailabilityRule(EventRepository eventRepository) {
        this.eventRepository = eventRepository;
    }

    @Override
    public void check(Event event) {
        if (event.getStatus() == EventStatus.CANCELLED) {
            return;
        }

        boolean clashes = eventRepository.existsClashingEvent(event.getVenue(), event.getStartsAt(),
                event.endsAt(), event.getId(), EventStatus.CANCELLED);

        if (clashes) {
            throw new BusinessRuleException("%s is already booked between %s and %s"
                    .formatted(event.getVenue(), event.getStartsAt(), event.endsAt()));
        }
    }
}
