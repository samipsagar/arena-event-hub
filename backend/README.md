# Arena — Backend

Spring Boot API for Arena Event Hub. Lives at `backend/` inside the
`arena-event-hub` monorepo; the Flutter client it serves lives at
[apps/mobile](../apps/mobile).

Group `com.arena`, artifact `sports` (so packages look like
`com.arena.sports.event...`). Serves `/api/v1/events` on port **8080**.

---

## 1. Prerequisites

| Tool | Version | Notes |
| --- | --- | --- |
| JDK | **21** | Pinned by `<java.version>` in [pom.xml](pom.xml) |
| Maven | — | Use the wrapper; do not install Maven |


```bash
java -version   # must report 21
```

**Always use `./mvnw`, never a global `mvn`.** The wrapper pins the Maven
version the build was written against, the same way the mobile app pins Flutter
through `fvm`.

## 2. First-time setup

From this directory (`backend`):

```bash
./mvnw verify    # resolves dependencies, compiles, runs the whole suite
```

There is nothing else to install. The database is in-memory (§5), so there is no container to start and no connection string to configure.

## 3. Running it

```bash
./mvnw spring-boot:run
```

The API is then at `http://localhost:8080/api/v1/events`.

The `dev` profile is active by default — set in
[application.properties](src/main/resources/application.properties), not by your
shell — and it turns on one thing: [DevDataSeeder](src/main/java/com/arena/sports/config/DevDataSeeder.java)
inserts two events (an A League final and a tennis semi) **if the table is
empty**. Any other environment sets its own profile and gets no seed data.

```bash
./mvnw spring-boot:run -Dspring-boot.run.profiles=prod   # no seeding
```

Because the database is in-memory, every restart is a clean slate and the seed
runs again.

### What else is reachable

| URL | What it is |
| --- | --- |
| `/api/v1/events` | The API (§7) |
| `/swagger-ui.html` | Interactive API docs |
| `/v3/api-docs` | The OpenAPI document as JSON |
| `/actuator/health` | Liveness — status only, never component detail |
| `/actuator/info`, `/actuator/metrics` | The only other exposed endpoints |

`env`, `beans`, `configprops`, `threaddump`, `loggers` and `mappings` return
**404 on purpose** — they expose configuration and internals. The exposure list
is in `application.properties`.

> **The H2 console is not reachable**, despite `spring-boot-h2console` being a
> dependency. `spring.h2.console.enabled` defaults to `false` and nothing sets
> it. To use it, add `spring.h2.console.enabled=true` and visit `/h2-console` —
> and note the JDBC URL is a random name per run unless you also set
> `spring.datasource.generate-unique-name=false`.

## 4. Configuration

Everything lives in
[application.properties](src/main/resources/application.properties). There are
no profile-specific files yet.

| Key | Value here | Why it matters |
| --- | --- | --- |
| `spring.profiles.active` | `dev` | Enables seeding. Override per environment. |
| `app.cors.allowed-origins` | `http://localhost:4200,http://127.0.0.1:4200` | Comma-separated. **Startup fails if empty** — see below. |
| `spring.jpa.hibernate.ddl-auto` | `validate` | Hibernate never alters the schema; Flyway owns it (§5). |
| `management.endpoints.web.exposure.include` | `health,info,metrics` | Everything else 404s. |
| `management.endpoint.health.show-details` | `never` | Detail names the database and disk paths. |

[CorsProperties](src/main/java/com/arena/sports/config/CorsProperties.java) is
`@Validated` with `@NotEmpty`, so a deployment that forgets its origins **fails
at startup** rather than serving an API every browser silently refuses. CORS
applies to `/api/**` only, allows `GET POST PUT PATCH DELETE OPTIONS`, and sends
no credentials.

Override per environment the usual Spring way:

```bash
APP_CORS_ALLOWED_ORIGINS=https://app.example.com ./mvnw spring-boot:run
```

Note the mobile client does **not** need a CORS entry — CORS is a browser rule.
Only the web app does.

## 5. Database and migrations

An **in-memory H2** instance, created at startup and gone at shutdown. There is
no `spring.datasource.*` configuration at all; Spring Boot sees H2 on the
classpath and builds an embedded datasource.

Schema changes go in [db/migration](src/main/resources/db/migration) as Flyway
scripts — never in an entity annotation, because `ddl-auto=validate` means
Hibernate will refuse to start rather than fix a mismatch it finds.

| Script | What it did |
| --- | --- |
| `V1__create_events_table.sql` | The `events` table, with `CHECK` constraints on status and capacity |
| `V2__index_events_starts_at_id.sql` | Replaced the `starts_at` index with `(starts_at, id)` for keyset paging |

Naming is `V<n>__snake_case_description.sql`. **Never edit a script that has
run** — Flyway checksums them; add a new one.


## 6. Tests

```bash
./mvnw test            # the whole suite
./mvnw verify          # compile + test, what CI should run
./mvnw -Dtest=EventMapperTest test                # one class
```

