# App Architecture

Feature-first, with a domain layer in the middle. Each feature owns a vertical
slice — its own data, domain and presentation — and shared plumbing lives in
`core/`. The goal is that a change to "how events are fetched" touches one
folder, and a change to "how errors are shown" touches one file.

This is [apps/mobile](../mobile/ARCHITECTURE.md)'s architecture ported to
Angular idioms, not copied literally: the layers and their rules are the same,
`ViewModel` means the same thing, and the two apps deliberately read alike.
Where the translation is imperfect it is called out below.

---

## 1. The layers

```
presentation   Components + ViewModels + Store   knows: domain
      │                                          never: DTOs, HttpClient, endpoints
      ▼
   domain      Services + entities               the app's own vocabulary
      │
      ▼
     data      Repository + DTOs + mappers       knows: HTTP paths, JSON
      │
      ▼
     core      ApiClient → HttpClient            knows: transport
```

Each layer talks only to the one below it. The rule that matters in review:
**a component must never see an `EventDto`, and the repository must never see an
`Event`.** Mappers are the border crossing.

> One honest deviation from textbook clean architecture: `EventService`
> (domain) depends on `EventRepository` (data) directly, rather than on an
> interface the domain owns. With one backend and one implementation, the
> indirection would buy nothing today. If a second source appears (cache,
> offline store), introduce the interface in `domain/` then. Mobile records the
> same deviation.

## 2. Boundaries are enforced, not just agreed

[eslint.config.js](eslint.config.js) declares the layers to
`eslint-plugin-boundaries` and disallows every import by default. `npm run lint`
fails on a crossing, so the diagram above is checked rather than remembered:

| This layer      | may import                                           |
| --------------- | ---------------------------------------------------- |
| `core`          | `core`                                               |
| `shared`        | `shared`, `core`                                     |
| `data/dto`      | `dto`, `core`                                        |
| `data`          | `data`, `dto`, `entity`, `domain`, `core`            |
| `domain/entity` | `entity`                                             |
| `domain`        | `domain`, `entity`, `data`, `core`                   |
| `presentation`  | `presentation`, `domain`, `entity`, `shared`, `core` |

Two consequences worth naming. **`data` is the only layer with both DTO and
entity in scope** — that is what makes it the only place a mapper can live.
And **entities may import only other entities**, which keeps them free of
Angular, RxJS and anything else that would make them awkward to test.

Order matters in that config: a file takes the type of the _first_ pattern it
matches, so `dto` is listed before `data` and `entity` before `domain`, each
being nested inside the folder after it.

Path aliases `@core/*`, `@features/*` and `@shared/*` come from
[tsconfig.json](tsconfig.json). They are resolved for the boundary check by
`eslint-import-resolver-typescript` — **without that resolver an aliased import
resolves to nothing and silently passes the check**, which is why it is a
dependency rather than an optimisation.

## 3. Where goes what

| Put it in                                  | When it is                                      | Example                                                                         |
| ------------------------------------------ | ----------------------------------------------- | ------------------------------------------------------------------------------- |
| `features/<name>/domain/entity/`           | A thing the app reasons about                   | [Event](src/app/features/event/domain/entity/event.ts)                          |
| `features/<name>/domain/`                  | A use case, orchestration, business rule        | [EventService](src/app/features/event/domain/event.service.ts)                  |
| `features/<name>/data/dto/`                | The wire shape, exactly as the backend sends it | [eventDtoSchema](src/app/features/event/data/dto/event.dto.ts)                  |
| `features/<name>/data/mapper/`             | DTO ⇄ entity translation                        | [event.mapper.ts](src/app/features/event/data/mapper/event.mapper.ts)           |
| `features/<name>/data/`                    | Endpoints and HTTP verbs                        | [EventRepository](src/app/features/event/data/event.repository.ts)              |
| `features/<name>/presentation/<page>/`     | A routed component and its ViewModel            | [EventDetail](src/app/features/event/presentation/event-detail/event-detail.ts) |
| `features/<name>/presentation/components/` | A presentational component used by 2+ pages     | [EventCard](src/app/features/event/presentation/components/event-card.ts)       |
| `features/<name>/presentation/store/`      | State shared across pages of the feature        | [EventStore](src/app/features/event/presentation/store/event-store.ts)          |
| `core/`                                    | Infrastructure every feature needs              | networking, errors, feedback                                                    |
| `shared/ui/`                               | A component with no feature knowledge           | [FieldErrors](src/app/shared/ui/field-errors/field-errors.ts)                   |
| `shared/forms/`                            | Form plumbing with no feature knowledge         | [zodValidator](src/app/shared/forms/zod-validator.ts)                           |

