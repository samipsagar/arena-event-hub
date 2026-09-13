package com.arena.sports.event.domain.rule;

import com.arena.sports.common.exception.BusinessRuleException;
import com.arena.sports.event.domain.Event;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/** An event cannot hold fewer participants than have already registered for it. */
@Order(10)
@Component
public class ParticipantCapacityRule implements EventRule {

    @Override
    public void check(Event event) {
        if (event.getParticipantLimit() >= event.getRegisteredParticipants()) {
            return;
        }

        throw new BusinessRuleException("Participant limit %d is below the %d already registered"
                .formatted(event.getParticipantLimit(), event.getRegisteredParticipants()));
    }
}
