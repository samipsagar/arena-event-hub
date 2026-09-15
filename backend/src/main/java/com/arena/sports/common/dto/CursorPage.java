package com.arena.sports.common.dto;

import java.util.List;

/**
 * A generic response for paginated data using cursor-based pagination.
 */
public record CursorPage<T>(List<T> data, String nextCursor, boolean hasNext) {
}
