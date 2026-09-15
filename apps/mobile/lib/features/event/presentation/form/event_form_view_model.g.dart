// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_form_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives a single create/update submission.

@ProviderFor(EventFormViewModel)
final eventFormViewModelProvider = EventFormViewModelProvider._();

/// Drives a single create/update submission.
final class EventFormViewModelProvider
    extends $NotifierProvider<EventFormViewModel, EventFormState> {
  /// Drives a single create/update submission.
  EventFormViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventFormViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventFormViewModelHash();

  @$internal
  @override
  EventFormViewModel create() => EventFormViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventFormState>(value),
    );
  }
}

String _$eventFormViewModelHash() =>
    r'a10a9652ec9c2ea2663512feedff4fb04a6dab98';

/// Drives a single create/update submission.

abstract class _$EventFormViewModel extends $Notifier<EventFormState> {
  EventFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EventFormState, EventFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EventFormState, EventFormState>,
              EventFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
