# App Architecture

Feature-first, with a domain layer in the middle. Each feature owns a vertical
slice — its own data, domain and presentation — and shared plumbing lives in
`core/`. The goal is that a change to "how events are fetched" touches one
folder, and a change to "how errors are shown" touches one file.

---

## 1. The layers

```
presentation   Widgets + ViewModels        knows: domain
      │                                    never: DTOs, Dio, endpoints
      ▼
   domain      Services + Entities         the app's own vocabulary
      │
      ▼
     data      Repositories + DTOs         knows: HTTP paths, JSON
      │
      ▼
     core      ApiClient → Dio             knows: transport
```

Each layer talks only to the one below it. The rule that matters in review:
**a widget must never see an `EventDto`, and a repository must never see an
`Event`.** `Mapper`s are the border crossing.

> One honest deviation from textbook clean architecture: `EventService`
> (domain) depends on `EventRepository` (data) directly, rather than on an
> interface the domain owns. With one backend and one implementation, the
> indirection would buy nothing today. If a second source appears (cache,
> offline store), introduce the interface in `domain/` then.

## 2. Where goes what

| Put it in | When it is | Example |
| --- | --- | --- |
| `features/<name>/domain/entity/` | A thing the app reasons about | [Event](lib/features/event/domain/entity/event.dart) |
| `features/<name>/domain/` | A use case, orchestration, business rule | [EventService](lib/features/event/domain/event_service.dart) |
| `features/<name>/data/dto/` | The wire shape, exactly as the backend sends it | [EventDto](lib/features/event/data/dto/event_dto.dart) |
| `features/<name>/data/mapper/` | DTO ⇄ entity translation | [EventMapper](lib/features/event/data/mapper/event_mapper.dart) |
| `features/<name>/data/` | Endpoints and HTTP verbs | [EventRepository](lib/features/event/data/event_repository.dart) |
| `features/<name>/presentation/<screen>/` | A screen, its ViewModel, its state | [EventsViewModel](lib/features/event/presentation/list/events_view_model.dart) |
| `features/<name>/presentation/widgets/` | A widget used by 2+ screens in this feature | [EventCard](lib/features/event/presentation/widgets/event_card.dart) |
| `features/<name>/providers.dart` | Hand-written wiring for the feature | [providers.dart](lib/features/event/providers.dart) |
| `core/` | Infrastructure every feature needs | networking, errors, feedback |
| `shared/widgets/` | A widget with no feature knowledge | [InfoWidget](lib/shared/widgets/feedbacks/info_widget.dart) |
| `routing/` | Routes and the router | [router.dart](lib/routing/router.dart) |

### The events feature, as built

```
features/event/
├── data/
│   ├── dto/            EventDto, EventRequestDto        (JSON in/out)
│   ├── mapper/         EventMapper, EventQueryMapper, SportMapper, EventStatusMapper
│   └── event_repository.dart                            (/api/v1/events)
├── domain/
│   ├── entity/         Event, EventStatus, Sport, EventsPage, EventFormData
│   ├── event_query.dart                                 (filter state)
│   └── event_service.dart                               (the only API presentation sees)
├── presentation/
│   ├── list/           EventsScreen + EventsViewModel + EventsFilterViewModel
│   ├── detail/         EventDetailScreen + detail/delete ViewModels
│   ├── form/           EventFormScreen + EventFormViewModel   (create and edit)
│   └── widgets/        EventCard, EventList, EventsFilterBar
└── providers.dart      mapper → repository → service
```

### Tests

A test lives at the path of the code it covers, with `test/` in place of
`lib/`. The two exceptions are for things that belong to no single layer.

| Put it in | When it is | Example |
| --- | --- | --- |
| `test/<the lib path>` | A unit or widget test of one class | [event_service_test.dart](test/features/event/domain/event_service_test.dart) |
| `test/integration/` | Several layers at once, over a faked socket | [events_api_test.dart](test/integration/events_api_test.dart) |
| `test/mocks/` | A fixture more than one test needs | [EventMock](test/mocks/event_mock.dart) |

`mocktail` fakes collaborators; `http_mock_adapter` fakes the socket. An
integration test builds the real `createAppDio`, so the interceptor chain under
test is the one that ships — that is why `dio_factory.dart` is split out from
`dioProvider` in the first place.

**A fixture describes one event at every layer it exists in.**
`EventMock.json()` is what the backend sends, `EventMock.entity()` is what it
must become. Hand the first to a faked backend and assert the result equals the
second — entities are `freezed`, so they compare whole instead of field by
field, and a mapper that drops a field is caught.

**Fixture times are UTC instants — `DateTime.utc(...).toLocal()`, never
`DateTime(...)`.** A local literal matches the mapper's output only on a machine
running UTC. The suite has to pass in any timezone.

