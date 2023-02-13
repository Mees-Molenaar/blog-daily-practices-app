import 'package:daily_practices_app/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:daily_practices_app/theme/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification_api/local_notification_api.dart';
import 'dart:developer';

void setNewNotification() async {
  final notificationsApi =
      LocalNotificationApi(FlutterLocalNotificationsPlugin());

  final activeNotifications = await notificationsApi.getActiveNotifications();

  if (activeNotifications.isEmpty) {
    final today = DateTime.now();

    // TODO: Deze tijd kan uiteindelijk ook uit preferences gehaald worden!
    final notificationTime = DateTime(
      today.year,
      today.month,
      today.day,
      today.hour,
      today.minute + 1,
      0,
    );

    const String timeZoneName = 'Europe/Amsterdam';

    notificationsApi.setNotification(
        'Your new daily practice is ready!', notificationTime, timeZoneName);
    log('Notification is set!');
  } else {
    log('Notification for next day is already set!');
  }
}

class DailyPracticeApp extends StatelessWidget {
  const DailyPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    setNewNotification();

    return MaterialApp(
      theme: FlutterPracticesTheme.light,
      darkTheme: FlutterPracticesTheme.dark,
      home: const PracticesPage(),
    );
  }
}
