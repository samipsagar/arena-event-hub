package com.arena.sports.event.domain.rule;

import com.arena.sports.common.exception.BusinessRuleException;
import com.arena.sports.event.domain.Event;
import com.arena.sports.event.domain.EventStatus;
import java.time.Clock;
import java.time.Instant;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * A scheduled event must start in the future.
 */
@Order(20)
@Component
public class FutureStartRule implements EventRule {

    private final Clock clock;

    FutureStartRule(Clock clock) {
        this.clock = clock;
    }

    @Override
    public void check(Event event) {
        if (event.getStatus() != EventStatus.SCHEDULED) {
            return;
        }

        Instant now = clock.instant();
        if (!event.getStartsAt().isAfter(now)) {
            throw new BusinessRuleException(
                    "A scheduled event must start in the future, but starts at %s"
                            .formatted(event.getStartsAt()));
        }
    }
}
