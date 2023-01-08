import 'package:daily_practices_app/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_practices_app/app/app.dart';

void main() {
  group('DailyPracticeApp', () {
    testWidgets('renders PracticesPage', (tester) async {
      await tester.pumpWidget(
        const DailyPracticeApp(),
      );

      expect(find.byType(PracticesPage), findsOneWidget);
    });

    group('PracticesPage', () {
      testWidgets('renders PracticesView', (tester) async {
        await tester.pumpWidget(
          const DailyPracticeApp(),
        );

        expect(find.byType(PracticesView), findsOneWidget);
      });
    });

    group('PracticesView', () {
      Widget buildSubject() {
        return const MaterialApp(home: PracticesView());
      }

      testWidgets('renders AppBar with title text', (tester) async {
        await tester.pumpWidget(buildSubject());

        expect(find.byType(AppBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('Daily Practices'),
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders all listitems', (tester) async {
        await tester.pumpWidget(buildSubject());

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
      });

      testWidgets('one practice should be active', (tester) async {
        await tester.pumpWidget(buildSubject());

        final listFinder = find.byType(Scrollable);
        expect(listFinder, findsOneWidget);

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
  });
}
