import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notification_api/local_notification_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class FakeInitializationSettings extends Fake
    implements InitializationSettings {}

class FakeNotificationDetails extends Fake implements NotificationDetails {}

void main() {
  group('LocalNotificationApi', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    final mockFlutterLocalNotificationsPlugin =
        MockFlutterLocalNotificationsPlugin();

    tz.initializeTimeZones();
    const timeZoneName = 'Europe/Amsterdam';
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    final notificationTime = tz.TZDateTime.now(tz.getLocation(timeZoneName));

    LocalNotificationApi createSubject() {
      return LocalNotificationApi(mockFlutterLocalNotificationsPlugin);
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
          )).thenAnswer((_) async => {});

      when(() => mockFlutterLocalNotificationsPlugin.initialize(any()))
          .thenAnswer((_) => Future.value(true));
    });

    group('constructur', () {
      test('it should work correctly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('getActiveNotifications', () {
      test('it should call the platform specific getActiveNotifications',
          () async {
        final notificationApi = createSubject();
        notificationApi.getActiveNotifications();

        verify(() => mockFlutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.getActiveNotifications());
      });
    });

    group('setNotification', () {
      test('it should set a notification', () {
        final notificationApi = createSubject();

        notificationApi.setNotification('Test', notificationTime, timeZoneName);

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
