// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventFormState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventFormState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventFormState()';
}


}

/// @nodoc
class $EventFormStateCopyWith<$Res>  {
$EventFormStateCopyWith(EventFormState _, $Res Function(EventFormState) __);
}


/// Adds pattern-matching-related methods to [EventFormState].
extension EventFormStatePatterns on EventFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EventFormIdle value)?  idle,TResult Function( EventFormSubmitting value)?  submitting,TResult Function( EventFormSuccess value)?  success,TResult Function( EventFormFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EventFormIdle() when idle != null:
return idle(_that);case EventFormSubmitting() when submitting != null:
return submitting(_that);case EventFormSuccess() when success != null:
return success(_that);case EventFormFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EventFormIdle value)  idle,required TResult Function( EventFormSubmitting value)  submitting,required TResult Function( EventFormSuccess value)  success,required TResult Function( EventFormFailure value)  failure,}){
final _that = this;
switch (_that) {
case EventFormIdle():
return idle(_that);case EventFormSubmitting():
return submitting(_that);case EventFormSuccess():
return success(_that);case EventFormFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EventFormIdle value)?  idle,TResult? Function( EventFormSubmitting value)?  submitting,TResult? Function( EventFormSuccess value)?  success,TResult? Function( EventFormFailure value)?  failure,}){
final _that = this;
switch (_that) {
case EventFormIdle() when idle != null:
return idle(_that);case EventFormSubmitting() when submitting != null:
return submitting(_that);case EventFormSuccess() when success != null:
return success(_that);case EventFormFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function( Event event)?  success,TResult Function( AppException error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EventFormIdle() when idle != null:
return idle();case EventFormSubmitting() when submitting != null:
return submitting();case EventFormSuccess() when success != null:
return success(_that.event);case EventFormFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function( Event event)  success,required TResult Function( AppException error)  failure,}) {final _that = this;
switch (_that) {
case EventFormIdle():
return idle();case EventFormSubmitting():
return submitting();case EventFormSuccess():
return success(_that.event);case EventFormFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function( Event event)?  success,TResult? Function( AppException error)?  failure,}) {final _that = this;
switch (_that) {
case EventFormIdle() when idle != null:
return idle();case EventFormSubmitting() when submitting != null:
return submitting();case EventFormSuccess() when success != null:
return success(_that.event);case EventFormFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class EventFormIdle implements EventFormState {
  const EventFormIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventFormIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventFormState.idle()';
}


}




/// @nodoc


class EventFormSubmitting implements EventFormState {
  const EventFormSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventFormSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventFormState.submitting()';
}


}




/// @nodoc


class EventFormSuccess implements EventFormState {
  const EventFormSuccess(this.event);
  

 final  Event event;

/// Create a copy of EventFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventFormSuccessCopyWith<EventFormSuccess> get copyWith => _$EventFormSuccessCopyWithImpl<EventFormSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventFormSuccess&&(identical(other.event, event) || other.event == event));
}


@override
int get hashCode => Object.hash(runtimeType,event);

@override
String toString() {
  return 'EventFormState.success(event: $event)';
}


}

/// @nodoc
abstract mixin class $EventFormSuccessCopyWith<$Res> implements $EventFormStateCopyWith<$Res> {
  factory $EventFormSuccessCopyWith(EventFormSuccess value, $Res Function(EventFormSuccess) _then) = _$EventFormSuccessCopyWithImpl;
@useResult
$Res call({
 Event event
});


$EventCopyWith<$Res> get event;

}
/// @nodoc
class _$EventFormSuccessCopyWithImpl<$Res>
    implements $EventFormSuccessCopyWith<$Res> {
  _$EventFormSuccessCopyWithImpl(this._self, this._then);

  final EventFormSuccess _self;
  final $Res Function(EventFormSuccess) _then;

/// Create a copy of EventFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? event = null,}) {
  return _then(EventFormSuccess(
null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event,
  ));
}

/// Create a copy of EventFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res> get event {
  
  return $EventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

/// @nodoc


class EventFormFailure implements EventFormState {
  const EventFormFailure(this.error);
  

 final  AppException error;

/// Create a copy of EventFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventFormFailureCopyWith<EventFormFailure> get copyWith => _$EventFormFailureCopyWithImpl<EventFormFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventFormFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'EventFormState.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $EventFormFailureCopyWith<$Res> implements $EventFormStateCopyWith<$Res> {
  factory $EventFormFailureCopyWith(EventFormFailure value, $Res Function(EventFormFailure) _then) = _$EventFormFailureCopyWithImpl;
@useResult
$Res call({
 AppException error
});




}
/// @nodoc
class _$EventFormFailureCopyWithImpl<$Res>
    implements $EventFormFailureCopyWith<$Res> {
  _$EventFormFailureCopyWithImpl(this._self, this._then);

  final EventFormFailure _self;
  final $Res Function(EventFormFailure) _then;

/// Create a copy of EventFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(EventFormFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException,
  ));
}


}

// dart format on
