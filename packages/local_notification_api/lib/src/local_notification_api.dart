import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_api/notification_api.dart';

import 'android_local_notification_api.dart';
import 'ios_local_notification_api.dart';

abstract class LocalNotificationApi extends INotificationsApi {
  factory LocalNotificationApi(String platform, String notificationTitle,
      FlutterLocalNotificationsPlugin notificationsPlugin) {
    switch (platform) {
      case 'android':
        return AndroidLocalNotificationApi(
            notificationsPlugin, notificationTitle);
      case 'iOS':
        return IosLocalNotificationApi(notificationsPlugin, notificationTitle);
      default:
        throw UnsupportedError(
            'No NotificationApi implemented for this platform.');
    }
  }

  Future<void> configureLocalTimeZone();
}
