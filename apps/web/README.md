# Arena — Web App

Angular client for Arena Event Hub. Lives at `apps/web` inside the
`arena-event-hub` monorepo; the Java backend it talks to lives at `backend/`,
and the Flutter client it mirrors lives at [apps/mobile](../mobile).

Angular 22, standalone and **zoneless** (there is no `zone.js` — Angular 22
defaults to zoneless when it is absent). Component selectors are prefixed
`arena`, so components read `<arena-event-list>`.

---

## 1. Prerequisites

| Tool        | Version      | Notes                                                                            |
| ----------- | ------------ | -------------------------------------------------------------------------------- |
| Node.js     | **22.22.3+** | Angular 22 requires `^22.22.3 \|\| ^24.15.0 \|\| >=26`. Node 20 is not supported |
| npm         | **12.x**     | Pinned via `packageManager` in [package.json](package.json)                      |
| Angular CLI | 22.1.x       | Comes from devDependencies — use `npx ng`, no global install needed              |

A global `ng` is optional and easy to get wrong: if yours is older than the
project's, `ng serve` errors on an unknown builder. `npm start` / `npm test`
always run the local CLI, so prefer the npm scripts.

## 2. First-time setup

From this directory (`apps/web`):

```bash
npm ci        # installs the exact lockfile versions
npm start     # serves on http://localhost:4200
```

`npm ci` rather than `npm install` — it honours `package-lock.json` exactly and
will not silently drift dependencies.

## 3. Running the app

```bash
npm start                      # ng serve, development configuration
npm run watch                  # rebuild to dist/ on change, no dev server
npx ng serve --port 4300       # different port
```

The dev server serves `http://localhost:4200` and reloads on save.

### Pointing at a backend

There is no runtime config file. The API origin comes from the environment file
the build configuration swaps in, and is provided as the `API_BASE_URL`
injection token by [provideAppConfig()](src/app/core/config/app-config.provider.ts):

| File                                                                      | Used by                                            | Value                   |
| ------------------------------------------------------------------------- | -------------------------------------------------- | ----------------------- |
| [environment.development.ts](src/environments/environment.development.ts) | `ng serve`, `ng build --configuration development` | `http://localhost:8080` |
| [environment.ts](src/environments/environment.ts)                         | the production build                               | **blank**               |

**A blank base URL throws at bootstrap rather than defaulting to something.**
That is deliberate: a build that forgets to set an origin should fail loudly,
not quietly point at `localhost` and appear to work on the one machine that
happens to be running a backend. The consequence to know about: **`ng build`
defaults to the production configuration, so a plain `npm run build` produces a
bundle that throws on load** until a real origin is filled in — see §6.

Running the backend on port 8080 is enough for local work. Its
`app.cors.allowed-origins` already lists `http://localhost:4200` and
`http://127.0.0.1:4200`, so no CORS setup is needed; pick one of those two
spellings, because a dev server on any other port or host is not on that list.

## 4. Tests and linting

```bash
npm test                 # Vitest, via the @angular/build:unit-test builder
npm run lint             # ESLint over src/**/*.ts and src/**/*.html
npm run lint:fix
npm run format           # Prettier --write
npm run format:check
```

Tests live in [src/test/](src/test), mirroring `src/app/` rather than sitting
next to the code — see [ARCHITECTURE.md](ARCHITECTURE.md) §6 for why, and for
what belongs where. No test needs a backend: the integration suite replaces the
socket with `HttpTestingController` and nothing else.

`npm run lint` is not only style. It also enforces the layer boundaries
(`eslint-plugin-boundaries`), so an import from a page straight into a
repository fails the build rather than merely looking wrong in review. Run lint
and tests before pushing.

There is no e2e suite and no `ng e2e` target configured.

## 5. Building

```bash
npm run build                              # production configuration (default)
npx ng build --configuration development   # dev config, unminified, sourcemaps
```

Output lands in `dist/`. The production configuration hashes filenames and
enforces bundle budgets — 900 kB warning, 1.1 MB error on the initial bundle.
A budget failure is a real error, not a warning to raise: it usually means
something pulled a heavy dependency into an eagerly-loaded chunk. Every route is
lazy (`loadComponent`), so check what landed in the initial bundle before
raising the ceiling.

## 6. Shipping to a real environment

Production builds are **not release-ready yet**. `environment.ts` ships a blank
`apiBaseUrl` and the build has no `fileReplacements` for a staging or production
origin. The mobile app has the same gap, so neither client is deployable until
the real backend origins are known.

To deploy, fill in `apiBaseUrl` in [environment.ts](src/environments/environment.ts)
(or add per-environment files plus matching `fileReplacements` entries in
[angular.json](angular.json), following the development configuration's shape),
and add that origin to the backend's `app.cors.allowed-origins`.

## 7. Project layout

```
src/
├── main.ts                  # bootstrapApplication(App, appConfig)
├── styles.css               # Tailwind v4 + a few global overrides
├── material-theme.scss      # minimal Material theme
├── environments/            # apiBaseUrl per build configuration
├── app/
│   ├── app.config.ts        # providers: router, http, config, feedback, observability
│   ├── app.routes.ts        # lazy routes under /events
│   ├── core/                # config, error, http, feedback, observability, routing
│   ├── features/
│   │   └── event/           # data / domain / presentation — events CRUD
│   └── shared/              # forms + UI with no feature knowledge
└── test/                    # mirrors app/ — see ARCHITECTURE.md §6
    ├── features/            # unit tests, at the path of the code they cover
    ├── integration/         # several layers at once, over a mocked HttpClient
    └── mocks/               # fixtures shared across the suite
```

Feature-first, with a domain layer in the middle: components talk to
ViewModels and a store, those talk to a `Service`, and only `data/` knows about
JSON and endpoints.

**→ [ARCHITECTURE.md](ARCHITECTURE.md)** covers the layer rules, where each kind
of file goes, the naming conventions, and how to add a feature. Read it before
adding one.

## 8. Styling and UI

Tailwind v4 does the layout and typography; Angular Material supplies the
components (form fields, cards, dialog, snackbar). The theme in
[material-theme.scss](src/material-theme.scss) is deliberately minimal — it
covers what Material needs and leaves the rest to Tailwind, so it skips the
body-level overrides `ng add @angular/material` normally scaffolds.

**Do not use `MatDatepickerModule` or `MatTimepickerModule` in this app.** Both
throw `NG0103: Infinite change detection` under zoneless change detection as
soon as their overlay opens. Use a native `<input matInput type="datetime-local">`
inside a `mat-form-field`, as the event form does. Recheck when bumping
`@angular/material`.