Files use Angular's 2025 naming style — `event-detail.ts`, not
`event-detail.page.ts` or `.component.ts`. The suffixes that remain are the ones
that name a _role_: `.view-model.ts`, `.service.ts`, `.repository.ts`,
`.mapper.ts`, `.dto.ts`.

### The events feature, as built

```
features/event/
├── data/
│   ├── dto/            event.dto, event-request.dto, event-status.dto,
│   │                   event.sports.dto           (Zod schemas + inferred types)
│   ├── mapper/         event.mapper, event-query.mapper,
│   │                   event-status.mapper, sport.mapper
│   └── event.repository.ts                        (/api/v1/events)
├── domain/
│   ├── entity/         Event, EventStatus, Sport, EventsPage, EventFormData
│   ├── event-query.ts                             (filter state ⇄ URL)
│   ├── event-form-schema.ts                       (the validation rules)
│   └── event.service.ts                           (the only API presentation sees)
└── presentation/
    ├── store/          EventStore                 (shared list state)
    ├── event-list/     EventList
    ├── event-detail/   EventDetail + EventDetailViewModel + EventDeleteViewModel
    ├── event-form/     EventForm + EventFormViewModel   (create and edit)
    └── components/     EventCard
```

## 4. What `core/` gives you

| Folder                                        | What it does                                                                                                             |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| [config/](src/app/core/config/)               | `API_BASE_URL` token + `provideAppConfig()`, and the request timeout. No fallback: a blank base URL throws at bootstrap. |
| [http/](src/app/core/http/)                   | `ApiClient` (typed wrapper over `HttpClient`), `errorInterceptor`, `CursorPage`                                          |
| [error/](src/app/core/error/)                 | The `AppError` union, `toAppError`, `ProblemDetail` parsing                                                              |
| [feedback/](src/app/core/feedback/)           | `FeedbackService` — an abstract class, backed by Material's snack bar                                                    |
| [observability/](src/app/core/observability/) | `ObservabilityService` — logging behind one entry point, console-backed today                                            |
| [routing/](src/app/core/routing/routes.ts)    | `Routes` — the URL builders, so paths are not retyped as string literals                                                 |

`FeedbackService` and `ObservabilityService` are abstract classes bound to
implementations in [app.config.ts](src/app/app.config.ts) via `useExisting`.
That is the swap point: pointing logging at Sentry is one line there, and no
caller changes.

### Errors

`toAppError` converts every failure — `HttpErrorResponse`, timeout, abort,
anything else — into an [AppError](src/app/core/error/app-error.ts) **at the
network edge**, in `errorInterceptor`. Above that line nothing knows
`HttpErrorResponse` exists. `ApiClient` applies it again as a backstop for calls
that bypass the interceptor.

`AppError` is a discriminated union on `kind` — `client` / `server` / `network`
/ `cancelled` / `parsing` / `unexpected` — so a `switch` over it is exhaustive
and the compiler names the gap when a new case appears. This is the TypeScript
translation of mobile's `sealed AppException`.

Every `message` is safe to show a user. `cause` never is: it may carry
internals, and on a 5xx it may not even come from our backend — which is why
`mapHttpErrorResponse` surfaces the `ProblemDetail.detail` of a 4xx but
deliberately discards a 5xx body.

`cancelled` is the one failure UI should usually swallow — it almost always
means the app cancelled its own request (a superseded search keystroke, a
navigation away), so there is nothing for a person to act on. Every ViewModel
checks for it before showing a toast.

