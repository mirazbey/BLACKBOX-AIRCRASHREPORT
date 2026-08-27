import 'package:flutter_test/flutter_test.dart';
import 'package:chasethecase/main.dart';

void main() {
  testWidgets('Black Box App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BlackBoxApp());
    expect(find.text('BLACK BOX'), findsOneWidget);
  });
}