No database to provision, no profile to pass — the slices build their own
in-memory schema through Flyway.

Three files, one per level of the pyramid:

| Test | Kind | Covers |
| --- | --- | --- |
| [EventMapperTest](src/test/java/com/arena/sports/event/service/EventMapperTest.java) | Unit — no Spring | DTO ⇄ entity, `PATCH` null-means-unchanged, the status lifecycle |
| [EventRepositoryTest](src/test/java/com/arena/sports/event/domain/EventRepositoryTest.java) | `@DataJpaTest` | Real schema and SQL — round-tripping, and the venue-clash query |
| [EventApiTest](src/test/java/com/arena/sports/event/api/EventApiTest.java) | `@SpringBootTest` + `MockMvc` | The whole stack over HTTP — 201/`Location`, 404, 400 with field errors, 409 from a business rule |

The split is deliberate: the mapper is pure logic and needs no context, the
repository needs a database but not a web layer, and only the API test needs
all of it. Anything a lower level can prove is not repeated higher up.


## 7. The API

All under `/api/v1/events`.

| Verb | Path | Does |
| --- | --- | --- |
| `GET` | `/` | Cursor-paged list, filterable |
| `POST` | `/` | Create → **201** with `Location` |
| `GET` | `/{id}` | One event |
| `PUT` | `/{id}` | Full replacement — every field required, status included |
| `PATCH` | `/{id}` | Partial — omitted fields unchanged |
| `DELETE` | `/{id}` | → **204** |

List parameters: `status`, `sport`, `title`, `venue`, `from`, `to`, plus
`cursor` and `limit` (default 20, 1–100). `title` and `venue` match on
case-insensitive substring.

Paging is **keyset, not offset**: `nextCursor` is base64url of
`startsAt|id`, and the response is `{ data, nextCursor, hasNext }`. Pass the
cursor back verbatim; a malformed one is a 400.

Every failure is an RFC 7807 `application/problem+json` body:

| Status | When |
| --- | --- |
| 400 | Bean-validation failure (with a per-field `errors` map), malformed body, bad enum value, bad cursor |
| 404 | No event with that id |
| 409 | A business rule said no — capacity, venue clash, past start, illegal status move |
| 500 | Anything else. The detail is always `"An unexpected error occurred"`; the real cause goes to the log only. |

## 8. Project layout

```
src/main/java/com/arena/sports/
├── SportsApplication.java
├── common/
│   ├── dto/          Cursor, CursorPage (PageResponse is unused — see ARCHITECTURE.md §8)
│   └── exception/    GlobalExceptionHandler + the three domain exceptions
├── config/           Clock, CORS, OpenAPI, dev seeding
└── event/
    ├── api/          EventController + request/response records
    ├── domain/       Event, enums, repository, specifications, rule/
    └── service/      EventService, EventMapper, EventQuery
src/main/resources/
├── application.properties
└── db/migration/     Flyway scripts
src/test/java/…       mirrors the main tree
```

**→ [ARCHITECTURE.md](ARCHITECTURE.md)** covers the layer rules, the rules
engine, how errors become responses, and how to add a feature. Read it before
adding one.

## 9. Known gaps

Documented rather than hidden, because each one looks finished at a glance:

- **`@CreatedDate` and `@LastModifiedDate` on `Event` do nothing.** There is no
  `@EnableJpaAuditing` and no `AuditingEntityListener`, so the annotations are
  decoration. What actually sets the timestamps is `EventMapper`, by hand, with
  `Instant.now()` — including the one place it is easy to forget on a new write
  path.
- **The `version` column is not mapped.** `V1` creates
  `version BIGINT NOT NULL DEFAULT 0`, but `Event` has no `@Version` field, it is for future use
- **Data does not survive a restart.** In-memory H2 by design (§5). Swapping in
  a real database means adding `spring.datasource.*` and a driver — the Flyway
  scripts are already portable SQL.
- **No authentication.** Every endpoint is open

## 10. Troubleshooting

| Symptom | Fix |
| --- | --- |
| `invalid target release: 21` | Wrong JDK on `PATH`; `java -version` must say 21 |
| `Schema-validation: missing table [events]` | Flyway did not run — check the script names in `db/migration` |
| `Validation failed for ... CorsProperties` at startup | `app.cors.allowed-origins` is empty; it is `@NotEmpty` by design |
| Flyway `checksum mismatch` | An applied script was edited. Restore it and add a new `V<n>` instead |
| `/actuator/env` returns 404 | Intended — see §3 |
| `/h2-console` returns 404 | Intended — the console is disabled by default (§3) |
| Browser calls blocked by CORS | Add the origin to `app.cors.allowed-origins`; only `/api/**` is covered |
| Seed data missing after restart | It only seeds an **empty** table, and the DB is in-memory — both are expected |
| `409` on a status change that looks valid | `COMPLETED` and `CANCELLED` are terminal — see ARCHITECTURE.md §7 |
| Stale build after dependency changes | `./mvnw clean test` |
