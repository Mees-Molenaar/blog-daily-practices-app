import 'package:flutter_test/flutter_test.dart';

import 'package:notification_api/notification_api.dart';

class TestNotificationsApi extends INotificationsApi {
  TestNotificationsApi() : super();

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('NotificationAPi', () {
    test('can be constructud', () {
      expect(TestNotificationsApi.new, returnsNormally);
    });
  });
}
