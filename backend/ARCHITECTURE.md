# Backend Architecture

Package-by-feature, with the domain in the middle. `event/` owns a vertical
slice — its HTTP surface, its business rules, its persistence — and anything
genuinely shared sits in `common/` or `config/`. The goal is that a change to
"how events are stored" touches one package, and a change to "how errors become
responses" touches one file.

---

## 1. The layers

```
    api        EventController + request/response records
     │         knows: HTTP, status codes, JSON
     ▼         never: entities leaving the building
  service      EventService, EventMapper           orchestration + transactions
     │
     ▼
  domain       Event, enums, EventRules            the rules themselves
     │
     ▼
 repository    EventRepository, Specifications     knows: JPA, SQL
```

Each layer talks only to the one below it. The rule that matters in review:
**a controller must never return an `Event`, and a rule must never know what
HTTP is.** [EventMapper](src/main/java/com/arena/sports/event/service/EventMapper.java)
is the border crossing — request record in, entity out; entity in,
`EventResponse` out.

> One honest deviation: `EventMapper` lives in `service/` rather than `api/`,
> even though it produces an API type. It is the one class allowed to see both
> sides, and putting it next to the service that calls it beat inventing a
> package for a single class.

## 2. Where goes what

| Put it in | When it is | Example |
| --- | --- | --- |
| `event/api/` | A route, a status code, a header | [EventController](src/main/java/com/arena/sports/event/api/EventController.java) |
| `event/api/dto/` | The wire shape, with its validation annotations | [CreateEventRequest](src/main/java/com/arena/sports/event/api/dto/CreateEventRequest.java) |
| `event/service/` | Orchestration, transactions, DTO ⇄ entity | [EventService](src/main/java/com/arena/sports/event/service/EventService.java) |
| `event/domain/` | A thing the app reasons about, and its vocabulary | [Event](src/main/java/com/arena/sports/event/domain/Event.java), [EventStatus](src/main/java/com/arena/sports/event/domain/EventStatus.java) |
| `event/domain/rule/` | One business invariant, independently testable | [VenueAvailabilityRule](src/main/java/com/arena/sports/event/domain/rule/VenueAvailabilityRule.java) |
| `event/domain/` (repository) | A query | [EventSpecifications](src/main/java/com/arena/sports/event/domain/EventSpecifications.java) |
| `common/exception/` | An error every feature can raise | [BusinessRuleException](src/main/java/com/arena/sports/common/exception/BusinessRuleException.java) |
| `common/dto/` | A response shape with no feature knowledge | [CursorPage](src/main/java/com/arena/sports/common/dto/CursorPage.java) |
| `config/` | Wiring the whole app needs | [ClockConfig](src/main/java/com/arena/sports/config/ClockConfig.java) |

### The events feature, as built

```
event/
├── api/
│   ├── dto/          CreateEventRequest, UpdateEventRequest,
│   │                 PatchEventRequest, EventResponse
│   └── EventController.java                    (/api/v1/events)
├── domain/
│   ├── rule/         EventRule, EventRules, and the four rules
│   ├── Event.java                              (@Entity, builder + setters)
│   ├── EventStatus.java                        (the lifecycle, §7)
│   ├── Sport.java
│   ├── EventRepository.java                    (JpaRepository + Specification + one @Query)
│   └── EventSpecifications.java                (the filters)
└── service/
    ├── EventService.java                       (@Transactional boundary)
    ├── EventMapper.java                        (DTO ⇄ entity)
    └── EventQuery.java                         (bound from query params)
```

## 3. The rules engine

A business invariant is a bean, not an `if` buried in the service. Each
implements [EventRule](src/main/java/com/arena/sports/event/domain/rule/EventRule.java)
and throws `BusinessRuleException`, which becomes a 409 (§5).

| Order | Rule | Says |
| --- | --- | --- |
| 10 | `ParticipantCapacityRule` | The limit cannot sit below the number already registered |
| 20 | `FutureStartRule` | A `SCHEDULED` event must start in the future |
| 30 | `CompletedEventEndedRule` | An event cannot be `COMPLETED` before it has ended |
| 40 | `VenueAvailabilityRule` | A venue hosts one event at a time |

[EventRules](src/main/java/com/arena/sports/event/domain/rule/EventRules.java)
collects them by constructor injection and runs them in `@Order`, stopping at
the first violation — so the caller gets the cheapest, most specific message
rather than the last one. The cheap in-memory checks come before rule 40, which
is the only one that hits the database.

`EventService` calls `eventRules.check(event)` on **create, replace and patch** —
always on the entity *after* the change has been applied, so a rule sees the
world as it would be if the write succeeded.


## 4. Validation vs. rules

Two different things, deliberately kept apart:

| | Bean validation | Business rules |
| --- | --- | --- |
| Where | Annotations on the request records | `domain/rule/` |
| Asks | "Is this request well-formed?" | "Is this change allowed?" |
| Needs | Nothing but the request | The stored event, the clock, other rows |
| Answers | **400** with a per-field `errors` map | **409** with a sentence |

`@NotBlank String title` is validation. "That venue is booked" is a rule. If a
check needs to look at anything other than the incoming payload, it is a rule.

## 5. Errors

One `@RestControllerAdvice` —
[GlobalExceptionHandler](src/main/java/com/arena/sports/common/exception/GlobalExceptionHandler.java) —
turns everything into an RFC 7807 `ProblemDetail`. Controllers contain no
`try`/`catch`.

