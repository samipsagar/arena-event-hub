// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventRequestDto {

 String get title; String get description; String get venue; String get sport; String get status; DateTime get startsAt; int get durationInMinutes; int get participantLimit; int get registeredParticipants;
/// Create a copy of EventRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventRequestDtoCopyWith<EventRequestDto> get copyWith => _$EventRequestDtoCopyWithImpl<EventRequestDto>(this as EventRequestDto, _$identity);

  /// Serializes this EventRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventRequestDto&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.participantLimit, participantLimit) || other.participantLimit == participantLimit)&&(identical(other.registeredParticipants, registeredParticipants) || other.registeredParticipants == registeredParticipants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,venue,sport,status,startsAt,durationInMinutes,participantLimit,registeredParticipants);

@override
String toString() {
  return 'EventRequestDto(title: $title, description: $description, venue: $venue, sport: $sport, status: $status, startsAt: $startsAt, durationInMinutes: $durationInMinutes, participantLimit: $participantLimit, registeredParticipants: $registeredParticipants)';
}


}

/// @nodoc
abstract mixin class $EventRequestDtoCopyWith<$Res>  {
  factory $EventRequestDtoCopyWith(EventRequestDto value, $Res Function(EventRequestDto) _then) = _$EventRequestDtoCopyWithImpl;
@useResult
$Res call({
 String title, String description, String venue, String sport, String status, DateTime startsAt, int durationInMinutes, int participantLimit, int registeredParticipants
});




}
/// @nodoc
class _$EventRequestDtoCopyWithImpl<$Res>
    implements $EventRequestDtoCopyWith<$Res> {
  _$EventRequestDtoCopyWithImpl(this._self, this._then);

  final EventRequestDto _self;
  final $Res Function(EventRequestDto) _then;

/// Create a copy of EventRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? venue = null,Object? sport = null,Object? status = null,Object? startsAt = null,Object? durationInMinutes = null,Object? participantLimit = null,Object? registeredParticipants = null,}) {
  return _then(EventRequestDto(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,participantLimit: null == participantLimit ? _self.participantLimit : participantLimit // ignore: cast_nullable_to_non_nullable
as int,registeredParticipants: null == registeredParticipants ? _self.registeredParticipants : registeredParticipants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EventRequestDto].
extension EventRequestDtoPatterns on EventRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _EventRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _EventRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  String venue,  String sport,  String status,  DateTime startsAt,  int durationInMinutes,  int participantLimit,  int registeredParticipants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventRequestDto() when $default != null:
return $default(_that.title,_that.description,_that.venue,_that.sport,_that.status,_that.startsAt,_that.durationInMinutes,_that.participantLimit,_that.registeredParticipants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  String venue,  String sport,  String status,  DateTime startsAt,  int durationInMinutes,  int participantLimit,  int registeredParticipants)  $default,) {final _that = this;
switch (_that) {
case _EventRequestDto():
return $default(_that.title,_that.description,_that.venue,_that.sport,_that.status,_that.startsAt,_that.durationInMinutes,_that.participantLimit,_that.registeredParticipants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  String venue,  String sport,  String status,  DateTime startsAt,  int durationInMinutes,  int participantLimit,  int registeredParticipants)?  $default,) {final _that = this;
switch (_that) {
case _EventRequestDto() when $default != null:
return $default(_that.title,_that.description,_that.venue,_that.sport,_that.status,_that.startsAt,_that.durationInMinutes,_that.participantLimit,_that.registeredParticipants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventRequestDto implements EventRequestDto {
  const _EventRequestDto({required this.title, required this.description, required this.venue, required this.sport, required this.status, required this.startsAt, required this.durationInMinutes, required this.participantLimit, required this.registeredParticipants});
  factory _EventRequestDto.fromJson(Map<String, dynamic> json) => _$EventRequestDtoFromJson(json);

@override final  String title;
@override final  String description;
@override final  String venue;
@override final  String sport;
@override final  String status;
@override final  DateTime startsAt;
@override final  int durationInMinutes;
@override final  int participantLimit;
@override final  int registeredParticipants;

/// Create a copy of EventRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventRequestDtoCopyWith<_EventRequestDto> get copyWith => __$EventRequestDtoCopyWithImpl<_EventRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventRequestDto&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.participantLimit, participantLimit) || other.participantLimit == participantLimit)&&(identical(other.registeredParticipants, registeredParticipants) || other.registeredParticipants == registeredParticipants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,venue,sport,status,startsAt,durationInMinutes,participantLimit,registeredParticipants);

@override
String toString() {
  return 'EventRequestDto(title: $title, description: $description, venue: $venue, sport: $sport, status: $status, startsAt: $startsAt, durationInMinutes: $durationInMinutes, participantLimit: $participantLimit, registeredParticipants: $registeredParticipants)';
}


}

/// @nodoc
abstract mixin class _$EventRequestDtoCopyWith<$Res> implements $EventRequestDtoCopyWith<$Res> {
  factory _$EventRequestDtoCopyWith(_EventRequestDto value, $Res Function(_EventRequestDto) _then) = __$EventRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, String venue, String sport, String status, DateTime startsAt, int durationInMinutes, int participantLimit, int registeredParticipants
});




}
/// @nodoc
class __$EventRequestDtoCopyWithImpl<$Res>
    implements _$EventRequestDtoCopyWith<$Res> {
  __$EventRequestDtoCopyWithImpl(this._self, this._then);

  final _EventRequestDto _self;
  final $Res Function(_EventRequestDto) _then;

/// Create a copy of EventRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? venue = null,Object? sport = null,Object? status = null,Object? startsAt = null,Object? durationInMinutes = null,Object? participantLimit = null,Object? registeredParticipants = null,}) {
  return _then(_EventRequestDto(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,participantLimit: null == participantLimit ? _self.participantLimit : participantLimit // ignore: cast_nullable_to_non_nullable
as int,registeredParticipants: null == registeredParticipants ? _self.registeredParticipants : registeredParticipants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
