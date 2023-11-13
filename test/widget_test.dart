// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:find_falcone/ui/screens/home_screen.dart';
import 'package:find_falcone/ui/screens/search_result_srceen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Search Result Widget Tests Fail Case', () {
    testWidgets('Renders SearchResult with status failed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SearchResult(
          status: 'failed',
        ),
      ));
      expect(find.text('Search Failure!'), findsOneWidget);
    });
  });

  group('Search Result Widget Tests Success Case', () {
    testWidgets('Renders SearchResult with status success',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SearchResult(
          status: 'success',
          planetName: 'Donlon',
        ),
      ));
      expect(find.text('Search Success!'), findsOneWidget);
    });
  });
}
