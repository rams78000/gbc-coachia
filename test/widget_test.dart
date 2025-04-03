import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gbc_coachia/main.dart';
import 'package:gbc_coachia/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GbcCoachIaApp());

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
