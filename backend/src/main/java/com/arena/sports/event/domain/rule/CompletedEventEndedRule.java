package com.arena.sports.event.domain.rule;

import com.arena.sports.common.exception.BusinessRuleException;
import com.arena.sports.event.domain.Event;
import com.arena.sports.event.domain.EventStatus;
import java.time.Clock;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/** An event cannot be marked completed before it has actually finished. */
@Order(30)
@Component
public class CompletedEventEndedRule implements EventRule {

    private final Clock clock;

    CompletedEventEndedRule(Clock clock) {
        this.clock = clock;
    }

    @Override
    public void check(Event event) {
        if (event.getStatus() != EventStatus.COMPLETED) {
            return;
        }

        if (event.endsAt().isAfter(clock.instant())) {
            throw new BusinessRuleException(
                    "An event cannot be completed before it has ended, it ends at %s"
                            .formatted(event.endsAt()));
        }
    }
}