## 3. What `core/` gives you

| Folder | What it does |
| --- | --- |
| [config/](lib/core/config/app_config.dart) | `ApiConfig` — base URL from `--dart-define`, timeouts. No fallback: a missing define throws. |
| [network/](lib/core/network/) | `ApiClient` (typed wrapper over Dio), `ErrorInterceptor`, `CursorPage`, `ProblemDetail` |
| [exception/](lib/core/exception/app_exception.dart) | Sealed `AppException`: `Client` / `Server` / `Network` / `Parsing` / `Cancelled` / `Unexpected` |
| [feedback/](lib/core/feedback/) | `FeedbackService` — snackbars with no `BuildContext`, via a `GlobalKey<ScaffoldMessengerState>` |
| [observability/](lib/core/observability/) | `ObservabilityService` — breadcrumbs, events, exceptions; fans out to a list of sinks |

### Errors

`ErrorInterceptor` converts every non-2xx and every transport failure into an
`AppException` **once, at the network edge**. Above that line nothing knows Dio
exists. Because `AppException` is `sealed`, a `switch` over it is exhaustive —
the compiler tells you when a new case appears.

Every `AppException.message` is safe to show a user. `cause` never is: it may
carry internals, and for a 5xx it may not even come from our backend.

`CancelledException` is the one failure UI should usually swallow — it almost
always means the app cancelled its own request (screen popped, search
superseded), so there is nothing for a person to act on.

### Observability

`observabilityServiceProvider` returns a `CompositeObservabilityService` that
currently fans out to `LoggerObservability` only. Adding Sentry or Firebase is
one more entry in that list — no caller changes. `ObservabilityNavigatorObserver`
is wired into the router, so breadcrumbs name the screen a person was on.

## 4. Presentation conventions

**Riverpod notifiers are named `ViewModel` — never `Controller`.**
`EventsViewModel`, `EventFormViewModel`, `StartupViewModel`.

Two shapes, picked by what the screen needs:

- **Async data** — `build()` returns `Future<T>`, the widget switches on
  `AsyncValue`. `EventsViewModel`, `EventDetailViewModel`.
- **A command** — `build()` returns a sealed state (idle/running/success/
  failure) and a method drives it. `EventDeleteViewModel`.

Other conventions:

- **State classes are `freezed`**, live next to their ViewModel, and are named
  `<Screen>State` — [EventsState](lib/features/event/presentation/list/events_state.dart).
- **Generated ViewModels use `@riverpod`** (codegen, `.g.dart`). Hand-written
  wiring providers use plain `Provider` in `providers.dart`.
- **Widgets don't catch exceptions.** A ViewModel catches `AppException` and
  either moves it into state or reports it through `feedbackServiceProvider`.
- **Disable Riverpod's automatic retry** when the screen offers its own Retry
  button, or the two race — see `_noAutomaticRetry` in `EventsViewModel`.

## 5. Adding a feature

1. `features/<name>/domain/entity/` — the entities, `freezed`.
2. `features/<name>/data/dto/` — DTOs matching the backend, `freezed` + `json_serializable`.
3. `features/<name>/data/mapper/` — DTO ⇄ entity. Normalise here (timezones,
   unknown enum values) so the domain never sees wire quirks.
4. `features/<name>/data/<name>_repository.dart` — take `ApiClient`, one method
   per endpoint, pass a `parser`.
5. `features/<name>/domain/<name>_service.dart` — the only surface presentation
   touches.
6. `features/<name>/providers.dart` — wire mapper → repository → service.
7. `features/<name>/presentation/<screen>/` — `ViewModel` + `State` + screen.
8. `routing/routes.dart` and `routing/router.dart` — add the route.
9. `fvm dart run build_runner build --delete-conflicting-outputs`.
10. `test/features/<name>/…` — mirror the paths above; see §2.

## 6. Two details worth knowing

**Unknown enum values are rejected, not absorbed.** `EventDto.sport` and
`.status` stay `String` on the wire, and the mapper decides what they mean —
but a value it does not recognise throws a `ParsingException` rather than
degrading to a fallback variant. An unrecognised value means the contract has
drifted, and failing on it is what stops the app mislabelling an event or
writing back a value the backend will refuse.

The cost is that the blast radius is a page rather than a row: one unknown
event fails the mapping of the whole page it arrives in. That is the right
trade while the clients ship in lockstep with the backend, and the wrong one
for an independently released client — the root
[README](../../README.md) §9 records the alternatives and when to revisit.

**Times are UTC on the wire, local in the domain.** `EventMapper` calls
`.toLocal()` inbound and `.toUtc()` outbound, so entities are always ready to
format and requests are always unambiguous.
