import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disst_app/features/home/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays DisstApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    expect(find.text('DisstApp'), findsOneWidget);
    expect(find.text('Barka da zuwa DisstApp'), findsOneWidget);
  });
}
