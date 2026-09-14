// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the startup screen, and decides where the app opens.
///
/// The state is `AsyncValue<String>`, where the value is the route to open:
/// loading is the splash, error is the retry screen, and data is "go here".
/// Keeping the destination in the view model means the branching that startup
/// will grow — signed out, onboarding not finished, update required — stays in
/// one testable place instead of spreading into the router.

@ProviderFor(StartupViewModel)
final startupViewModelProvider = StartupViewModelProvider._();

/// Drives the startup screen, and decides where the app opens.
///
/// The state is `AsyncValue<String>`, where the value is the route to open:
/// loading is the splash, error is the retry screen, and data is "go here".
/// Keeping the destination in the view model means the branching that startup
/// will grow — signed out, onboarding not finished, update required — stays in
/// one testable place instead of spreading into the router.
final class StartupViewModelProvider
    extends $AsyncNotifierProvider<StartupViewModel, String> {
  /// Drives the startup screen, and decides where the app opens.
  ///
  /// The state is `AsyncValue<String>`, where the value is the route to open:
  /// loading is the splash, error is the retry screen, and data is "go here".
  /// Keeping the destination in the view model means the branching that startup
  /// will grow — signed out, onboarding not finished, update required — stays in
  /// one testable place instead of spreading into the router.
  StartupViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startupViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startupViewModelHash();

  @$internal
  @override
  StartupViewModel create() => StartupViewModel();
}

String _$startupViewModelHash() => r'd4b84dbf539bf350e894d123111a20c64e3f65a4';

/// Drives the startup screen, and decides where the app opens.
///
/// The state is `AsyncValue<String>`, where the value is the route to open:
/// loading is the splash, error is the retry screen, and data is "go here".
/// Keeping the destination in the view model means the branching that startup
/// will grow — signed out, onboarding not finished, update required — stays in
/// one testable place instead of spreading into the router.

abstract class _$StartupViewModel extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
