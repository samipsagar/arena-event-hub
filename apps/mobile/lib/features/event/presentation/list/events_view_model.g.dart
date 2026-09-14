// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventsViewModel)
final eventsViewModelProvider = EventsViewModelProvider._();

final class EventsViewModelProvider
    extends $AsyncNotifierProvider<EventsViewModel, EventsState> {
  EventsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noAutomaticRetry,
        name: r'eventsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsViewModelHash();

  @$internal
  @override
  EventsViewModel create() => EventsViewModel();
}

String _$eventsViewModelHash() => r'b9b77931a510b3a3f1f2bdfab914b20b71fb26e7';

abstract class _$EventsViewModel extends $AsyncNotifier<EventsState> {
  FutureOr<EventsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EventsState>, EventsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EventsState>, EventsState>,
              AsyncValue<EventsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
