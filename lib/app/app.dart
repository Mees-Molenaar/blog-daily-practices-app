import 'package:daily_practices_app/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:daily_practices_app/theme/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification_api/local_notification_api.dart';
import 'dart:developer';

Future<void> setNewNotification(BuildContext context) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final notificationsApi = LocalNotificationApi(Theme.of(context).platform.name,
      'Daily Practices Testing', flutterLocalNotificationsPlugin);

  final isNotificationPending = await notificationsApi.isNotificationPending;

  if (!isNotificationPending) {
    final today = DateTime.now();

    // TODO: Deze tijd kan uiteindelijk ook uit preferences gehaald worden!
    // Voor nu om 7 uur sochtends
    final notificationTime = DateTime(
      today.year,
      today.month,
      today.day + 1,
      7,
      0,
      0,
    );

    await notificationsApi.setNotification(
        'Your new daily practice is ready!', notificationTime);
    log('Notification is set!');
  } else {
    log('Notification for next day is already set!');
  }
}

class DailyPracticeApp extends StatelessWidget {
  const DailyPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setNewNotification(context),
        builder: (context, AsyncSnapshot snapshot) {
          return MaterialApp(
            theme: FlutterPracticesTheme.light,
            darkTheme: FlutterPracticesTheme.dark,
            home: const PracticesPage(),
          );
        });
  }
}
