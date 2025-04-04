import 'package:flutter_test/flutter_test.dart';
import 'package:gbc_coachia/app.dart';

void main() {
  testWidgets('Basic app test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    
    expect(find.text('GBC CoachIA'), findsWidgets);
  });
}
