// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'events_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventsState {

 List<Event> get events; String? get nextCursor; bool get hasNext; bool get isLoadingMore;
/// Create a copy of EventsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventsStateCopyWith<EventsState> get copyWith => _$EventsStateCopyWithImpl<EventsState>(this as EventsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventsState&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(events),nextCursor,hasNext,isLoadingMore);

@override
String toString() {
  return 'EventsState(events: $events, nextCursor: $nextCursor, hasNext: $hasNext, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $EventsStateCopyWith<$Res>  {
  factory $EventsStateCopyWith(EventsState value, $Res Function(EventsState) _then) = _$EventsStateCopyWithImpl;
@useResult
$Res call({
 List<Event> events, String? nextCursor, bool hasNext, bool isLoadingMore
});




}
/// @nodoc
class _$EventsStateCopyWithImpl<$Res>
    implements $EventsStateCopyWith<$Res> {
  _$EventsStateCopyWithImpl(this._self, this._then);

  final EventsState _self;
  final $Res Function(EventsState) _then;

/// Create a copy of EventsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? events = null,Object? nextCursor = freezed,Object? hasNext = null,Object? isLoadingMore = null,}) {
  return _then(EventsState(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EventsState].
extension EventsStatePatterns on EventsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventsState value)  $default,){
final _that = this;
switch (_that) {
case _EventsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventsState value)?  $default,){
final _that = this;
switch (_that) {
case _EventsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Event> events,  String? nextCursor,  bool hasNext,  bool isLoadingMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventsState() when $default != null:
return $default(_that.events,_that.nextCursor,_that.hasNext,_that.isLoadingMore);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Event> events,  String? nextCursor,  bool hasNext,  bool isLoadingMore)  $default,) {final _that = this;
switch (_that) {
case _EventsState():
return $default(_that.events,_that.nextCursor,_that.hasNext,_that.isLoadingMore);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Event> events,  String? nextCursor,  bool hasNext,  bool isLoadingMore)?  $default,) {final _that = this;
switch (_that) {
case _EventsState() when $default != null:
return $default(_that.events,_that.nextCursor,_that.hasNext,_that.isLoadingMore);case _:
  return null;

}
}

}

/// @nodoc


class _EventsState extends EventsState {
  const _EventsState({required  List<Event> events, required this.nextCursor, required this.hasNext, this.isLoadingMore = false}): _events = events,super._();
  

 final  List<Event> _events;
@override List<Event> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override final  String? nextCursor;
@override final  bool hasNext;
@override@JsonKey() final  bool isLoadingMore;

/// Create a copy of EventsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventsStateCopyWith<_EventsState> get copyWith => __$EventsStateCopyWithImpl<_EventsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventsState&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_events),nextCursor,hasNext,isLoadingMore);

@override
String toString() {
  return 'EventsState(events: $events, nextCursor: $nextCursor, hasNext: $hasNext, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class _$EventsStateCopyWith<$Res> implements $EventsStateCopyWith<$Res> {
  factory _$EventsStateCopyWith(_EventsState value, $Res Function(_EventsState) _then) = __$EventsStateCopyWithImpl;
@override @useResult
$Res call({
 List<Event> events, String? nextCursor, bool hasNext, bool isLoadingMore
});




}
/// @nodoc
class __$EventsStateCopyWithImpl<$Res>
    implements _$EventsStateCopyWith<$Res> {
  __$EventsStateCopyWithImpl(this._self, this._then);

  final _EventsState _self;
  final $Res Function(_EventsState) _then;

/// Create a copy of EventsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? events = null,Object? nextCursor = freezed,Object? hasNext = null,Object? isLoadingMore = null,}) {
  return _then(_EventsState(
events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
