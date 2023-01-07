import 'package:daily_practices_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('all practices are in the list and one is active',
        (tester) async {
      await tester.pumpWidget(
        const DailyPracticeApp(),
      );

      // Wait till app is loaded
      await Future.delayed(const Duration(seconds: 3), () {});

      // Verify that the list can be found
      final listFinder = find.byType(Scrollable);
      expect(listFinder, findsOneWidget);

      // Verify that the first practice can be found
      expect(find.text('Sleep eight hours'), findsOneWidget);

      // Scroll to the bottom
      await tester.fling(
        listFinder,
        const Offset(0, -500),
        10000,
      );
      await tester.pumpAndSettle();

      // Verify that the last practice can be found
      expect(find.text('Deep breathing'), findsOneWidget);

      // Scroll back to the top
      await tester.fling(
        listFinder,
        const Offset(0, 500),
        10000,
      );
      await tester.pumpAndSettle();

      final activeItemFinder = find.byKey(const ValueKey('ActivePractice'));

      // Find the active practice
      await tester.scrollUntilVisible(
        activeItemFinder,
        500.0,
        scrollable: listFinder,
      );

      expect(activeItemFinder, findsOneWidget);
    });
  });
}
