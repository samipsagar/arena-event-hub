package com.arena.sports.event.service;

import java.time.Instant;

import com.arena.sports.event.domain.EventStatus;
import com.arena.sports.event.domain.Sport;

public record EventQuery(EventStatus status, String venue, String title, Sport sport, Instant from,
                Instant to) {

}
