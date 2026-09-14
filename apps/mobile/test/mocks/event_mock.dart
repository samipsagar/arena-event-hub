import 'package:sports/features/event/data/dto/event_dto.dart';
import 'package:sports/features/event/domain/entity/event.dart';
import 'package:sports/features/event/domain/entity/event_form_data.dart';
import 'package:sports/features/event/domain/entity/event_status.dart';
import 'package:sports/features/event/domain/entity/sport.dart';

/// The same event at every layer it exists in, for the whole suite.
///
/// [json], [dto] and [entity] describe one event, so a test can hand [json]
/// to a fake backend and assert the result equals [entity].
class EventMock {
  const EventMock._();

  static const _description = 'Casual game, all levels welcome.';
  static const _venue = 'Riverside Pitch 2';

  /// One event exactly as the backend's `EventResponse` sends it.
  static Map<String, dynamic> json({
    String id = 'evt-1',
    String title = 'Sunday Five-a-side',
    String sport = 'FOOTBALL',
    String status = 'SCHEDULED',
    int participantLimit = 10,
    int registeredParticipants = 4,
  }) => {
    'id': id,
    'title': title,
    'description': _description,
    'sport': sport,
    'status': status,
    'venue': _venue,
    'startsAt': '2026-03-14T18:30:00.000Z',
    'endsAt': '2026-03-14T20:00:00.000Z',
    'durationMinutes': 90,
    'participantLimit': participantLimit,
    'registeredParticipants': registeredParticipants,
    'spotsRemaining': participantLimit - registeredParticipants,
    'createdAt': '2026-02-01T09:00:00.000Z',
    'updatedAt': '2026-02-01T09:00:00.000Z',
  };

  /// Built through [EventDto.fromJson] rather than the constructor, so the
  /// fixture and the wire format cannot drift apart.
  static EventDto dto({
    String id = 'evt-1',
    String title = 'Sunday Five-a-side',
    String sport = 'FOOTBALL',
    String status = 'SCHEDULED',
  }) => EventDto.fromJson(
    json(id: id, title: title, sport: sport, status: status),
  );

  /// What [json] becomes once `EventMapper` is done with it.
  static Event entity({
    String id = 'evt-1',
    String title = 'Sunday Five-a-side',
    Sport sport = Sport.football,
    EventStatus status = EventStatus.scheduled,
    int participantLimit = 10,
    int registeredParticipants = 4,
  }) => Event(
    id: id,
    title: title,
    description: _description,
    sport: sport,
    status: status,
    venue: _venue,
    // The same instants [json] puts on the wire, as `EventMapper` hands them
    // up: local, so this holds in any timezone.
    startsAt: DateTime.utc(2026, 3, 14, 18, 30).toLocal(),
    endsAt: DateTime.utc(2026, 3, 14, 20, 0).toLocal(),
    durationMinutes: 90,
    participantLimit: participantLimit,
    registeredParticipants: registeredParticipants,
    spotsRemaining: participantLimit - registeredParticipants,
  );

  /// [id] is the field under test in most uses — null means "create".
  static EventFormData formData({
    String? id,
    String title = 'Sunday Five-a-side',
    Sport sport = Sport.football,
    EventStatus status = EventStatus.scheduled,
  }) => EventFormData(
    id: id,
    title: title,
    description: _description,
    sport: sport,
    status: status,
    venue: _venue,
    startsAt: DateTime.utc(2026, 3, 14, 18, 30),
    durationMinutes: 90,
    participantLimit: 10,
    registeredParticipants: 4,
  );
}
