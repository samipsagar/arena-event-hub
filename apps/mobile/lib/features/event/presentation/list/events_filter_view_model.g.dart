// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_filter_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Event filter using sport, status or search text

@ProviderFor(EventsFilterViewModel)
final eventsFilterViewModelProvider = EventsFilterViewModelProvider._();

/// Event filter using sport, status or search text
final class EventsFilterViewModelProvider
    extends $NotifierProvider<EventsFilterViewModel, EventQuery> {
  /// Event filter using sport, status or search text
  EventsFilterViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventsFilterViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsFilterViewModelHash();

  @$internal
  @override
  EventsFilterViewModel create() => EventsFilterViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventQuery>(value),
    );
  }
}

String _$eventsFilterViewModelHash() =>
    r'cd5159f7c94eb5cb7fbc67a9c5417b1f0a68444f';

/// Event filter using sport, status or search text

abstract class _$EventsFilterViewModel extends $Notifier<EventQuery> {
  EventQuery build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EventQuery, EventQuery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EventQuery, EventQuery>,
              EventQuery,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
