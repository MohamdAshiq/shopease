import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopease_core/shopease_core.dart';

void main() {
  group('ResponsiveLayout', () {
    testWidgets('renders desktop widget when constraints width >= 1100', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: SizedBox(
              width: 1200,
              height: 800,
              child: ResponsiveLayout(
                mobile: Text('Mobile View'),
                tablet: Text('Tablet View'),
                desktop: Text('Desktop View'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Desktop View'), findsOneWidget);
      expect(find.text('Tablet View'), findsNothing);
      expect(find.text('Mobile View'), findsNothing);
    });

    testWidgets('renders tablet widget when constraints width is 800', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: SizedBox(
              width: 800,
              height: 800,
              child: ResponsiveLayout(
                mobile: Text('Mobile View'),
                tablet: Text('Tablet View'),
                desktop: Text('Desktop View'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tablet View'), findsOneWidget);
      expect(find.text('Desktop View'), findsNothing);
      expect(find.text('Mobile View'), findsNothing);
    });

    testWidgets('renders mobile widget when constraints width is 500', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: SizedBox(
              width: 500,
              height: 800,
              child: ResponsiveLayout(
                mobile: Text('Mobile View'),
                tablet: Text('Tablet View'),
                desktop: Text('Desktop View'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Mobile View'), findsOneWidget);
      expect(find.text('Tablet View'), findsNothing);
      expect(find.text('Desktop View'), findsNothing);
    });

    testWidgets(
      'falls back to desktop widget when tablet is null on tablet width',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(
              child: SizedBox(
                width: 900,
                height: 800,
                child: ResponsiveLayout(
                  mobile: Text('Mobile View'),
                  desktop: Text('Desktop Fallback'),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Desktop Fallback'), findsOneWidget);
        expect(find.text('Mobile View'), findsNothing);
      },
    );

    testWidgets('builder constructor provides correct ResponsiveScreenType', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 1280,
              height: 800,
              child: ResponsiveLayout.builder(
                builder: (context, constraints, screenType) {
                  return Text('Type: ${screenType.name}');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Type: desktop'), findsOneWidget);
    });
  });
}
