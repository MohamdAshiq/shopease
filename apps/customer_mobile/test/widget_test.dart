import 'package:flutter_test/flutter_test.dart';
import 'package:customer_mobile/main.dart';

void main() {
  testWidgets('Customer app renders home screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CustomerApp());
    expect(find.text('ShopEase'), findsOneWidget);
    expect(find.text('Welcome to ShopEase'), findsOneWidget);
  });
}
