import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:local_notification_api/src/local_notification_api.dart';
import 'package:notification_api/notification_api.dart' as api;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AndroidLocalNotificationApi implements LocalNotificationApi {
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  final String notificationsTitle;
  final Future<String> localTimeZone;

  AndroidLocalNotificationApi(this.notificationsPlugin, this.notificationsTitle)
      : localTimeZone = FlutterNativeTimezone.getLocalTimezone() {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    notificationsPlugin.initialize(
      initializationSettings,
    );
    _requestPermission();

    configureLocalTimeZone();
  }

  @override
  Future<bool> get isNotificationPending async {
    final pendingNotifications = await getPendingNotifications();

    return pendingNotifications
        .where((notification) => notification?.title == notificationsTitle)
        .isNotEmpty;
  }

  Future<bool?> _requestPermission() async {
    return notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  Future<List<api.PendingNotifications?>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await notificationsPlugin.pendingNotificationRequests();

    return pendingNotificationRequests
        .map((notification) => api.PendingNotifications(
              id: notification.id,
              title: notification.title,
              body: notification.body,
            ))
        .toList();
  }

  @override
  Future<void> setNotification(
    String message,
    DateTime notificationDate,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'daily_practices_channel', 'daily_practices_channel',
            channelDescription:
                'daily practices give a notification once a day',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    final timeTZ = tz.TZDateTime.from(
        notificationDate, tz.getLocation(await localTimeZone));

    return await notificationsPlugin.zonedSchedule(
      UniqueKey().hashCode,
      notificationsTitle,
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

  @override
  configureLocalTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await localTimeZone));
  }
}