`ProblemDetail` and `CursorPage` are hand-written parsers rather than Zod
schemas. They are only ever parsed, never built, and `errors` arrives in two
different shapes depending on which backend handler produced it. Zod is scoped
to DTOs and form rules on purpose — see §8.

## 5. Presentation conventions

**Injectables are declared `@Service()`** — Angular 22's replacement for
`@Injectable()`. `@Service({ autoProvided: false })` is the scoped form: no
root provider, so it exists only where it is listed in a `providers: []` array.

**Riverpod-style naming carries over: notifiers are `ViewModel`, never
`Controller`.** `EventDetailViewModel`, `EventFormViewModel`,
`EventDeleteViewModel`.

Scope is the signals analogue of Riverpod's auto-dispose, and there are two
levels of it:

- **Per-component** — a ViewModel listed in a component's `providers: []` dies
  with that component. `EventForm` provides `EventFormViewModel` this way.
- **Per-route-subtree** — [EventStore](src/app/features/event/presentation/store/event-store.ts)
  is provided on the component-less `/events` parent route, so one instance is
  shared by list, detail and form, and accumulated pages survive
  list → detail → back. It dies on leaving the events area. That is what keeps
  Flutter's "the list screen stays alive beneath the pushed route" behaviour.

Two ViewModel shapes, picked by what the page needs — the same split mobile
makes:

- **Async data** — an `rxResource` keyed on a signal; the template switches on
  its status. [EventDetailViewModel](src/app/features/event/presentation/event-detail/event-detail.view-model.ts).
  Re-keying cancels the in-flight request, which is where a `cancelled`
  `AppError` comes from.
- **A command** — a signal holding a state union (`idle` / `running` /
  `success` / `failure`) that a method drives.
  [EventDeleteViewModel](src/app/features/event/presentation/event-detail/event-delete.view-model.ts),
  `EventFormViewModel`.

Other conventions:

- **State is signals.** No NgRx. A store exposes `signal().asReadonly()` and
  `computed()`, never a writable signal.
- **Components in `components/` are presentational**: `input()` / `output()`
  only, no `inject()`. `EventCard` takes an `Event` and injects nothing.
- **Components don't catch errors.** A ViewModel or the store catches, and
  either moves the error into state or reports it through `FeedbackService`.
- **A successful write updates the store rather than refetching** —
  `store.upsert(event)` after a save, `store.remove(id)` after a delete.
- **Route params reach components as inputs**, via
  `withComponentInputBinding()` — `EventDetail` declares
  `id = input.required<string>()`.
- **Links go through [Routes](src/app/core/routing/routes.ts)**, not string
  literals.

## 6. Tests

Tests live under [src/test/](src/test), mirroring `src/app/` — `src/test/` in
place of `src/app/`. They are **not** co-located with the source.

| Put it in                 | When it is                                         | Example                                                                       |
| ------------------------- | -------------------------------------------------- | ----------------------------------------------------------------------------- |
| `src/test/<the app path>` | A unit test of one class                           | [event.service.spec.ts](src/test/features/event/domain/event.service.spec.ts) |
| `src/test/integration/`   | Several layers at once, over a mocked `HttpClient` | [events-api.spec.ts](src/test/integration/events-api.spec.ts)                 |
| `src/test/mocks/`         | A fixture more than one test needs                 | [EventMock](src/test/mocks/event-mock.ts)                                     |

The runner is Vitest through Angular's `@angular/build:unit-test` builder.
That builder hard-codes its glob root to `sourceRoot` with no override, and the
underlying matcher will not follow `../` out of it — which is why the suite
lives at `src/test/` rather than a top-level `test/` beside `src/`.
[tsconfig.spec.json](tsconfig.spec.json) matches, including only
`src/test/**/*.spec.ts`.

An integration test builds the real interceptor chain
(`provideHttpClient(withInterceptors([errorInterceptor]))`) and replaces only
the socket with `HttpTestingController`, so the error mapping under test is the
one that ships.

