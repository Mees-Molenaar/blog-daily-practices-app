import 'package:daily_practices_app/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:daily_practices_app/theme/theme.dart';

class DailyPracticeApp extends StatelessWidget {
  const DailyPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterPracticesTheme.light,
      darkTheme: FlutterPracticesTheme.dark,
      home: const PracticesPage(),
    );
  }
}
