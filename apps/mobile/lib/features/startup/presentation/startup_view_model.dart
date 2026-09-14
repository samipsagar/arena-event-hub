import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/routing/routes.dart';

part 'startup_view_model.g.dart';

/// Drives the startup screen, and decides where the app opens.
///
@Riverpod(keepAlive: true)
class StartupViewModel extends _$StartupViewModel {
  @override
  Future<String> build() => _load();

  /// Runs startup again after a failure.
  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }

  Future<String> _load() async {
    // TODO: replace this delay with the real startup work — call the backend
    // through a service, and throw an AppException when it is unreachable so
    // the screen shows its retry state. Once there is auth, return the route
    // that matches the result rather than always going home.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return Routes.home;
  }
}
