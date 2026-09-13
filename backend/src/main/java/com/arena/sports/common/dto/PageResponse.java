package com.arena.sports.common.dto;

import java.util.List;

/**
 * A generic response for paginated data.
 *
 * @param <T> the type of the items in the page
 */
public record PageResponse<T>(List<T> items, int page, int size, long totalItems, int totalPages,
                boolean hasNext) {
}
