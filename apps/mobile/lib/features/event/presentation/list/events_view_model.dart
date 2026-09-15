import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/core/feedback/feedback_service.dart';
import 'package:sports/core/feedback/providers.dart';
import 'package:sports/features/event/presentation/list/events_filter_view_model.dart';
import 'package:sports/features/event/presentation/list/events_state.dart';
import 'package:sports/features/event/providers.dart';

part 'events_view_model.g.dart';

/// Riverpod retries a failed build on its own, with a growing delay. Turned
/// off here because the screen offers its own Retry, which a hidden retry
/// would race.
Duration? _noAutomaticRetry(int retryCount, Object error) => null;

@Riverpod(retry: _noAutomaticRetry)
class EventsViewModel extends _$EventsViewModel {
  @override
  Future<EventsState> build() {
    final query = ref.watch(eventsFilterViewModelProvider);

    return ref
        .watch(eventServiceProvider)
        .loadEvents(query: query)
        .then(EventsState.fromPage);
  }

  /// Loads the page after the one on screen and appends it.
  Future<void> loadMore() async {
    final current = state.value;

    if (current == null || !current.hasNext || current.isLoadingMore) {
      return;
    }

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    try {
      final page = await ref
          .read(eventServiceProvider)
          .loadEvents(
            query: ref.read(eventsFilterViewModelProvider),
            cursor: current.nextCursor,
          );

      final latest = state.value;

      if (latest == null || !latest.isLoadingMore) {
        return;
      }

      state = AsyncValue.data(latest.appending(page));
    } on AppException catch (error) {
      state = AsyncValue.data(
        (state.value ?? current).copyWith(isLoadingMore: false),
      );

      _report(error);
    }
  }

  /// Loads the first page again, keeping the current filters.
  ///
  Future<void> refresh() async {
    final current = state.value;

    if (current == null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(_firstPage);

      return;
    }

    try {
      state = AsyncValue.data(await _firstPage());
    } on AppException catch (error) {
      state = AsyncValue.data(state.value ?? current);

      _report(error);
    }
  }

  Future<EventsState> _firstPage() {
    return ref
        .read(eventServiceProvider)
        .loadEvents(query: ref.read(eventsFilterViewModelProvider))
        .then(EventsState.fromPage);
  }

  void _report(AppException error) {
    // The app cancelled this itself, so there is nothing for the user to do.
    if (error is CancelledException) {
      return;
    }

    ref.read(feedbackServiceProvider).showError(error.message);
  }
}
