// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_delete_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives a single event deletion.

@ProviderFor(EventDeleteViewModel)
final eventDeleteViewModelProvider = EventDeleteViewModelProvider._();

/// Drives a single event deletion.
final class EventDeleteViewModelProvider
    extends $NotifierProvider<EventDeleteViewModel, EventDeleteState> {
  /// Drives a single event deletion.
  EventDeleteViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventDeleteViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventDeleteViewModelHash();

  @$internal
  @override
  EventDeleteViewModel create() => EventDeleteViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventDeleteState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventDeleteState>(value),
    );
  }
}

String _$eventDeleteViewModelHash() =>
    r'12b7670ea5ffb6d2bd3ceaa693c0b161a0436797';

/// Drives a single event deletion.

abstract class _$EventDeleteViewModel extends $Notifier<EventDeleteState> {
  EventDeleteState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EventDeleteState, EventDeleteState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EventDeleteState, EventDeleteState>,
              EventDeleteState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
