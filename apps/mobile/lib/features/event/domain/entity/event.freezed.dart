// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Event {

 String get id; String get title; String get description; Sport get sport; EventStatus get status; String get venue;/// In the device's timezone, ready to format.
 DateTime get startsAt; DateTime get endsAt; int get durationInMinutes; int get participantLimit; int get registeredParticipants; int get spotsRemaining;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.status, status) || other.status == status)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.participantLimit, participantLimit) || other.participantLimit == participantLimit)&&(identical(other.registeredParticipants, registeredParticipants) || other.registeredParticipants == registeredParticipants)&&(identical(other.spotsRemaining, spotsRemaining) || other.spotsRemaining == spotsRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,sport,status,venue,startsAt,endsAt,durationInMinutes,participantLimit,registeredParticipants,spotsRemaining);

@override
String toString() {
  return 'Event(id: $id, title: $title, description: $description, sport: $sport, status: $status, venue: $venue, startsAt: $startsAt, endsAt: $endsAt, durationInMinutes: $durationInMinutes, participantLimit: $participantLimit, registeredParticipants: $registeredParticipants, spotsRemaining: $spotsRemaining)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, Sport sport, EventStatus status, String venue, DateTime startsAt, DateTime endsAt, int durationInMinutes, int participantLimit, int registeredParticipants, int spotsRemaining
});




}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? sport = null,Object? status = null,Object? venue = null,Object? startsAt = null,Object? endsAt = null,Object? durationInMinutes = null,Object? participantLimit = null,Object? registeredParticipants = null,Object? spotsRemaining = null,}) {
  return _then(Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as Sport,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,participantLimit: null == participantLimit ? _self.participantLimit : participantLimit // ignore: cast_nullable_to_non_nullable
as int,registeredParticipants: null == registeredParticipants ? _self.registeredParticipants : registeredParticipants // ignore: cast_nullable_to_non_nullable
as int,spotsRemaining: null == spotsRemaining ? _self.spotsRemaining : spotsRemaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Event value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Event value)  $default,){
final _that = this;
switch (_that) {
case _Event():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Event value)?  $default,){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  Sport sport,  EventStatus status,  String venue,  DateTime startsAt,  DateTime endsAt,  int durationInMinutes,  int participantLimit,  int registeredParticipants,  int spotsRemaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.sport,_that.status,_that.venue,_that.startsAt,_that.endsAt,_that.durationInMinutes,_that.participantLimit,_that.registeredParticipants,_that.spotsRemaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  Sport sport,  EventStatus status,  String venue,  DateTime startsAt,  DateTime endsAt,  int durationInMinutes,  int participantLimit,  int registeredParticipants,  int spotsRemaining)  $default,) {final _that = this;
switch (_that) {
case _Event():
return $default(_that.id,_that.title,_that.description,_that.sport,_that.status,_that.venue,_that.startsAt,_that.endsAt,_that.durationInMinutes,_that.participantLimit,_that.registeredParticipants,_that.spotsRemaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  Sport sport,  EventStatus status,  String venue,  DateTime startsAt,  DateTime endsAt,  int durationInMinutes,  int participantLimit,  int registeredParticipants,  int spotsRemaining)?  $default,) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.sport,_that.status,_that.venue,_that.startsAt,_that.endsAt,_that.durationInMinutes,_that.participantLimit,_that.registeredParticipants,_that.spotsRemaining);case _:
  return null;

}
}

}

/// @nodoc


class _Event extends Event {
  const _Event({required this.id, required this.title, required this.description, required this.sport, required this.status, required this.venue, required this.startsAt, required this.endsAt, required this.durationInMinutes, required this.participantLimit, required this.registeredParticipants, required this.spotsRemaining}): super._();
  

@override final  String id;
@override final  String title;
@override final  String description;
@override final  Sport sport;
@override final  EventStatus status;
@override final  String venue;
/// In the device's timezone, ready to format.
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  int durationInMinutes;
@override final  int participantLimit;
@override final  int registeredParticipants;
@override final  int spotsRemaining;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCopyWith<_Event> get copyWith => __$EventCopyWithImpl<_Event>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.status, status) || other.status == status)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.participantLimit, participantLimit) || other.participantLimit == participantLimit)&&(identical(other.registeredParticipants, registeredParticipants) || other.registeredParticipants == registeredParticipants)&&(identical(other.spotsRemaining, spotsRemaining) || other.spotsRemaining == spotsRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,sport,status,venue,startsAt,endsAt,durationInMinutes,participantLimit,registeredParticipants,spotsRemaining);

@override
String toString() {
  return 'Event(id: $id, title: $title, description: $description, sport: $sport, status: $status, venue: $venue, startsAt: $startsAt, endsAt: $endsAt, durationInMinutes: $durationInMinutes, participantLimit: $participantLimit, registeredParticipants: $registeredParticipants, spotsRemaining: $spotsRemaining)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, Sport sport, EventStatus status, String venue, DateTime startsAt, DateTime endsAt, int durationInMinutes, int participantLimit, int registeredParticipants, int spotsRemaining
});




}
/// @nodoc
class __$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? sport = null,Object? status = null,Object? venue = null,Object? startsAt = null,Object? endsAt = null,Object? durationInMinutes = null,Object? participantLimit = null,Object? registeredParticipants = null,Object? spotsRemaining = null,}) {
  return _then(_Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as Sport,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,participantLimit: null == participantLimit ? _self.participantLimit : participantLimit // ignore: cast_nullable_to_non_nullable
as int,registeredParticipants: null == registeredParticipants ? _self.registeredParticipants : registeredParticipants // ignore: cast_nullable_to_non_nullable
as int,spotsRemaining: null == spotsRemaining ? _self.spotsRemaining : spotsRemaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
