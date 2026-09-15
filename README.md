# Arena Event Hub

Sports event management, built as three clients of one API in a single
repository: a Spring Boot backend, an Angular web app, and a Flutter mobile app.

All three model the same domain — events with a sport, a venue, a start time, a
capacity and a status lifecycle — and the two clients deliberately share an
architecture, so what you learn in one transfers to the other.

| Project | Stack | Lives in | Runs on |
| --- | --- | --- | --- |
| **Backend** | Java 21, Spring Boot, H2, Flyway | [backend/](backend) | `http://localhost:8080` |
| **Web** | Angular 22, Tailwind, Angular Material | [apps/web/](apps/web) | `http://localhost:4200` |
| **Mobile** | Flutter 3.44.4, Riverpod | [apps/mobile/](apps/mobile) | a simulator, emulator or device |

---

## 1. Repository layout

```
backend/            Spring Boot API — serves /api/v1/events on :8080
apps/
├── web/            Angular client
└── mobile/         Flutter client (package name: sports)
```

Each project is self-contained: its own build tool, its own dependencies, its
own test suite. There is no root-level build, no workspace tool tying them
together, and nothing to install at the root — you work in one project at a
time, with the backend running alongside.

## 2. The API at a glance

One resource, at `/api/v1/events`. Everything both clients do is built on
exactly this, so it is worth two minutes before the setup steps.
[backend/README.md §7](backend/README.md) is the full reference, and
`http://localhost:8080/swagger-ui.html` is the interactive one once the backend
is running.

| Verb | Path | Does |
| --- | --- | --- |
| `GET` | `/api/v1/events` | Cursor-paged list, filterable |
| `POST` | `/api/v1/events` | Create → **201** with a `Location` header |
| `GET` | `/api/v1/events/{id}` | One event |
| `PUT` | `/api/v1/events/{id}` | Full replacement — every field required |
| `PATCH` | `/api/v1/events/{id}` | Partial — omitted fields stay as they are |
| `DELETE` | `/api/v1/events/{id}` | → **204** |

An event is a title and description, a `sport` (`FOOTBALL`, `CRICKET`, `RUGBY`,
`BASKETBALL`, `TENNIS`, `CHESS`), a venue, a start instant and a duration, a
participant limit and a registered count. The API derives `endsAt` and
`spotsRemaining` so that no client has to.

Filters on the list: `status`, `sport`, `title`, `venue`, `from`, `to`, where
`title` and `venue` match a case-insensitive substring. Paging is keyset, not
offset: the response is `{ data, nextCursor, hasNext }`, and `nextCursor` goes
straight back as `?cursor=`.

**The status lifecycle is the domain's central rule**, enforced by the backend
and mirrored by both clients so their controls only offer legal moves:

```
SCHEDULED ──► LIVE ──► COMPLETED
    │          │
    └──────────┴──────► CANCELLED
```

`COMPLETED` and `CANCELLED` are final, and final means frozen: a `PUT` or
`PATCH` against an event in either status is refused whatever it asks to
change, down to a title fix. Every refusal — an illegal move, a venue
double-booked, a capacity below the number already registered, a scheduled
event starting in the past — comes back as a `409` with an RFC 7807
`application/problem+json` body naming the rule that said no.

## 3. Prerequisites

You only need the toolchain for the projects you intend to run. The backend is
required for either client to do anything useful.

### For the backend

| Tool | Version | Notes |
| --- | --- | --- |
| JDK | **21** | `java -version` must report 21. Pinned by `<java.version>` in [pom.xml](backend/pom.xml) |
| Maven | — | **Do not install it.** Use the bundled `./mvnw` wrapper |

No database to install: H2 runs in-memory inside the application.

### For the web app

| Tool | Version | Notes |
| --- | --- | --- |
| Node.js | **22.22.3+** | Angular 22 requires `^22.22.3 \|\| ^24.15.0 \|\| >=26`. Node 20 is not supported |
| npm | **12.x** | Pinned via `packageManager` in [apps/web/package.json](apps/web/package.json) |

The Angular CLI comes from devDependencies — no global install needed.

