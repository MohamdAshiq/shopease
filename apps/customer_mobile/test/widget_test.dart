import 'package:flutter_test/flutter_test.dart';
import 'package:customer_mobile/main.dart';

void main() {
  testWidgets('Customer app renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CustomerApp());
    await tester.pump();
    expect(find.text('Popular Products'), findsOneWidget);
  });
}
