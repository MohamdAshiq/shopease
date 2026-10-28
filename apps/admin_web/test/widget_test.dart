import 'package:flutter_test/flutter_test.dart';
import 'package:admin_web/main.dart';

void main() {
  testWidgets('Admin app renders dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AdminApp());
    expect(find.text('ShopEase Admin Portal'), findsOneWidget);
    expect(find.text('Admin Dashboard'), findsOneWidget);
  });
}
