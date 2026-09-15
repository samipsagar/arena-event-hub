package com.arena.sports.config;

import io.swagger.v3.core.converter.AnnotatedType;
import io.swagger.v3.core.converter.ModelConverters;
import io.swagger.v3.core.converter.ResolvedSchema;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.media.Content;
import io.swagger.v3.oas.models.media.MediaType;
import io.swagger.v3.oas.models.media.Schema;
import io.swagger.v3.oas.models.responses.ApiResponse;
import org.springdoc.core.customizers.OpenApiCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.ProblemDetail;

/**
 * Makes every documented failure advertise the body {@code GlobalExceptionHandler} actually sends.
 *
 * <p>
 * Doing this centrally rather than with a {@code content = @Content(...)} block on each
 * {@code @ApiResponse} keeps the controller readable, and means a new endpoint is documented
 * correctly the moment it declares an error response — no annotation to remember.
 */
@Configuration
public class OpenApiConfig {

    static final String PROBLEM_JSON = "application/problem+json";
    private static final String PROBLEM_SCHEMA = "ProblemDetail";
    private static final String PROBLEM_SCHEMA_REF = "#/components/schemas/" + PROBLEM_SCHEMA;

    @Bean
    OpenApiCustomizer problemDetailErrorResponses() {
        return openApi -> {
            registerProblemDetailSchema(openApi);

            openApi.getPaths().values().stream().flatMap(path -> path.readOperations().stream())
                    .filter(operation -> operation.getResponses() != null)
                    .forEach(operation -> operation.getResponses()
                            .forEach(OpenApiConfig::describeIfError));
        };
    }

    private static void describeIfError(String statusCode, ApiResponse response) {
        if (!statusCode.matches("[45]\\d\\d")) {
            return;
        }

        response.setContent(new Content().addMediaType(PROBLEM_JSON,
                new MediaType().schema(new Schema<>().$ref(PROBLEM_SCHEMA_REF))));
    }

    /** Derives the schema from the real class, so it tracks whatever Spring's ProblemDetail holds. */
    private static void registerProblemDetailSchema(OpenAPI openApi) {
        if (openApi.getComponents() == null) {
            openApi.setComponents(new Components());
        }
        if (openApi.getComponents().getSchemas() != null
                && openApi.getComponents().getSchemas().containsKey(PROBLEM_SCHEMA)) {
            return;
        }

        ResolvedSchema resolved = ModelConverters.getInstance()
                .resolveAsResolvedSchema(new AnnotatedType(ProblemDetail.class));

        openApi.getComponents().addSchemas(PROBLEM_SCHEMA, resolved.schema);
        resolved.referencedSchemas.forEach(openApi.getComponents()::addSchemas);
    }
}