| Thrown | Becomes | Detail |
| --- | --- | --- |
| `ResourceNotFoundException` | 404 | Names the type and id |
| `BusinessRuleException` | 409 | The rule's own message |
| `InvalidCursorException` | 400 | `Malformed cursor` |
| `MethodArgumentNotValidException` | 400 | `Validation failed` + an `errors` map, field → message |
| `HttpMessageNotReadableException` | 400 | For a bad enum, lists the values that *are* accepted |
| anything else | 500 | Always `An unexpected error occurred` — the cause is logged, never sent |

That last row is the rule worth keeping: a 500 body never carries internals. It
is also why the catch-all logs at `error` while every other handler logs at
`warn` — a 4xx is the caller's problem, a 5xx is ours.

[OpenApiConfig](src/main/java/com/arena/sports/config/OpenApiConfig.java) then
attaches the `ProblemDetail` schema to **every** documented 4xx/5xx response
centrally, deriving the schema from the real class. So a new endpoint is
documented correctly the moment it declares an error response, with no
annotation to remember and nothing to drift.

## 6. Pagination

Keyset, not offset. Offset paging re-scans rows it has already returned and
shifts under concurrent inserts; at a list ordered by start time, both matter.



## 7. The status lifecycle

Encoded once, in
[EventStatus](src/main/java/com/arena/sports/event/domain/EventStatus.java):

```
SCHEDULED ──► LIVE ──► COMPLETED
    │          │
    └──────────┴──────► CANCELLED
```

`COMPLETED` and `CANCELLED` are terminal. `canTransitionTo` also returns true
for a status moving to itself, which is what lets a full `PUT` restate the
current status without tripping the check.

**A terminal event is frozen, not merely un-transitionable.** Once an event is
`COMPLETED` or `CANCELLED` it is a matter of record: `PUT` and `PATCH` both 409
whatever the body asks for — a title fix, a venue correction, even a no-op that
restates the current status. `checkNotFinished` in `EventService` enforces this
ahead of the transition check, so a request against a finished event never
reaches the mapper. `DELETE` is deliberately left open, as the way to remove an
event recorded in error.

This one is not an `EventRule`, and the reason generalises: a rule sees only the
entity *after* the change (§3), so it cannot tell "was already `COMPLETED`" from
"is being completed right now" — as a rule it would reject the legal
`LIVE -> COMPLETED` move. **A check that needs the stored state as well as the
requested one belongs in `EventService`, next to `checkStatusTransition`; a
check that only needs the outcome belongs in `domain/rule/`.**

**Both `PUT` and `PATCH` enforce this**, via `checkStatusTransition` in
`EventService`. An illegal move is a 409 before the mapper is called; the mapper
itself applies whatever it is given and passes no judgement, which is why its
tests assert application, not legality.

The mobile client mirrors this table in `EventStatus._allowedTransitions` so its
dropdown only offers legal moves. **The two must be changed together** — the
client mirror is a convenience, and the backend remains the authority.

## 8. Two details worth knowing

**`Event` is a mutable entity with a builder.** The builder exists for creation
(and fixtures); setters exist because JPA dirty-checking needs them and because
`applyPatch` writes field by field. It is not an immutable record, and trying to
make it one fights Hibernate.

**`common/dto/PageResponse` is unused.** It is an offset-paging shape left over
from before cursors; nothing references it. Delete it rather than reach for it.

## 9. Adding a feature

1. `feature/domain/` — the entity, enums, and a `Repository`.
2. `src/main/resources/db/migration/V<n>__…sql` — the table. Never an
   annotation; `ddl-auto=validate` will not create it for you.
3. `feature/domain/rule/` — one `@Component` per invariant, with an `@Order`.
4. `feature/api/dto/` — request records with validation annotations, and a
   response record.
5. `feature/service/` — a `Mapper`, then a `@Transactional(readOnly = true)`
   service with `@Transactional` on the writes.
6. `feature/api/` — the controller: bind, delegate, map, return. No logic.
7. Errors: throw `ResourceNotFoundException` / `BusinessRuleException` and let
   the advice answer. Add a handler only for a genuinely new category.
8. Tests, in the three shapes from README §6 — unit for mappers and enums, a
   `@DataJpaTest` slice for the service, `@SpringBootTest` for the HTTP
   contract.

## 10. Known gaps

The same list as README §9, because they are architectural, not cosmetic:

- **Auditing is not wired.** `@CreatedDate`/`@LastModifiedDate` on `Event` do
  nothing without `@EnableJpaAuditing` and an `AuditingEntityListener`.
  `EventMapper` sets both timestamps by hand instead — so the annotations
  describe an intention, and the mapper is what actually runs. A new write path
  that forgets `setUpdatedAt` will silently keep a stale timestamp.
- **No optimistic locking.** `V1` has a `version` column; `Event` has no
  `@Version` field, so nothing reads or increments it. Concurrent updates to the
  same event both succeed and the last writer wins. A consequence worth knowing
  meanwhile: because `Event` assigns its own UUID, Spring Data sees a non-null
  id, treats every `save()` as a merge, and issues a `SELECT` before each
  `INSERT`.
- **No authentication or authorisation.** Every endpoint is open, and
  `registeredParticipants` is client-supplied on create and replace — there is
  no registration flow, so any caller can set the count directly.
