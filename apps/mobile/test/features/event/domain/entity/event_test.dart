import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/event_mock.dart';

void main() {
  group('isFull', () {
    test('is false while spots remain', () {
      final event = EventMock.entity(
        participantLimit: 10,
        registeredParticipants: 4,
      );

      expect(event.spotsRemaining, 6);
      expect(event.isFull, isFalse);
    });

    test('is true on the last spot being taken', () {
      final event = EventMock.entity(
        participantLimit: 10,
        registeredParticipants: 10,
      );

      expect(event.spotsRemaining, 0);
      expect(event.isFull, isTrue);
    });
  });
}
