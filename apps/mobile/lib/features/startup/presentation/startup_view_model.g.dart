// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the startup screen, and decides where the app opens.
///

@ProviderFor(StartupViewModel)
final startupViewModelProvider = StartupViewModelProvider._();

/// Drives the startup screen, and decides where the app opens.
///
final class StartupViewModelProvider
    extends $AsyncNotifierProvider<StartupViewModel, String> {
  /// Drives the startup screen, and decides where the app opens.
  ///
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

String _$startupViewModelHash() => r'531f5a773b900ceb0f37fcce1147d30445f2b4de';

/// Drives the startup screen, and decides where the app opens.
///

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
