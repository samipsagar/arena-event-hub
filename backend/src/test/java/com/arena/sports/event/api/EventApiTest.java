package com.arena.sports.event.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
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

    @Test
    void aCancelledEventCannotBePatched() throws Exception {
        String id = cancelledEvent("Cancelled Patch Arena");

        // Not a transition question: even a change that touches nothing else is refused.
        mockMvc.perform(patchEvent(id, """
                {"title": "Renamed After Cancellation"}
                """)).andExpect(status().isConflict());
    }

    @Test
    void aCancelledEventCannotBeReplaced() throws Exception {
        String id = cancelledEvent("Cancelled Put Arena");

        mockMvc.perform(put("/api/v1/events/{id}", id).contentType(MediaType.APPLICATION_JSON)
                .content(body("Replaced After Cancellation", "Cancelled Put Arena", futureStart(),
                        "CANCELLED")))
                .andExpect(status().isConflict());
    }

    @Test
    void aCompletedEventCannotBePatched() throws Exception {
        MvcResult created =
                mockMvc.perform(postEvent("Completed Arena", futureStart())).andReturn();
        String id = JsonPath.read(created.getResponse().getContentAsString(), "$.id");

        // Walk it through the lifecycle, pulling the start into the past on the way so that
        // CompletedEventEndedRule lets it finish.
        mockMvc.perform(patchEvent(id, """
                {"status": "LIVE", "startsAt": "%s"}
                """.formatted(pastStart()))).andExpect(status().isOk());
        mockMvc.perform(patchEvent(id, """
                {"status": "COMPLETED"}
                """)).andExpect(status().isOk());

        mockMvc.perform(patchEvent(id, """
                {"title": "Renamed After Completion"}
                """)).andExpect(status().isConflict());
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

    /** An event past its end, so that it may legally be marked COMPLETED. */
    private static Instant pastStart() {
        return Instant.now().minus(7, ChronoUnit.DAYS).truncatedTo(ChronoUnit.SECONDS);
    }

    /** Creates an event at its own venue and cancels it, returning its id. */
    private String cancelledEvent(String venue) throws Exception {
        MvcResult created = mockMvc.perform(postEvent(venue, futureStart())).andReturn();
        String id = JsonPath.read(created.getResponse().getContentAsString(), "$.id");

        mockMvc.perform(patchEvent(id, """
                {"status": "CANCELLED"}
                """)).andExpect(status().isOk());
        return id;
    }

    private static org.springframework.test.web.servlet.RequestBuilder patchEvent(String id,
            String body) {
        return patch("/api/v1/events/{id}", id).contentType(MediaType.APPLICATION_JSON)
                .content(body);
    }

    private static org.springframework.test.web.servlet.RequestBuilder postEvent(String venue,
            Instant startsAt) {
        return post("/api/v1/events").contentType(MediaType.APPLICATION_JSON)
                .content(body("New Match", venue, startsAt));
    }

    private static String body(String title, String venue, Instant startsAt) {
        return body(title, venue, startsAt, "SCHEDULED");
    }

    private static String body(String title, String venue, Instant startsAt, String status) {
        return """
                {
                  "title": "%s",
                  "description": "A match",
                  "venue": "%s",
                  "sport": "FOOTBALL",
                  "status": "%s",
                  "startsAt": "%s",
                  "durationInMinutes": 60,
                  "participantLimit": 20,
                  "registeredParticipants": 0
                }
                """.formatted(title, venue, status, startsAt);
    }
}