### For the mobile app

| Tool | Version | Notes |
| --- | --- | --- |
| [FVM](https://fvm.app) | 4.x | Manages the pinned Flutter SDK |
| Flutter | **3.44.4** | Pinned in [apps/mobile/.fvmrc](apps/mobile/.fvmrc) — do not use a global Flutter |
| Xcode | latest stable | iOS builds and simulators |
| Android Studio | latest stable | Android SDK and an emulator image |
| JDK | 17 | The Android Gradle build targets Java 17 — separate from the backend's 21 |

## 4. Installation

Clone the repository, then install per project. Every command below runs from
the repository root — the parentheses keep each line self-contained, so you can
paste the block or pick one line out of it.

```bash
# Backend — resolves dependencies, compiles, runs the suite
(cd backend && ./mvnw verify)

# Web — installs exactly what the lockfile pins
(cd apps/web && npm ci)

# Mobile — downloads the pinned SDK, then resolves packages
(cd apps/mobile && fvm install && fvm flutter pub get)
```

Two rules that save an afternoon:

- **Always `./mvnw`, never a global `mvn`**, and **always prefix Flutter and
  Dart commands with `fvm`**. Both wrappers exist to pin a version; bypassing
  them silently builds against whatever is on your `PATH`.
- Prefer `npm ci` over `npm install` in `apps/web` — it honours
  `package-lock.json` exactly rather than drifting dependencies.

## 5. Launching the stack locally

**Start the backend first.** Both clients point at `http://localhost:8080` by
default and have nothing to show without it.

### Step 1 — the API

```bash
cd backend
./mvnw spring-boot:run
```

Serving on `http://localhost:8080`. The `dev` profile is active by default and
seeds two events into the empty in-memory database, so the clients have
something to list on first run. The database is in-memory: **every restart is a
clean slate**, and the seed runs again.

Confirm it is up:

```bash
curl http://localhost:8080/api/v1/events
```

Interactive API docs are at `http://localhost:8080/swagger-ui.html`.

### Step 2a — the web app

```bash
cd apps/web
npm start
```

Open `http://localhost:4200`. No CORS setup is needed: the backend's
`app.cors.allowed-origins` already lists `http://localhost:4200` and
`http://127.0.0.1:4200`. Serve on one of those two spellings — **a dev server on
any other port or host is not on that list** and every request will be blocked.

### Step 2b — the mobile app

```bash
cd apps/mobile
fvm flutter devices                     # what's attached

# config/dev.json holds one key: API_BASE_URL = http://localhost:8080
fvm flutter run --dart-define-from-file=config/dev.json

# same thing without the file, if you would rather name the value inline
fvm flutter run --dart-define=API_BASE_URL=http://localhost:8080
```

A base URL is **not optional** — there is no default, so a build that defines no
`API_BASE_URL` fails loudly rather than quietly pointing at someone's laptop.
The file is just the convenient way to supply it: one flag, and the value is
under version control instead of in your shell history.

Either way the value is `http://localhost:8080`, which does not reach your
machine from every target:

| Target | URL for a backend on your machine's port 8080 |
| --- | --- |
| iOS simulator | `http://localhost:8080` — works as-is |
| Android emulator | `http://10.0.2.2:8080` — `localhost` is the emulator itself |
| Physical device | `http://<your-LAN-IP>:8080` |

For the latter two, pass the right URL — either inline on its own, or over the
file, since `--dart-define` beats a same-named key in `--dart-define-from-file`
whatever order the flags come in:

```bash
fvm flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080

fvm flutter run --dart-define-from-file=config/dev.json \
  --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

CORS does not apply here — it is a browser rule, so only the web app needs an
allowed origin.

## 6. Running the tests

Every suite is self-contained. None of them needs the backend running, a
database, or any network access.

```bash
(cd backend     && ./mvnw verify)   # unit + @DataJpaTest + full-stack MockMvc
(cd apps/web    && npm test)        # Vitest
(cd apps/mobile && fvm flutter test)
```

Linting and formatting, where each project has it:

```bash
(cd apps/web    && npm run lint && npm run format:check)
(cd apps/mobile && fvm flutter analyze)
```

`npm run lint` in the web app is not only style — it enforces the architectural
layer boundaries, so an illegal import across layers fails the build.

There is no CI pipeline configured yet, and no end-to-end suite in any project.

## 7. Documentation

Each project carries its own README (setup, commands, troubleshooting) and
ARCHITECTURE document (layer rules, conventions, how to add a feature). Start
with the README for the project you are touching; read its ARCHITECTURE before
adding a feature to it.

| Project | Setup and commands | Design and conventions |
| --- | --- | --- |
| Backend | [backend/README.md](backend/README.md) | [backend/ARCHITECTURE.md](backend/ARCHITECTURE.md) |
| Web | [apps/web/README.md](apps/web/README.md) | [apps/web/ARCHITECTURE.md](apps/web/ARCHITECTURE.md) |
| Mobile | [apps/mobile/README.md](apps/mobile/README.md) | [apps/mobile/ARCHITECTURE.md](apps/mobile/ARCHITECTURE.md) |

## 8. What the three projects agree on

The clients are not independently invented. Reading one prepares you for the
other:

- **The same layering.** `presentation → domain → data → core`, feature-first,
  with mappers as the only border crossing between wire shapes and domain
  entities. Both ARCHITECTURE documents describe the same diagram.
- **The same error model.** The backend answers every failure with an RFC 7807
  `application/problem+json` body; both clients convert that — and every
  transport failure — into one closed union of application errors at the
  network edge, so nothing above that line knows HTTP exists.
- **The same naming.** State holders are `ViewModel`, never `Controller`, in
  both clients.
- **The same fail-loud config rule.** Neither client has a default API origin.
  A build that does not supply one fails immediately rather than appearing to
  work against a machine that happens to be running a backend.
- **Cursor paging, not offset.** The list endpoint returns
  `{ data, nextCursor, hasNext }`; clients pass the cursor back verbatim.

## 9. Decisions and trade-offs

The choices worth defending, and what each one costs. The gaps in §10 are
mostly consequences of these rather than oversights.

- **One denormalised `events` table, not a normalised schema.** Everything an
  event is lives in one row: `venue` is free text, and `registered_participants`
  is a count rather than a registrations table. Venues, participants and a join
  table would be a larger domain than this assessment asks for, and for CRUD
  over a single resource one row keeps every read joinless and lets the
  invariants sit in `CHECK` constraints. *Costs:* nobody knows *who* registered,
  so only the count can be edited; venue matching is string equality; and
  `version` sits in the table unmapped, reserved so optimistic locking needs no
  migration — until then, edits are last-write-wins (§10).
- **Folders by feature, layers inside them — not layers at the top.** All three
  projects group by what the code is about before what kind of thing it is:
  `event/{api,domain,service}` on the backend and
  `features/event/{data,domain,presentation}` in both clients, with only
  genuinely cross-cutting plumbing
  hoisted to `common/` and `config/`, or `core/` and `shared/`. The alternative
  — top-level `controllers/`, `services/`, `models/` — reads well at five files
  and badly at five hundred: a single change smears across every top-level
  folder, and nothing in the tree tells you what the application actually does.
  Grouping the other way keeps one change in one folder, makes a feature
  deletable by deleting a directory, and leaves the layer rules intact *within*
  the slice, which is what the ARCHITECTURE documents spend their pages on.
  *Costs:* with exactly one feature the structure is mostly a promise —
  `features/event/` is the whole application, so today it buys nesting and
  directory hops rather than isolation, and the payoff only arrives at the
  second feature. It also forces a judgement on every new type — does this
  belong to the feature or to `core`/`shared`? — where promoting too early is
  the easy mistake and the expensive one to unwind. And the boundaries are only
  machine-checked in the web app, via `eslint-plugin-boundaries`; the backend
  has no ArchUnit or Modulith and mobile runs plain `flutter_lints`, so in two
  of the three projects the layering holds by convention and review alone.
- **A README and an ARCHITECTURE per project, not one document at the root.**
  The two answer different questions for different moments: a README gets you
  running and unblocks you when a command fails, an ARCHITECTURE tells you
  where new code goes and why the layering is shaped the way it is. Splitting
  them means the file you open on day one is not the file you reread in month
  three, and keeping both next to the code they describe is what gives them a
  chance of being updated in the same change. This root README deliberately
  holds only what spans projects — the stack, the launch order, the decisions
  here — and links out rather than restating, so there is exactly one place
  each fact lives. *Costs:* six documents plus this one is a lot of prose to
  keep honest, and nothing tests prose. The rot is real and has already
  happened twice: `apps/mobile/ARCHITECTURE.md` described an `unknown` enum
  fallback the mappers never implemented, and `apps/mobile/README.md` pointed
  at a `config/README.md` that was never written. Both were caught by reading,
  which is the only mechanism there is — a stale sentence costs more than no
  sentence, because it is believed.
- **Cursor paging, not offset.** The list is ordered by start time, and events
  are created and cancelled while someone is paging through it; with offsets
  that silently duplicates and skips rows. A keyset cursor is stable under
  concurrent writes. *Costs:* no page numbers, no jump-to-page, no total count,
  and forward-only traversal.
- **In-memory H2 with Flyway, not Postgres.** Clone and run: no container, no
  connection string, and the tests need no Docker. The migrations are portable
  SQL and the one hand-written query sticks to standard JPQL rather than a
  vendor function, so the switch is a datasource and a driver. *Costs:* nothing
  survives a restart, and no dialect, index-plan or isolation behaviour has ever
  been exercised against the database this would actually ship on.
- **Business rules as beans, not `if`s in the service.** Each invariant is an
  `@Order`ed `@Component` that is independently testable, and the ordering puts
  the in-memory checks before the one that hits the database. *Costs:* six
  files for four checks, and the pattern only fits rules that can be judged from
  the post-change entity alone — the "a finished event is frozen" rule needs the
  stored state too, so it sits in `EventService` instead. The seam is documented
  in [backend/ARCHITECTURE.md §7](backend/ARCHITECTURE.md).
- **An interface only where something actually varies.** `FeedbackService` and
  `ObservabilityService` are abstract in both clients, and `EventRule` has four
  implementations the backend iterates over — each is a real seam rather than a
  speculative one. Observability already fans out through a composite to a list
  of sinks, so adding Sentry is one more entry and no caller changes; feedback
  exists to keep `MatSnackBar` and `ScaffoldMessenger` out of everything that
  wants to show a message. `EventService`, `EventRepository` and `ApiClient`
  get no interface at all: there is one backend and one implementation, and a
  second file restating the first's method signatures would buy nothing but a
  hop to navigate through. **Testability is not a reason to add one** — mocktail
  and Mockito both mock concrete classes, and Angular's DI substitutes against
  the class token, so the usual "I need an interface to fake it" does not hold
  in any of these three stacks. The web integration test makes the point twice:
  it swaps `ObservabilityService` for a stub, and fakes the HTTP socket rather
  than the repository sitting above it. *Costs:* the day a second implementation
  does appear — an offline cache, a different transport — it lands as an
  edit across call sites rather than a new file beside an existing contract.
  And the clients' domain layers depend on their repositories directly, which
  is a deliberate deviation from the textbook arrangement and one that a
  reviewer expecting the interface will flag every time; both ARCHITECTURE
  documents record it so the answer is written down once.
- **DTOs, entities and mappers kept separate — verbose on purpose.** The wire
  shape and the shape the app reasons about are declared independently, with a
  mapper as the only crossing between them. They genuinely differ: `EventDto`
  carries `createdAt` and `updatedAt` that no screen displays, the `POST` and
  `PUT` bodies differ by a `status` field, and mobile's mapper converts UTC
  instants to local time inbound and back to UTC outbound, so entities are
  always ready to format and requests are always unambiguous. What the split
  buys is blast radius: a renamed field, a changed date format or a new column
  reaches one mapper instead of every component that touched it, and entities
  stay free of serialisation concerns, so a test builds one in a line. The web
  app has the compiler enforce it — `presentation` cannot import `dto` at all.
  *Costs:* adding a single field means editing a schema, an entity, a mapper
  and a form, and some of the ceremony is plainly empty — `sportToDomain` and
  `statusToDomain` are identity functions that return their argument, and the
  web `Event` is close to a field-for-field copy of `EventDto`. That is the
  standing cost of holding a seam open against a change that has not happened:
  clearly worth it against a backend that drifts independently, harder to
  justify against one that ships from this same repository.
- **Compile-time configuration in the mobile app.** `API_BASE_URL` arrives via
  `--dart-define` with no default, so a build that forgets it fails immediately
  instead of quietly reaching a backend that happens to be running. *Costs:* a
  built app cannot be repointed without recompiling, and there is no runtime
  environment switch — which is the right trade for a demo and the wrong one for
  an app that ships to testers.
- **Strict enum parsing at the client boundary.** Both clients reject a `sport`
  or `status` they do not recognise — the web app in its Zod schema, the mobile
  app in its wire mappers, which throw `ParsingException`. An unrecognised value
  means the contract has drifted, and failing on it is what stops either client
  from silently mislabelling an event or writing back a value the backend will
  refuse. *Costs:* adding an enum value on the backend — additive everywhere
  else — breaks every client already built, and the blast radius is a page
  rather than a row: one unknown event fails the mapping of the whole page it
  arrives in, so the list shows nothing at all.

  Two ways out were considered and neither is free. Parsing each item
  separately and dropping the ones that fail contains the blast radius to a
  row, but trades a loud failure for a silent one: a page of ten quietly
  renders eight, the count disagrees with the server's, and nobody learns the
  contract drifted. Falling back to an explicit `unknown` variant is the
  stronger fix — the event still appears, labelled rather than hidden — but
  `unknown` then becomes a case every screen has to handle, and the edit path
  needs a guard so it is never written back, since the backend would reject it.
  Strict parsing stands because the clients here ship in lockstep with the
  backend, which makes drift a bug worth hearing about rather than a condition
  to absorb. An independently released client would flip that judgement, and
  the `unknown` variant is where to start.

## 10. Known gaps

Stated rather than hidden, because each looks finished at a glance:

- **Nothing is deployable yet.** Both clients ship a blank production API origin
  — the web app has no `fileReplacements` for a production environment, and the
  mobile app has no `config/prod.json`. Each project's README §6 says what to
  fill in.
- **No authentication.** Every endpoint is open — §9 has the reasoning and what
  adding it would touch.
- **Concurrent edits are last-write-wins.** The `events` table has a `version`
  column, but `Event` carries no `@Version` field, so two overlapping `PUT`s do
  not conflict — the second simply overwrites the first. The column is there;
  wiring it up is a one-line change plus a `409` mapping.
- **Data does not survive a backend restart.** In-memory H2, by design (§9).
  Swapping in a real database is a datasource configuration plus a driver.
- **No CI, and no end-to-end tests** in any of the three projects.
- **Mobile release signing is not configured** — Android release builds use the
  debug signing config, and iOS needs a team and provisioning profile.

## 11. Troubleshooting

The project READMEs each end with a troubleshooting table. The problems that
span projects:

| Symptom | Fix |
| --- | --- |
| A client shows a connection error | The backend is not running on `http://localhost:8080` — start it first (§5) |
| Web requests blocked by CORS | Serve on `localhost:4200` or `127.0.0.1:4200`, or add your origin to the backend's `app.cors.allowed-origins` |
| Android emulator cannot reach the API | Use `10.0.2.2`, not `localhost` (§5) |
| The events list is empty after a backend restart | Seeding only fills an **empty** table and the database is in-memory — both are expected |
| `invalid target release: 21` | Wrong JDK on `PATH` for the backend; note mobile's Android build wants JDK 17 separately |
| Angular CLI reports an unknown builder | A global `ng` is shadowing the local one — use `npm start` / `npx ng` |
| A Flutter command behaves unexpectedly | You dropped the `fvm` prefix and used a different SDK |