**A fixture describes one event at every layer it exists in.** `EventMock.json()`
is what the backend sends, `EventMock.entity()` is what it must become. Hand
the first to the fake backend and assert the result equals the second — a
mapper that drops a field is caught. `EventMock.dto()` is _parsed_ from
`EventMock.json()` rather than written out again, so the fixture and the wire
format cannot drift apart.

**Fixture times are UTC instants** — `'2026-03-14T18:30:00.000Z'`, never a local
literal. The suite has to pass in any timezone.

## 7. Adding a feature

1. `features/<name>/domain/entity/` — the entities, as plain `interface`s and
   `as const` unions. No Angular imports.
2. `features/<name>/data/dto/` — Zod schemas matching the backend, with types
   via `z.infer`.
3. `features/<name>/data/mapper/` — DTO ⇄ entity. Normalise here so the domain
   never sees wire quirks.
4. `features/<name>/data/<name>.repository.ts` — `@Service()`, inject
   `ApiClient`, one method per endpoint, pass a `parser`.
5. `features/<name>/domain/<name>.service.ts` — `@Service()`, the only surface
   presentation touches.
6. `features/<name>/presentation/<page>/` — the component, its `ViewModel`, and
   the ViewModel in the component's `providers: []`.
7. [app.routes.ts](src/app/app.routes.ts) — add a lazy `loadComponent` route,
   and [core/routing/routes.ts](src/app/core/routing/routes.ts) — add its URL
   builder.
8. `src/test/features/<name>/…` — mirror the paths above; see §6.
9. `npm run lint` — the boundary rules will tell you if step 3 or 6 reached
   across a layer.

There is no code generation step. Nothing needs regenerating after an edit.

## 8. Details worth knowing

**Zod is scoped to DTOs and form rules, not used everywhere.** It parses wire
shapes ([event.dto.ts](src/app/features/event/data/dto/event.dto.ts)) and
defines form validation
([event-form-schema.ts](src/app/features/event/domain/event-form-schema.ts)).
`ProblemDetail` and `CursorPage` stay hand-rolled — a deliberate decision after
measuring what Zod costs in the bundle.

**Form validation lives in the schema, never in the component.** The event form
uses Reactive Forms, with Zod bridged in through
[zodValidator()](src/app/shared/forms/zod-validator.ts), which wraps a schema as
an Angular `ValidatorFn` and files every message under one `zod` error key. Add
rules to `event-form-schema.ts`; do not retype them as `Validators.*`, which is
how the two drift apart. Zod messages must be written out explicitly — the
defaults leak internals, e.g. a bare `z.coerce.date()` reports "Invalid input:
expected date, received Date" for an empty control.

Cross-field rules are the exception: the capacity check (registered ≤ limit)
is a sibling-reading `ValidatorFn` on the control itself, mirroring how mobile
checks capacity inside its registered-participants validator. A control that
reads a sibling must be revalidated when that sibling changes, which is why
`EventForm` subscribes to `participantLimit.valueChanges`.

**The URL is the source of truth for list filters**, not a signal mirroring it.
`EventList` reads `queryParamMap` and parses it through
[parseEventQuery](src/app/features/event/domain/event-query.ts), so a filtered
list is shareable and Back restores what you had. Typing is debounced and
navigates with `replaceUrl: true` so the search box does not fill the back
stack.

**Times are UTC on the wire, `Date` in the domain.** The DTO schema coerces
inbound ISO strings to `Date`; `event.mapper.ts` calls `.toISOString()`
outbound, so requests are always unambiguous. The form converts between a
`Date` and the `datetime-local` input's string form with `date-fns`.

**Status transitions are mirrored from the backend.**
[allowedTransitions](src/app/features/event/domain/entity/event-status.ts)
duplicates the backend's `EventStatus.ALLOWED_TRANSITIONS` so the edit form can
offer only legal targets. It is a duplicate, and it has to be updated when the
backend's map changes — the backend remains the authority, this only keeps the
UI from offering a move it will reject.
