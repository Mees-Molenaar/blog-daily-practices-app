import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_api/notification_api.dart' as api;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationApi implements api.INotificationsApi {
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  // Should add capability for web?!
  LocalNotificationApi(this.notificationsPlugin) {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    notificationsPlugin.initialize(
      initializationSettings,
    );

    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    _configureLocalTimeZone();
  }

  @override
  Future<List<api.ActiveNotification?>> getActiveNotifications() async {
    final activeNotifications = await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();

    return activeNotifications
            ?.map((notification) => api.ActiveNotification(
                  id: notification.id,
                  title: notification.title,
                  body: notification.body,
                  channelId: notification.channelId,
                  tag: notification.tag,
                ))
            .toList() ??
        [];
  }

  @override
  Future<void> setNotification(
    String message,
    DateTime notificationDate,
    String timeZoneName,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'daily_practices_channel', 'daily_practices_channel',
            channelDescription:
                'daily practices give a notification once a day',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    final timeTZ =
        tz.TZDateTime.from(notificationDate, tz.getLocation(timeZoneName));

    // TODO: ID can UUIDV4() worden
    return await notificationsPlugin.zonedSchedule(
      12456,
      'Daily Practices',
      message,
      timeTZ,
      const NotificationDetails(
        android: androidPlatformChannelSpecifics,
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Amsterdam'));
  }
}
