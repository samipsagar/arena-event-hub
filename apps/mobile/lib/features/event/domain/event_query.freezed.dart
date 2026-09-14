// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventQuery {

 EventStatus? get status; Sport? get sport; String? get search;
/// Create a copy of EventQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventQueryCopyWith<EventQuery> get copyWith => _$EventQueryCopyWithImpl<EventQuery>(this as EventQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventQuery&&(identical(other.status, status) || other.status == status)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,status,sport,search);

@override
String toString() {
  return 'EventQuery(status: $status, sport: $sport, search: $search)';
}


}

/// @nodoc
abstract mixin class $EventQueryCopyWith<$Res>  {
  factory $EventQueryCopyWith(EventQuery value, $Res Function(EventQuery) _then) = _$EventQueryCopyWithImpl;
@useResult
$Res call({
 EventStatus? status, Sport? sport, String? search
});




}
/// @nodoc
class _$EventQueryCopyWithImpl<$Res>
    implements $EventQueryCopyWith<$Res> {
  _$EventQueryCopyWithImpl(this._self, this._then);

  final EventQuery _self;
  final $Res Function(EventQuery) _then;

/// Create a copy of EventQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? sport = freezed,Object? search = freezed,}) {
  return _then(EventQuery(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus?,sport: freezed == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as Sport?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventQuery].
extension EventQueryPatterns on EventQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventQuery value)  $default,){
final _that = this;
switch (_that) {
case _EventQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventQuery value)?  $default,){
final _that = this;
switch (_that) {
case _EventQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EventStatus? status,  Sport? sport,  String? search)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventQuery() when $default != null:
return $default(_that.status,_that.sport,_that.search);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EventStatus? status,  Sport? sport,  String? search)  $default,) {final _that = this;
switch (_that) {
case _EventQuery():
return $default(_that.status,_that.sport,_that.search);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EventStatus? status,  Sport? sport,  String? search)?  $default,) {final _that = this;
switch (_that) {
case _EventQuery() when $default != null:
return $default(_that.status,_that.sport,_that.search);case _:
  return null;

}
}

}

/// @nodoc


class _EventQuery extends EventQuery {
  const _EventQuery({this.status, this.sport, this.search}): super._();
  

@override final  EventStatus? status;
@override final  Sport? sport;
@override final  String? search;

/// Create a copy of EventQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventQueryCopyWith<_EventQuery> get copyWith => __$EventQueryCopyWithImpl<_EventQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventQuery&&(identical(other.status, status) || other.status == status)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,status,sport,search);

@override
String toString() {
  return 'EventQuery(status: $status, sport: $sport, search: $search)';
}


}

/// @nodoc
abstract mixin class _$EventQueryCopyWith<$Res> implements $EventQueryCopyWith<$Res> {
  factory _$EventQueryCopyWith(_EventQuery value, $Res Function(_EventQuery) _then) = __$EventQueryCopyWithImpl;
@override @useResult
$Res call({
 EventStatus? status, Sport? sport, String? search
});




}
/// @nodoc
class __$EventQueryCopyWithImpl<$Res>
    implements _$EventQueryCopyWith<$Res> {
  __$EventQueryCopyWithImpl(this._self, this._then);

  final _EventQuery _self;
  final $Res Function(_EventQuery) _then;

/// Create a copy of EventQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? sport = freezed,Object? search = freezed,}) {
  return _then(_EventQuery(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus?,sport: freezed == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as Sport?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
