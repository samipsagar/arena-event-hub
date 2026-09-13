package com.arena.sports.common.dto;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.format.DateTimeParseException;
import java.util.Base64;
import java.util.UUID;

import com.arena.sports.common.exception.InvalidCursorException;

/**
 * A cursor for cursor-based pagination, consisting of a sort value and a unique identifier.
 */
public record Cursor(Instant sortValue, UUID id) {

    private static final String SEPARATOR = "|";

    public String encode() {
        String raw = sortValue + SEPARATOR + id;
        return Base64.getUrlEncoder().withoutPadding()
                .encodeToString(raw.getBytes(StandardCharsets.UTF_8));
    }

    public static Cursor decode(String cursor) {
        try {
            String raw = new String(Base64.getUrlDecoder().decode(cursor), StandardCharsets.UTF_8);
            String[] parts = raw.split("\\" + SEPARATOR);
            if (parts.length != 2) {
                throw new InvalidCursorException("Malformed cursor");
            }
            return new Cursor(Instant.parse(parts[0]), UUID.fromString(parts[1]));
        } catch (IllegalArgumentException | DateTimeParseException e) {
            throw new InvalidCursorException("Malformed cursor");
        }
    }
}
