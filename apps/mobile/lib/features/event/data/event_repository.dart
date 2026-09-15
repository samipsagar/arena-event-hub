import 'package:sports/core/network/api_client.dart';
import 'package:sports/core/network/cursor_page.dart';
import 'package:sports/features/event/data/dto/event_dto.dart';
import 'package:sports/features/event/data/dto/event_request_dto.dart';
import 'package:sports/features/event/data/mapper/event_query_mapper.dart';
import 'package:sports/features/event/domain/event_query.dart';

class EventRepository {
  const EventRepository(this._client);

  static const _path = '/api/v1/events';

  static const defaultLimit = 10;

  final ApiClient _client;

  Future<CursorPage<EventDto>> getAll({
    EventQuery query = const EventQuery(),
    String? cursor,
    int limit = defaultLimit,
  }) => _client.get(
    _path,
    queryParameters: {
      ...query.toQueryParameters(),
      'limit': limit,
      'cursor': ?cursor,
    },
    parser: (data) => CursorPage.fromJson(data, EventDto.fromJson),
  );

  Future<EventDto> getById({required String id}) => _client.get(
    '$_path/$id',
    parser: (data) => EventDto.fromJson(data as Map<String, dynamic>),
  );

  Future<EventDto> create(EventRequestDto event) => _client.post(
    _path,
    data: event.toJson(),
    parser: (data) => EventDto.fromJson(data as Map<String, dynamic>),
  );

  Future<EventDto> update(String id, EventRequestDto event) => _client.put(
    '$_path/$id',
    data: event.toJson(),
    parser: (data) => EventDto.fromJson(data as Map<String, dynamic>),
  );

  Future<void> delete(String id) =>
      _client.delete('$_path/$id', parser: (data) {});
}
