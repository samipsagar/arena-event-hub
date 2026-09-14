// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventFormData {

 String? get id; String get title; String? get description; Sport get sport; EventStatus get status; String get venue; DateTime get startsAt; int get durationMinutes; int get participantLimit; int get registeredParticipants;
/// Create a copy of EventFormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventFormDataCopyWith<EventFormData> get copyWith => _$EventFormDataCopyWithImpl<EventFormData>(this as EventFormData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventFormData&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.status, status) || other.status == status)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.participantLimit, participantLimit) || other.participantLimit == participantLimit)&&(identical(other.registeredParticipants, registeredParticipants) || other.registeredParticipants == registeredParticipants));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,sport,status,venue,startsAt,durationMinutes,participantLimit,registeredParticipants);

@override
String toString() {
  return 'EventFormData(id: $id, title: $title, description: $description, sport: $sport, status: $status, venue: $venue, startsAt: $startsAt, durationMinutes: $durationMinutes, participantLimit: $participantLimit, registeredParticipants: $registeredParticipants)';
}


}

/// @nodoc
abstract mixin class $EventFormDataCopyWith<$Res>  {
  factory $EventFormDataCopyWith(EventFormData value, $Res Function(EventFormData) _then) = _$EventFormDataCopyWithImpl;
@useResult
$Res call({
 String? id, String title, String? description, Sport sport, EventStatus status, String venue, DateTime startsAt, int durationMinutes, int participantLimit, int registeredParticipants
});




}
/// @nodoc
class _$EventFormDataCopyWithImpl<$Res>
    implements $EventFormDataCopyWith<$Res> {
  _$EventFormDataCopyWithImpl(this._self, this._then);

  final EventFormData _self;
  final $Res Function(EventFormData) _then;

/// Create a copy of EventFormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? description = freezed,Object? sport = null,Object? status = null,Object? venue = null,Object? startsAt = null,Object? durationMinutes = null,Object? participantLimit = null,Object? registeredParticipants = null,}) {
  return _then(EventFormData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as Sport,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,participantLimit: null == participantLimit ? _self.participantLimit : participantLimit // ignore: cast_nullable_to_non_nullable
as int,registeredParticipants: null == registeredParticipants ? _self.registeredParticipants : registeredParticipants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EventFormData].
extension EventFormDataPatterns on EventFormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventFormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventFormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventFormData value)  $default,){
final _that = this;
switch (_that) {
case _EventFormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventFormData value)?  $default,){
final _that = this;
switch (_that) {
case _EventFormData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String title,  String? description,  Sport sport,  EventStatus status,  String venue,  DateTime startsAt,  int durationMinutes,  int participantLimit,  int registeredParticipants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventFormData() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.sport,_that.status,_that.venue,_that.startsAt,_that.durationMinutes,_that.participantLimit,_that.registeredParticipants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String title,  String? description,  Sport sport,  EventStatus status,  String venue,  DateTime startsAt,  int durationMinutes,  int participantLimit,  int registeredParticipants)  $default,) {final _that = this;
switch (_that) {
case _EventFormData():
return $default(_that.id,_that.title,_that.description,_that.sport,_that.status,_that.venue,_that.startsAt,_that.durationMinutes,_that.participantLimit,_that.registeredParticipants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String title,  String? description,  Sport sport,  EventStatus status,  String venue,  DateTime startsAt,  int durationMinutes,  int participantLimit,  int registeredParticipants)?  $default,) {final _that = this;
switch (_that) {
case _EventFormData() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.sport,_that.status,_that.venue,_that.startsAt,_that.durationMinutes,_that.participantLimit,_that.registeredParticipants);case _:
  return null;

}
}

}

/// @nodoc


class _EventFormData extends EventFormData {
  const _EventFormData({required this.id, required this.title, required this.description, required this.sport, required this.status, required this.venue, required this.startsAt, required this.durationMinutes, required this.participantLimit, required this.registeredParticipants}): super._();
  

@override final  String? id;
@override final  String title;
@override final  String? description;
@override final  Sport sport;
@override final  EventStatus status;
@override final  String venue;
@override final  DateTime startsAt;
@override final  int durationMinutes;
@override final  int participantLimit;
@override final  int registeredParticipants;

/// Create a copy of EventFormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventFormDataCopyWith<_EventFormData> get copyWith => __$EventFormDataCopyWithImpl<_EventFormData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventFormData&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.status, status) || other.status == status)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.participantLimit, participantLimit) || other.participantLimit == participantLimit)&&(identical(other.registeredParticipants, registeredParticipants) || other.registeredParticipants == registeredParticipants));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,sport,status,venue,startsAt,durationMinutes,participantLimit,registeredParticipants);

@override
String toString() {
  return 'EventFormData(id: $id, title: $title, description: $description, sport: $sport, status: $status, venue: $venue, startsAt: $startsAt, durationMinutes: $durationMinutes, participantLimit: $participantLimit, registeredParticipants: $registeredParticipants)';
}


}

/// @nodoc
abstract mixin class _$EventFormDataCopyWith<$Res> implements $EventFormDataCopyWith<$Res> {
  factory _$EventFormDataCopyWith(_EventFormData value, $Res Function(_EventFormData) _then) = __$EventFormDataCopyWithImpl;
@override @useResult
$Res call({
 String? id, String title, String? description, Sport sport, EventStatus status, String venue, DateTime startsAt, int durationMinutes, int participantLimit, int registeredParticipants
});




}
/// @nodoc
class __$EventFormDataCopyWithImpl<$Res>
    implements _$EventFormDataCopyWith<$Res> {
  __$EventFormDataCopyWithImpl(this._self, this._then);

  final _EventFormData _self;
  final $Res Function(_EventFormData) _then;

/// Create a copy of EventFormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? description = freezed,Object? sport = null,Object? status = null,Object? venue = null,Object? startsAt = null,Object? durationMinutes = null,Object? participantLimit = null,Object? registeredParticipants = null,}) {
  return _then(_EventFormData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as Sport,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,participantLimit: null == participantLimit ? _self.participantLimit : participantLimit // ignore: cast_nullable_to_non_nullable
as int,registeredParticipants: null == registeredParticipants ? _self.registeredParticipants : registeredParticipants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
