// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_delete_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventDeleteState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDeleteState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventDeleteState()';
}


}

/// @nodoc
class $EventDeleteStateCopyWith<$Res>  {
$EventDeleteStateCopyWith(EventDeleteState _, $Res Function(EventDeleteState) __);
}


/// Adds pattern-matching-related methods to [EventDeleteState].
extension EventDeleteStatePatterns on EventDeleteState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EventDeleteIdle value)?  idle,TResult Function( EventDeleteDeleting value)?  deleting,TResult Function( EventDeleteSuccess value)?  success,TResult Function( EventDeleteFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EventDeleteIdle() when idle != null:
return idle(_that);case EventDeleteDeleting() when deleting != null:
return deleting(_that);case EventDeleteSuccess() when success != null:
return success(_that);case EventDeleteFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EventDeleteIdle value)  idle,required TResult Function( EventDeleteDeleting value)  deleting,required TResult Function( EventDeleteSuccess value)  success,required TResult Function( EventDeleteFailure value)  failure,}){
final _that = this;
switch (_that) {
case EventDeleteIdle():
return idle(_that);case EventDeleteDeleting():
return deleting(_that);case EventDeleteSuccess():
return success(_that);case EventDeleteFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EventDeleteIdle value)?  idle,TResult? Function( EventDeleteDeleting value)?  deleting,TResult? Function( EventDeleteSuccess value)?  success,TResult? Function( EventDeleteFailure value)?  failure,}){
final _that = this;
switch (_that) {
case EventDeleteIdle() when idle != null:
return idle(_that);case EventDeleteDeleting() when deleting != null:
return deleting(_that);case EventDeleteSuccess() when success != null:
return success(_that);case EventDeleteFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  deleting,TResult Function()?  success,TResult Function( AppException error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EventDeleteIdle() when idle != null:
return idle();case EventDeleteDeleting() when deleting != null:
return deleting();case EventDeleteSuccess() when success != null:
return success();case EventDeleteFailure() when failure != null:
return failure(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  deleting,required TResult Function()  success,required TResult Function( AppException error)  failure,}) {final _that = this;
switch (_that) {
case EventDeleteIdle():
return idle();case EventDeleteDeleting():
return deleting();case EventDeleteSuccess():
return success();case EventDeleteFailure():
return failure(_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  deleting,TResult? Function()?  success,TResult? Function( AppException error)?  failure,}) {final _that = this;
switch (_that) {
case EventDeleteIdle() when idle != null:
return idle();case EventDeleteDeleting() when deleting != null:
return deleting();case EventDeleteSuccess() when success != null:
return success();case EventDeleteFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class EventDeleteIdle implements EventDeleteState {
  const EventDeleteIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDeleteIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventDeleteState.idle()';
}


}




/// @nodoc


class EventDeleteDeleting implements EventDeleteState {
  const EventDeleteDeleting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDeleteDeleting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventDeleteState.deleting()';
}


}




/// @nodoc


class EventDeleteSuccess implements EventDeleteState {
  const EventDeleteSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDeleteSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventDeleteState.success()';
}


}




/// @nodoc


class EventDeleteFailure implements EventDeleteState {
  const EventDeleteFailure(this.error);
  

 final  AppException error;

/// Create a copy of EventDeleteState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDeleteFailureCopyWith<EventDeleteFailure> get copyWith => _$EventDeleteFailureCopyWithImpl<EventDeleteFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDeleteFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'EventDeleteState.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $EventDeleteFailureCopyWith<$Res> implements $EventDeleteStateCopyWith<$Res> {
  factory $EventDeleteFailureCopyWith(EventDeleteFailure value, $Res Function(EventDeleteFailure) _then) = _$EventDeleteFailureCopyWithImpl;
@useResult
$Res call({
 AppException error
});




}
/// @nodoc
class _$EventDeleteFailureCopyWithImpl<$Res>
    implements $EventDeleteFailureCopyWith<$Res> {
  _$EventDeleteFailureCopyWithImpl(this._self, this._then);

  final EventDeleteFailure _self;
  final $Res Function(EventDeleteFailure) _then;

/// Create a copy of EventDeleteState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(EventDeleteFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException,
  ));
}


}

// dart format on
