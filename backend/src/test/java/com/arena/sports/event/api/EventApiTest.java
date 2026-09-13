package com.arena.sports.event.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import com.jayway.jsonpath.JsonPath;

/**
 * Integration tests across the whole stack: routing, validation, business
 * rules, persistence and
 * error handling, driven over HTTP exactly as a client would.
 */
@SpringBootTest
@AutoConfigureMockMvc
class EventApiTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void creatingAnEventReturns201AndItsLocation() throws Exception {
        mockMvc.perform(postEvent("Creation Arena", futureStart()))
                .andExpect(status().isCreated())
                .andExpect(header().exists("Location"))
                .andExpect(jsonPath("$.title").value("New Match"))
                .andExpect(jsonPath("$.status").value("SCHEDULED"))
                .andExpect(jsonPath("$.spotsRemaining").value(20));
    }

    @Test
    void anEventCanBeReadBackAfterItIsCreated() throws Exception {
        MvcResult created = mockMvc.perform(postEvent("Readback Arena", futureStart())).andReturn();
        String id = JsonPath.read(created.getResponse().getContentAsString(), "$.id");

        mockMvc.perform(get("/api/v1/events/{id}", id)).andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(id))
                .andExpect(jsonPath("$.venue").value("Readback Arena"));
    }

    @Test
    void askingForAnEventThatDoesNotExistReturns404() throws Exception {
        mockMvc.perform(get("/api/v1/events/{id}", UUID.randomUUID()))
                .andExpect(status().isNotFound());
    }

    @Test
    void doubleBookingAVenueIsRejectedWith409() throws Exception {
        Instant startsAt = futureStart();
        mockMvc.perform(postEvent("Contested Arena", startsAt)).andExpect(status().isCreated());

        // Same venue, same slot: VenueAvailabilityRule should stop the second one.
        mockMvc.perform(postEvent("Contested Arena", startsAt)).andExpect(status().isConflict())
                .andExpect(header().doesNotExist("Location"));
    }

    @Test
    void skippingAStepInTheStatusLifecycleIsRejectedWith409() throws Exception {
        MvcResult created = mockMvc.perform(postEvent("Lifecycle Arena", futureStart())).andReturn();
        String id = JsonPath.read(created.getResponse().getContentAsString(), "$.id");

        // SCHEDULED may only move to LIVE or CANCELLED, never straight to COMPLETED.
        mockMvc.perform(patch("/api/v1/events/{id}", id).contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {"status": "COMPLETED"}
                        """))
                .andExpect(status().isConflict());
    }

    /**
     * FutureStartRule rejects an event that starts in the past, so tests book well
     * ahead. Each
     * test uses its own venue, which is what keeps them from clashing with one
     * another.
     */
    private static Instant futureStart() {
        return Instant.now().plus(365, ChronoUnit.DAYS).truncatedTo(ChronoUnit.SECONDS);
    }

    private static org.springframework.test.web.servlet.RequestBuilder postEvent(String venue,
            Instant startsAt) {
        return post("/api/v1/events").contentType(MediaType.APPLICATION_JSON)
                .content(body("New Match", venue, startsAt));
    }

    private static String body(String title, String venue, Instant startsAt) {
        return """
                {
                  "title": "%s",
                  "description": "A match",
                  "venue": "%s",
                  "sport": "FOOTBALL",
                  "status": "SCHEDULED",
                  "startsAt": "%s",
                  "durationInMinutes": 60,
                  "participantLimit": 20,
                  "registeredParticipants": 0
                }
                """.formatted(title, venue, startsAt);
    }
}
