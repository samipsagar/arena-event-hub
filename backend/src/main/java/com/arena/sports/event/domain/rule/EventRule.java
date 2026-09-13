package com.arena.sports.event.domain.rule;

import com.arena.sports.common.exception.BusinessRuleException;
import com.arena.sports.event.domain.Event;

/**
 * A rule that must be satisfied for an event to be valid. If a rule is violated, the event cannot
 * be created or updated. throws a {@link BusinessRuleException} if the rule is violated.
 */
public interface EventRule {
    /**
     * @throws BusinessRuleException if this rule is violated
     */
    void check(Event event);
}
