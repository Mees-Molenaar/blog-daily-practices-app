import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notification_api/local_notification_api.dart';
import 'package:local_notification_api/src/android_local_notification_api.dart';
import 'package:local_notification_api/src/ios_local_notification_api.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterLocalNotificationsApi extends Mock
    implements FlutterLocalNotificationsPlugin {
  @override
  Future<bool?> initialize(
    InitializationSettings initializationSettings, {
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
  }) async {
    return true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('LocalNotificationApi', () {
    final mockFlutterLocalNotifications = MockFlutterLocalNotificationsApi();

    test('construct for android', () {
      expect(
          LocalNotificationApi(TargetPlatform.android.name, 'Test',
              mockFlutterLocalNotifications),
          isA<AndroidLocalNotificationApi>());
    });

    test('constructs for iOS', () {
      expect(
          LocalNotificationApi(TargetPlatform.iOS.name, 'Test',
              MockFlutterLocalNotificationsApi()),
          isA<IosLocalNotificationApi>());
    });

    test('throws for Web', () {
      expect(
          () => LocalNotificationApi(
              'Web', 'Test', MockFlutterLocalNotificationsApi()),
          throwsA(isA<UnsupportedError>()));
    });
  });
}
