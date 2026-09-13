package com.arena.sports.event.domain;

import java.util.EnumSet;
import java.util.Map;
import java.util.Set;

/**
 * The lifecycle of an event, and the moves allowed within it.
 */
public enum EventStatus {
    SCHEDULED, LIVE, COMPLETED, CANCELLED;

    private static final Map<EventStatus, Set<EventStatus>> ALLOWED_TRANSITIONS = Map.of(SCHEDULED,
            EnumSet.of(LIVE, CANCELLED), LIVE, EnumSet.of(COMPLETED, CANCELLED), COMPLETED,
            EnumSet.noneOf(EventStatus.class), CANCELLED, EnumSet.noneOf(EventStatus.class));

    /**
     * Returns true if this status can transition to the target status, false otherwise.
     */
    public boolean canTransitionTo(EventStatus target) {
        return this == target || ALLOWED_TRANSITIONS.getOrDefault(this, Set.of()).contains(target);
    }

}
