import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:local_notification_api/local_notification_api.dart';
import 'package:notification_api/notification_api.dart' as api;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class IosLocalNotificationApi implements LocalNotificationApi {
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  final String notificationsTitle;
  final Future<String> localTimeZone;

  IosLocalNotificationApi(this.notificationsPlugin, this.notificationsTitle)
      : localTimeZone = FlutterNativeTimezone.getLocalTimezone() {
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsDarwin,
    );
    notificationsPlugin.initialize(
      initializationSettings,
    );

    configureLocalTimeZone();
  }

  @override
  Future<bool> get isNotificationPending async {
    final pendingNotifications = await getPendingNotifications();

    return pendingNotifications
        .where((notification) => notification?.title == notificationsTitle)
        .isNotEmpty;
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
    final timeTZ = tz.TZDateTime.from(
        notificationDate, tz.getLocation(await localTimeZone));

    return await notificationsPlugin.zonedSchedule(
      UniqueKey().hashCode,
      notificationsTitle,
      message,
      timeTZ,
      const NotificationDetails(),
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
