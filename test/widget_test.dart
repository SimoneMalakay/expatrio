import 'package:expatrio/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Onboarding screen renders welcome text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    expect(find.text('Welcome to Expatrio 🌍'), findsOneWidget);
    expect(find.text('Start My Quest'), findsOneWidget);
  });
}
