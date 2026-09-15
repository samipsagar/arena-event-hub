package com.arena.sports.config;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import java.util.List;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

/**
 * Browser origins allowed to call the API, bound from {@code app.cors.allowed-origins}.
 *
 * <p>
 * Validated so that a deployment with no origins configured fails at startup rather than serving an
 * API that every browser silently refuses.
 */
@Validated
@ConfigurationProperties(prefix = "app.cors")
public record CorsProperties(@NotEmpty List<@NotBlank String> allowedOrigins) {
}
