import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notification_api/src/android_local_notification_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  @override
  Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
    return [];
  }
}

class FakeInitializationSettings extends Fake
    implements InitializationSettings {}

class FakeNotificationDetails extends Fake implements NotificationDetails {}

void main() {
  group('LocalNotificationApi', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    final mockFlutterLocalNotificationsPlugin =
        MockFlutterLocalNotificationsApi();

    tz.initializeTimeZones();
    const timeZoneName = 'Europe/Amsterdam';
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    final notificationTime = tz.TZDateTime.now(tz.getLocation(timeZoneName));

    // Needed to mock the flutter_native_timezone plugin
    const MethodChannel channel = MethodChannel('flutter_native_timezone');
    handler(MethodCall methodCall) async {
      if (methodCall.method == 'getLocalTimezone') {
        return 'Europe/Amsterdam';
      }
      return 'Europe/Amsterdam';
    }

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, handler);

    AndroidLocalNotificationApi createSubject() {
      return AndroidLocalNotificationApi(
        mockFlutterLocalNotificationsPlugin,
        'Test',
      );
    }

    setUpAll(() {
      registerFallbackValue(FakeInitializationSettings());
      registerFallbackValue(notificationTime);
      registerFallbackValue(FakeNotificationDetails());

      when(() => mockFlutterLocalNotificationsPlugin.zonedSchedule(
            any(),
            any(),
            any(),
            any(),
            any(),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time,
          )).thenAnswer((_) async => true);
    });

    group('constructur', () {
      test('it should work correctly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('getPendingNotifications', () {
      test('it should call the platform specific getPendingNotifications',
          () async {
        final notificationApi = createSubject();
        await notificationApi.getPendingNotifications();

        verify(() => mockFlutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.pendingNotificationRequests());
      });
    });

    group('setNotification', () {
      test('it should set a notification', () async {
        final notificationApi = createSubject();

        await notificationApi.setNotification('Test', notificationTime);

        verify(() => mockFlutterLocalNotificationsPlugin.zonedSchedule(
              any(),
              any(),
              any(),
              any(),
              any(),
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              matchDateTimeComponents: DateTimeComponents.time,
            )).called(1);
      });
    });
  });
}
