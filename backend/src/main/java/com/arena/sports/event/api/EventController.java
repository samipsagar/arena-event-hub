package com.arena.sports.event.api;

import com.arena.sports.common.dto.CursorPage;
import com.arena.sports.event.api.dto.CreateEventRequest;
import com.arena.sports.event.api.dto.EventResponse;
import com.arena.sports.event.api.dto.PatchEventRequest;
import com.arena.sports.event.api.dto.UpdateEventRequest;
import com.arena.sports.event.domain.Event;
import com.arena.sports.common.dto.Cursor;
import com.arena.sports.event.service.EventMapper;
import com.arena.sports.event.service.EventQuery;
import com.arena.sports.event.service.EventService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.headers.Header;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import java.net.URI;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api/v1/events")
public class EventController {

    private static final Logger log = LoggerFactory.getLogger(EventController.class);

    private final EventService eventService;
    private final EventMapper eventMapper;

    EventController(EventService eventService, EventMapper eventMapper) {
        this.eventService = eventService;
        this.eventMapper = eventMapper;
    }

    @PostMapping
    @Operation(summary = "Create an event")
    @ApiResponse(responseCode = "201", description = "The created event, with its URL in Location",
            headers = @Header(name = HttpHeaders.LOCATION, description = "URL of the new event",
                    schema = @Schema(type = "string", format = "uri")))
    @ApiResponse(responseCode = "400", description = "Validation failed")
    @ApiResponse(responseCode = "409",
            description = "A business rule was violated, e.g. the event starts in the past or the"
                    + " venue is already booked for that slot")
    ResponseEntity<EventResponse> create(@Valid @RequestBody CreateEventRequest request) {
        log.info("Creating event: {}", request);

        Event savedEvent = eventService.create(request);

        URI location = URI.create("/api/v1/events/" + savedEvent.getId());
        return ResponseEntity.created(location).body(eventMapper.toResponse(savedEvent));
    }

    @GetMapping
    @Operation(summary = "List events")
    @ApiResponse(responseCode = "200", description = "A cursor based page of events")
    @ApiResponse(responseCode = "400", description = "Validation failed")
    CursorPage<EventResponse> all(@ModelAttribute EventQuery query,
            @RequestParam(required = false) String cursor,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int limit) {
        log.info("Retrieving events with query {}, limit {} and cursor {}", query, limit, cursor);

        final CursorPage<Event> page =
                eventService.findAll(query, cursor == null ? null : Cursor.decode(cursor), limit);

        return new CursorPage<>(page.data().stream().map(eventMapper::toResponse).toList(),
                page.nextCursor(), page.hasNext());
    }


    @GetMapping("/{id}")
    @Operation(summary = "Get an event by ID")
    @ApiResponse(responseCode = "200", description = "The event")
    @ApiResponse(responseCode = "400", description = "Validation failed")
    @ApiResponse(responseCode = "404", description = "No event with that id")
    EventResponse getById(@PathVariable UUID id) {
        log.info("Retrieving event with ID {}", id);

        final Event event = eventService.findById(id);
        return eventMapper.toResponse(event);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Replace an event",
            description = "A COMPLETED or CANCELLED event is final and cannot be replaced.")
    @ApiResponse(responseCode = "200", description = "The updated event")
    @ApiResponse(responseCode = "400", description = "Validation failed")
    @ApiResponse(responseCode = "404", description = "No event with that id")
    @ApiResponse(responseCode = "409",
            description = "A business rule was violated, e.g. the event is already COMPLETED or"
                    + " CANCELLED, a participant limit below the number already registered, or a"
                    + " venue clash")
    EventResponse update(@PathVariable UUID id, @Valid @RequestBody UpdateEventRequest request) {
        log.info("Updating event with ID {}: {}", id, request);

        final Event event = eventService.update(id, request);
        return eventMapper.toResponse(event);
    }

    @PatchMapping("/{id}")
    @Operation(summary = "Partially update an event",
            description = "Status follows SCHEDULED -> LIVE -> COMPLETED, and may move to CANCELLED"
                    + " at any point before it finishes. COMPLETED and CANCELLED are final: an"
                    + " event that has reached one can no longer be changed in any way.")
    @ApiResponse(responseCode = "200", description = "The updated event")
    @ApiResponse(responseCode = "400", description = "Validation failed")
    @ApiResponse(responseCode = "404", description = "No event with that id")
    @ApiResponse(responseCode = "409",
            description = "A business rule was violated, e.g. the event is already COMPLETED or"
                    + " CANCELLED, an illegal status transition, a participant limit below the"
                    + " number already registered, or a venue clash")
    EventResponse partialUpdate(@PathVariable UUID id,
            @Valid @RequestBody PatchEventRequest request) {
        log.info("Partially updating event with ID {}: {}", id, request);

        final Event event = eventService.partialUpdate(id, request);
        return eventMapper.toResponse(event);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete an event by ID")
    @ApiResponse(responseCode = "204", description = "Deleted")
    @ApiResponse(responseCode = "400", description = "Validation failed")
    @ApiResponse(responseCode = "404", description = "No event with that id")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        log.info("Deleting event with ID {}", id);

        eventService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
