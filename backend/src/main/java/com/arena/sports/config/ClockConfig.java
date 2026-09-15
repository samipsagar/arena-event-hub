package com.arena.sports.config;

import java.time.Clock;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Supplies the clock that time-dependent business rules read, so tests can pin "now" with
 * {@link Clock#fixed} instead of depending on when they happen to run.
 */
@Configuration
public class ClockConfig {

    @Bean
    Clock clock() {
        return Clock.systemUTC();
    }
}
