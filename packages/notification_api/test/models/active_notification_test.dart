import 'package:flutter_test/flutter_test.dart';
import 'package:notification_api/src/models/active_notification.dart';

void main() {
  group('ActiveNotification', () {
    ActiveNotification createSubject({
      int id = 1,
      String? channelId = "test",
      String? title = "test",
      String? body = "test",
      String? tag = "test",
    }) {
      return ActiveNotification(
          id: id, channelId: channelId, body: body, tag: tag);
    }

    group('constructor', () {
      test('works correctly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });
    });

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals([
          1, // id
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            id: null,
            title: null,
            body: null,
            tag: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            id: 2,
            title: 'new title',
            body: 'new body',
            tag: 'test',
          ),
          equals(
            createSubject(
              id: 2,
              title: 'new title',
              body: 'new body',
              tag: 'test',
            ),
          ),
        );
      });
    });
  });
}
