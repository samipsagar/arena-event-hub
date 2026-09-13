package com.arena.sports.event.service;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.ScrollPosition;
import org.springframework.data.domain.ScrollPosition.Direction;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Window;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.arena.sports.common.dto.Cursor;
import com.arena.sports.common.dto.CursorPage;
import com.arena.sports.common.exception.BusinessRuleException;
import com.arena.sports.common.exception.ResourceNotFoundException;
import com.arena.sports.event.api.dto.CreateEventRequest;
import com.arena.sports.event.api.dto.PatchEventRequest;
import com.arena.sports.event.api.dto.UpdateEventRequest;
import com.arena.sports.event.domain.Event;
import com.arena.sports.event.domain.EventRepository;
import com.arena.sports.event.domain.EventSpecifications;
import com.arena.sports.event.domain.EventStatus;
import com.arena.sports.event.domain.rule.EventRules;

@Service
@Transactional(readOnly = true)
public class EventService {

    private static final Logger log = LoggerFactory.getLogger(EventService.class);

    private static final Sort BY_START_THEN_ID = Sort.by("startsAt", "id");

    private final EventRepository eventRepository;
    private final EventMapper eventMapper;
    private final EventRules eventRules;

    public EventService(EventRepository eventRepository, EventMapper eventMapper,
            EventRules eventRules) {
        this.eventRepository = eventRepository;
        this.eventMapper = eventMapper;
        this.eventRules = eventRules;
    }

    public CursorPage<Event> findAll(EventQuery query, Cursor cursor, int limit) {
        Window<Event> window = eventRepository.findBy(specFor(query),
                q -> q.sortBy(BY_START_THEN_ID).limit(limit).scroll(positionOf(cursor)));

        List<Event> events = window.getContent();
        String nextCursor = window.hasNext() ? cursorFor(events.getLast()) : null;

        return new CursorPage<>(events, nextCursor, window.hasNext());
    }

    private static Specification<Event> specFor(EventQuery query) {
        return Specification.where(EventSpecifications.hasStatus(query.status()))
                .and(EventSpecifications.hasSport(query.sport()))
                .and(EventSpecifications.venueContains(query.venue()))
                .and(EventSpecifications.titleContains(query.title()))
                .and(EventSpecifications.startsBetween(query.from(), query.to()));
    }

    private static ScrollPosition positionOf(Cursor cursor) {
        return cursor == null ? ScrollPosition.keyset()
                : ScrollPosition.of(Map.of("startsAt", cursor.sortValue(), "id", cursor.id()),
                        Direction.FORWARD);
    }

    private static String cursorFor(Event event) {
        return new Cursor(event.getStartsAt(), event.getId()).encode();
    }


    public Event findById(UUID id) {
        return eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event", id));
    }

    @Transactional
    public Event create(CreateEventRequest request) {
        Event event = eventMapper.toEntity(request);
        eventRules.check(event);
        Event saved = eventRepository.save(event);

        log.info("Created event with ID {}: {}", saved.getId(), saved);
        return saved;
    }

    @Transactional
    public Event update(UUID id, UpdateEventRequest request) {
        Event existingEvent = findById(id);
        checkStatusTransition(existingEvent, request.status());
        Event eventToUpdate = eventMapper.fromUpdateRequest(existingEvent, request);
        eventRules.check(eventToUpdate);
        Event savedEvent = eventRepository.save(eventToUpdate);

        log.info("Updated event with ID {}: {}", savedEvent.getId(), savedEvent);
        return savedEvent;
    }

    @Transactional
    public Event partialUpdate(UUID id, PatchEventRequest request) {
        Event existingEvent = findById(id);
        checkStatusTransition(existingEvent, request.status());
        Event eventToUpdate = eventMapper.applyPatch(existingEvent, request);
        eventRules.check(eventToUpdate);
        Event savedEvent = eventRepository.save(eventToUpdate);

        log.info("Partially updated event with ID {}: {}", savedEvent.getId(), savedEvent);
        return savedEvent;
    }

    @Transactional
    public void delete(UUID id) {
        Event event = findById(id);
        eventRepository.delete(event);
        log.info("Deleted event with ID {}: {}", id, event);
    }

    /**
     * Checks that the status transition is valid. Throws a {@link BusinessRuleException} if the
     * transition is invalid.
     */
    private static void checkStatusTransition(Event event, EventStatus target) {
        if (target == null || event.getStatus().canTransitionTo(target)) {
            return;
        }

        throw new BusinessRuleException(
                "Cannot change status from %s to %s".formatted(event.getStatus(), target));
    }

}
