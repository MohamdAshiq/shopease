import 'package:flutter_test/flutter_test.dart';
import 'package:customer_mobile/main.dart';

void main() {
  testWidgets('Customer app renders splash screen then navigates to home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CustomerApp());
    await tester.pump();

    // Verify splash screen branding
    expect(find.text('ShopEase'), findsOneWidget);
    expect(find.text('Smart Shopping, Delivered Ease'), findsOneWidget);

    // Settle splash timer and transition
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify transition to home screen
    expect(find.text('Popular Products'), findsOneWidget);
  });
}
