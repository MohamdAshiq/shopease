import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin_web/main.dart';

void main() {
  testWidgets('Admin app renders login screen with branding and form', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    expect(find.text('Admin Sign In'), findsOneWidget);
    expect(find.text('SHOPEASE ADMIN'), findsOneWidget);
    expect(find.text('Fill Demo Admin Credentials'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In to Dashboard'), findsOneWidget);
  });

  testWidgets('Tapping Fill Demo Admin Credentials populates form fields', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    // Tap quick demo fill
    final demoFillButton = find.text('Fill Demo Admin Credentials');
    expect(demoFillButton, findsOneWidget);
    await tester.tap(demoFillButton);
    await tester.pumpAndSettle();

    // Verify fields populated
    expect(find.text('admin@shopease.com'), findsOneWidget);
    expect(find.text('admin123'), findsOneWidget);
  });
}
