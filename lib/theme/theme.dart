import 'package:flutter/material.dart';

final ThemeData theme = ThemeData();

class FlutterPracticesTheme {
  static ThemeData get light {
    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: const Color(0xFF457b9d),
        secondary: const Color(0xFF457b9d),
      ),
    );
  }

  static ThemeData get dark {
    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: const Color(0xFF094f6f),
        secondary: const Color(0xFF000e2e),
      ),
    );
  }
}
