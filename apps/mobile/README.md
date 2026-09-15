# Arena — Mobile App

Flutter client for Arena Event Hub. Lives at `apps/mobile` inside the
`arena-event-hub` monorepo; the Java backend it talks to lives at `backend/`.

Package name: `sports` (so imports look like `package:sports/core/...`).
Targets Android (`com.arena.sports`) and iOS 13+.

---

## 1. Prerequisites

| Tool | Version | Notes |
| --- | --- | --- |
| [FVM](https://fvm.app) | 4.x | Manages the pinned Flutter SDK |
| Flutter | **3.44.4** | Pinned in [.fvmrc](.fvmrc) — do not use a global Flutter |
| Xcode | latest stable | iOS builds + CocoaPods |
| Android Studio | latest stable | Android SDK + an emulator image |
| JDK | 17 | Android Gradle build targets Java 17 |

Install FVM on macOS:

```bash
brew tap leoafarias/fvm
brew install fvm
```

## 2. First-time setup

From this directory (`apps/mobile`):

```bash
fvm install          # downloads Flutter 3.44.4 into .fvm/versions
fvm flutter pub get  # resolves dependencies
fvm flutter doctor   # confirm Android + iOS toolchains are green
```

iOS only, if pods are out of date:

```bash
cd ios && pod install && cd ..
```

**Always prefix Flutter/Dart commands with `fvm`.** A bare `flutter run` uses
whatever SDK is on your `PATH`, which will not match the pin and can silently
change `pubspec.lock`.

### Editor setup

VS Code is already wired up — [.vscode/settings.json](.vscode/settings.json)
points `dart.flutterSdkPath` at `.fvm/versions/3.44.4`, so the IDE analyzer uses
the pinned SDK. For Android Studio / IntelliJ, set the Flutter SDK path to
`<repo>/apps/mobile/.fvm/flutter_sdk` (Settings → Languages & Frameworks →
Flutter).

## 3. Running the app

Every run needs a base URL — there is no default, so a build that defines no
`API_BASE_URL` fails loudly instead of quietly pointing at someone's laptop.
[config/dev.json](config/dev.json) holds that one key, already set to
`http://localhost:8080`:

```bash
fvm flutter devices                                             # list what's attached
fvm flutter run --dart-define-from-file=config/dev.json         # default device
fvm flutter run --dart-define-from-file=config/dev.json -d <id> # pick a device
```

The file is a convenience, not a requirement — naming the variable inline does
the same job, which is handy for a one-off URL you do not want to commit:

```bash
fvm flutter run --dart-define=API_BASE_URL=http://localhost:8080
```

Hot reload is `r`, hot restart `R`, quit `q`.

The same flag works on `run`, `build` and `test`:

```bash
fvm flutter run       --dart-define-from-file=config/dev.json
fvm flutter build apk --dart-define-from-file=config/dev.json
fvm flutter test      --dart-define-from-file=config/dev.json
```

> **Defines are compile-time, not runtime.** The value is baked in by the
> compiler. Exporting `API_BASE_URL` in your shell does nothing, and changing
> it needs a full restart — hot reload will not pick it up. The files under
> `config/` carry one key, `API_BASE_URL`, and must be strict JSON.

### Pointing at a backend

[config/dev.json](config/dev.json) is `http://localhost:8080`. Whether
`localhost` actually reaches your machine depends on the target:

| Target | URL for a backend on your Mac's port 8080 |
| --- | --- |
| iOS simulator | `http://localhost:8080` — `config/dev.json` works as-is |
| Android emulator | `http://10.0.2.2:8080` — `localhost` resolves to the emulator itself |
| Physical device | `http://<your-LAN-IP>:8080` |

For the latter two, either name the URL inline on its own, or load the file and
override the one value — `--dart-define` beats a same-named key in
`--dart-define-from-file` regardless of flag order:

```bash
fvm flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080

fvm flutter run --dart-define-from-file=config/dev.json \
  --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

In VS Code, [.vscode/launch.json](.vscode/launch.json) exposes debug, profile
and release configurations, all on `config/dev.json` — pick one from the Run and
Debug panel instead of typing flags.

Plain HTTP to a non-localhost host is blocked by default on both platforms
(Android cleartext policy, iOS ATS). Pointing at a LAN IP over `http://` needs a
debug network-security-config on Android and an ATS exception in `Info.plist` on
iOS — neither is configured yet.

## 4. Code generation

`freezed`, `json_serializable` and `riverpod_generator` produce the `.freezed.dart`
and `.g.dart` files next to their sources. **These are committed**, so a fresh
clone builds without running the generator — but regenerate after touching any
`@freezed`, `@JsonSerializable` or `@riverpod` declaration:

```bash
fvm dart run build_runner build --delete-conflicting-outputs   # one-shot
fvm dart run build_runner watch  --delete-conflicting-outputs  # while editing
```

If the analyzer complains about a missing `_$Something`, you owe it a build.

## 5. Tests and analysis

```bash
fvm flutter analyze                 # static analysis + lints
fvm flutter test                    # all tests
fvm flutter test test/integration   # one folder
fvm flutter test --coverage         # writes coverage/lcov.info
```

No test needs a config file today, so plain `fvm flutter test` is enough.
The trap to know about: `dioProvider` reads `ApiConfig.baseUrl`, which throws
when `API_BASE_URL` is undefined. A test that reads that provider — or any
provider watching it — therefore needs a define:

```bash
fvm flutter test --dart-define-from-file=config/dev.json
```

The integration tests sidestep it by calling `createAppDio(baseUrl: ...)`
directly, which is why the suite runs without the flag.

Lints come from `flutter_lints` plus `riverpod_lint`, configured in
[analysis_options.yaml](analysis_options.yaml). Run both `analyze` and `test`
before pushing.

## 6. Building release artifacts

```bash
fvm flutter build apk       --release --dart-define-from-file=config/prod.json
fvm flutter build appbundle --release --dart-define-from-file=config/prod.json
fvm flutter build ipa       --release --dart-define-from-file=config/prod.json
```

`config/prod.json` (and a staging equivalent) does not exist yet — add it once
the real backend origins are known, following the shape of
[config/dev.json](config/dev.json). Until then pass the URL inline:

```bash
fvm flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com
```

Release signing is not configured yet — Android release builds currently use the
debug signing config, and iOS needs a team/provisioning profile in Xcode.

## 7. Project layout

```
config/              # --dart-define-from-file values
lib/
├── main.dart        # ProviderScope + MaterialApp.router
├── core/            # config, network, exception, feedback, observability
├── features/
│   ├── event/       # data / domain / presentation — events CRUD
│   └── startup/     # decides where the app opens
├── routing/         # go_router routes + navigation observer
└── shared/          # widgets with no feature knowledge
test/                # mirrors lib/ — see ARCHITECTURE.md §2
├── features/        # unit + widget tests, at the path of the code they cover
├── integration/     # several layers at once, over a mocked HTTP adapter
└── mocks/           # fixtures shared across the suite
```

Feature-first, with a domain layer in the middle: widgets talk to ViewModels,
ViewModels talk to a `Service`, and only the `data/` layer knows about JSON and
endpoints.

**→ [ARCHITECTURE.md](ARCHITECTURE.md)** covers where each kind of file goes,
the layer rules, naming conventions, and how to add a feature. Read it before
adding one.

## 8. Troubleshooting

| Symptom | Fix |
| --- | --- |
| `Flutter SDK not found` / wrong version in IDE | `fvm install`, then point the IDE at `.fvm/flutter_sdk` |
| `StateError: API_BASE_URL is not defined` | Pass `--dart-define-from-file=config/dev.json` |
| `Unable to connect to the server` on Android emulator | Use `10.0.2.2`, not `localhost` (see §3) |
| `--dart-define` value seems ignored | It is compile-time — full restart, not hot reload |
| Define file fails to parse | Must be strict JSON — no comments, no trailing commas |
| Missing `_$Foo` / undefined generated class | `fvm dart run build_runner build --delete-conflicting-outputs` |
| Analyzer plugin fails to start | `riverpod_lint` must stay on a version matching the pinned Dart SDK — see [analysis_options.yaml](analysis_options.yaml) |
| Analyzer disagrees with `fvm flutter analyze` | IDE is on a different SDK; check `dart.flutterSdkPath` |
| Stale build after dependency changes | `fvm flutter clean && fvm flutter pub get` |
| iOS build fails on pods | `cd ios && pod repo update && pod install` |
