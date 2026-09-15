// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventDetailViewModel)
final eventDetailViewModelProvider = EventDetailViewModelFamily._();

final class EventDetailViewModelProvider
    extends $AsyncNotifierProvider<EventDetailViewModel, Event> {
  EventDetailViewModelProvider._({
    required EventDetailViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventDetailViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventDetailViewModelHash();

  @override
  String toString() {
    return r'eventDetailViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EventDetailViewModel create() => EventDetailViewModel();

  @override
  bool operator ==(Object other) {
    return other is EventDetailViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventDetailViewModelHash() =>
    r'f02308832f4048f4cf8e9cbd663a3f6c682899da';

final class EventDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          EventDetailViewModel,
          AsyncValue<Event>,
          Event,
          FutureOr<Event>,
          String
        > {
  EventDetailViewModelFamily._()
    : super(
        retry: null,
        name: r'eventDetailViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventDetailViewModelProvider call(String eventId) =>
      EventDetailViewModelProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventDetailViewModelProvider';
}

abstract class _$EventDetailViewModel extends $AsyncNotifier<Event> {
  late final _$args = ref.$arg as String;
  String get eventId => _$args;

  FutureOr<Event> build(String eventId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Event>, Event>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Event>, Event>,
              AsyncValue<Event>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
