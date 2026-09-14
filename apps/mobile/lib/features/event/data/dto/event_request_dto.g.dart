// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventRequestDto _$EventRequestDtoFromJson(Map<String, dynamic> json) =>
    _EventRequestDto(
      title: json['title'] as String,
      description: json['description'] as String,
      venue: json['venue'] as String,
      sport: json['sport'] as String,
      status: json['status'] as String,
      startsAt: DateTime.parse(json['startsAt'] as String),
      durationInMinutes: (json['durationInMinutes'] as num).toInt(),
      participantLimit: (json['participantLimit'] as num).toInt(),
      registeredParticipants: (json['registeredParticipants'] as num).toInt(),
    );

Map<String, dynamic> _$EventRequestDtoToJson(_EventRequestDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'venue': instance.venue,
      'sport': instance.sport,
      'status': instance.status,
      'startsAt': instance.startsAt.toIso8601String(),
      'durationInMinutes': instance.durationInMinutes,
      'participantLimit': instance.participantLimit,
      'registeredParticipants': instance.registeredParticipants,
    };
