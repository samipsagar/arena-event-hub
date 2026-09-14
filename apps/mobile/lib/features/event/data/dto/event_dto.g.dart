// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventDto _$EventDtoFromJson(Map<String, dynamic> json) => _EventDto(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  sport: json['sport'] as String,
  status: json['status'] as String,
  venue: json['venue'] as String,
  startsAt: DateTime.parse(json['startsAt'] as String),
  endsAt: DateTime.parse(json['endsAt'] as String),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  participantLimit: (json['participantLimit'] as num).toInt(),
  registeredParticipants: (json['registeredParticipants'] as num).toInt(),
  spotsRemaining: (json['spotsRemaining'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$EventDtoToJson(_EventDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'sport': instance.sport,
  'status': instance.status,
  'venue': instance.venue,
  'startsAt': instance.startsAt.toIso8601String(),
  'endsAt': instance.endsAt.toIso8601String(),
  'durationMinutes': instance.durationMinutes,
  'participantLimit': instance.participantLimit,
  'registeredParticipants': instance.registeredParticipants,
  'spotsRemaining': instance.spotsRemaining,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
