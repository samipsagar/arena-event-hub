// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventDto {

 String get id; String get title; String get description; String get sport; String get status; String get venue; DateTime get startsAt; DateTime get endsAt; int get durationInMinutes; int get participantLimit; int get registeredParticipants; int get spotsRemaining; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of EventDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDtoCopyWith<EventDto> get copyWith => _$EventDtoCopyWithImpl<EventDto>(this as EventDto, _$identity);

  /// Serializes this EventDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.status, status) || other.status == status)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.participantLimit, participantLimit) || other.participantLimit == participantLimit)&&(identical(other.registeredParticipants, registeredParticipants) || other.registeredParticipants == registeredParticipants)&&(identical(other.spotsRemaining, spotsRemaining) || other.spotsRemaining == spotsRemaining)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,sport,status,venue,startsAt,endsAt,durationInMinutes,participantLimit,registeredParticipants,spotsRemaining,createdAt,updatedAt);

@override
String toString() {
  return 'EventDto(id: $id, title: $title, description: $description, sport: $sport, status: $status, venue: $venue, startsAt: $startsAt, endsAt: $endsAt, durationInMinutes: $durationInMinutes, participantLimit: $participantLimit, registeredParticipants: $registeredParticipants, spotsRemaining: $spotsRemaining, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EventDtoCopyWith<$Res>  {
  factory $EventDtoCopyWith(EventDto value, $Res Function(EventDto) _then) = _$EventDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String sport, String status, String venue, DateTime startsAt, DateTime endsAt, int durationInMinutes, int participantLimit, int registeredParticipants, int spotsRemaining, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$EventDtoCopyWithImpl<$Res>
    implements $EventDtoCopyWith<$Res> {
  _$EventDtoCopyWithImpl(this._self, this._then);

  final EventDto _self;
  final $Res Function(EventDto) _then;

/// Create a copy of EventDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? sport = null,Object? status = null,Object? venue = null,Object? startsAt = null,Object? endsAt = null,Object? durationInMinutes = null,Object? participantLimit = null,Object? registeredParticipants = null,Object? spotsRemaining = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(EventDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,participantLimit: null == participantLimit ? _self.participantLimit : participantLimit // ignore: cast_nullable_to_non_nullable
as int,registeredParticipants: null == registeredParticipants ? _self.registeredParticipants : registeredParticipants // ignore: cast_nullable_to_non_nullable
as int,spotsRemaining: null == spotsRemaining ? _self.spotsRemaining : spotsRemaining // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EventDto].
extension EventDtoPatterns on EventDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDto value)  $default,){
final _that = this;
switch (_that) {
case _EventDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDto value)?  $default,){
final _that = this;
switch (_that) {
case _EventDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String sport,  String status,  String venue,  DateTime startsAt,  DateTime endsAt,  int durationInMinutes,  int participantLimit,  int registeredParticipants,  int spotsRemaining,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.sport,_that.status,_that.venue,_that.startsAt,_that.endsAt,_that.durationInMinutes,_that.participantLimit,_that.registeredParticipants,_that.spotsRemaining,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String sport,  String status,  String venue,  DateTime startsAt,  DateTime endsAt,  int durationInMinutes,  int participantLimit,  int registeredParticipants,  int spotsRemaining,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _EventDto():
return $default(_that.id,_that.title,_that.description,_that.sport,_that.status,_that.venue,_that.startsAt,_that.endsAt,_that.durationInMinutes,_that.participantLimit,_that.registeredParticipants,_that.spotsRemaining,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String sport,  String status,  String venue,  DateTime startsAt,  DateTime endsAt,  int durationInMinutes,  int participantLimit,  int registeredParticipants,  int spotsRemaining,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _EventDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.sport,_that.status,_that.venue,_that.startsAt,_that.endsAt,_that.durationInMinutes,_that.participantLimit,_that.registeredParticipants,_that.spotsRemaining,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventDto implements EventDto {
  const _EventDto({required this.id, required this.title, this.description = '', required this.sport, required this.status, required this.venue, required this.startsAt, required this.endsAt, required this.durationInMinutes, required this.participantLimit, required this.registeredParticipants, required this.spotsRemaining, required this.createdAt, required this.updatedAt});
  factory _EventDto.fromJson(Map<String, dynamic> json) => _$EventDtoFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  String description;
@override final  String sport;
@override final  String status;
@override final  String venue;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  int durationInMinutes;
@override final  int participantLimit;
@override final  int registeredParticipants;
@override final  int spotsRemaining;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of EventDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDtoCopyWith<_EventDto> get copyWith => __$EventDtoCopyWithImpl<_EventDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.status, status) || other.status == status)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.participantLimit, participantLimit) || other.participantLimit == participantLimit)&&(identical(other.registeredParticipants, registeredParticipants) || other.registeredParticipants == registeredParticipants)&&(identical(other.spotsRemaining, spotsRemaining) || other.spotsRemaining == spotsRemaining)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,sport,status,venue,startsAt,endsAt,durationInMinutes,participantLimit,registeredParticipants,spotsRemaining,createdAt,updatedAt);

@override
String toString() {
  return 'EventDto(id: $id, title: $title, description: $description, sport: $sport, status: $status, venue: $venue, startsAt: $startsAt, endsAt: $endsAt, durationInMinutes: $durationInMinutes, participantLimit: $participantLimit, registeredParticipants: $registeredParticipants, spotsRemaining: $spotsRemaining, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EventDtoCopyWith<$Res> implements $EventDtoCopyWith<$Res> {
  factory _$EventDtoCopyWith(_EventDto value, $Res Function(_EventDto) _then) = __$EventDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String sport, String status, String venue, DateTime startsAt, DateTime endsAt, int durationInMinutes, int participantLimit, int registeredParticipants, int spotsRemaining, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$EventDtoCopyWithImpl<$Res>
    implements _$EventDtoCopyWith<$Res> {
  __$EventDtoCopyWithImpl(this._self, this._then);

  final _EventDto _self;
  final $Res Function(_EventDto) _then;

/// Create a copy of EventDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? sport = null,Object? status = null,Object? venue = null,Object? startsAt = null,Object? endsAt = null,Object? durationInMinutes = null,Object? participantLimit = null,Object? registeredParticipants = null,Object? spotsRemaining = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_EventDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,participantLimit: null == participantLimit ? _self.participantLimit : participantLimit // ignore: cast_nullable_to_non_nullable
as int,registeredParticipants: null == registeredParticipants ? _self.registeredParticipants : registeredParticipants // ignore: cast_nullable_to_non_nullable
as int,spotsRemaining: null == spotsRemaining ? _self.spotsRemaining : spotsRemaining // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
