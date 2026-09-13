package com.arena.sports.event.domain.rule;

import com.arena.sports.common.exception.BusinessRuleException;
import com.arena.sports.event.domain.Event;
import java.util.List;
import org.springframework.stereotype.Component;

/**
 * A collection of {@link EventRule}s that must be satisfied for an event to be valid. If any rule
 * is violated, the event cannot be created or updated. throws a {@link BusinessRuleException} if
 * any rule is violated.
 */
@Component
public class EventRules {

    private final List<EventRule> rules;

    EventRules(List<EventRule> rules) {
        this.rules = rules;
    }

    /**
     * @throws BusinessRuleException on the first rule the event violates
     */
    public void check(Event event) {
        rules.forEach(rule -> rule.check(event));
    }
}
