import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_core_frontend/features/auth/presentation/pages/splash_page.dart';

void main() {
  testWidgets('Splash page renders foundation copy', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashPage(),
      ),
    );

    expect(find.text('Platform Core Frontend'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
