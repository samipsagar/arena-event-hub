import 'package:sports/features/event/data/event_repository.dart';
import 'package:sports/features/event/data/mapper/event_mapper.dart';
import 'package:sports/features/event/domain/entity/event.dart';
import 'package:sports/features/event/domain/entity/event_form_data.dart';
import 'package:sports/features/event/domain/entity/events_page.dart';
import 'package:sports/features/event/domain/event_query.dart';

/// The only events API the presentation layer sees: entities and [EventQuery],
/// never DTOs or endpoints.
class EventService {
  const EventService(this._repository, this._mapper);

  final EventRepository _repository;
  final EventMapper _mapper;

  /// Loads one page of events matching [query], throwing an `AppException`
  /// the caller is expected to turn into something a person can read.
  Future<EventsPage> loadEvents({
    EventQuery query = const EventQuery(),
    String? cursor,
    int limit = EventRepository.defaultLimit,
  }) async {
    final page = await _repository.getAll(
      query: query,
      cursor: cursor,
      limit: limit,
    );

    return EventsPage(
      events: _mapper.toDomainList(page.data),
      nextCursor: page.nextCursor,
      hasNext: page.hasNext,
    );
  }

  Future<Event> loadEvent(String eventId) async {
    final response = await _repository.getById(id: eventId);
    return _mapper.toDomain(response);
  }

  Future<void> delete(String eventId) => _repository.delete(eventId);

  /// Creates a new event when [formData] has no id, or updates the one it if it

  Future<Event> save(EventFormData formData) async {
    final id = formData.id;

    if (id == null) {
      return _mapper.toDomain(
        await _repository.create(_mapper.toRequestDto(formData)),
      );
    }

    var event = _mapper.toDomain(
      await _repository.update(id, _mapper.toRequestDto(formData)),
    );

    return event;
  }
}
