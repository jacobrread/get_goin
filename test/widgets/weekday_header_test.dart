import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_goin/widgets/weekday_header.dart';

void main() {
  group('WeekdayHeader', () {
    testWidgets('renders all weekday abbreviations', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WeekdayHeader()));
      for (final abbr in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']) {
        expect(find.text(abbr), findsOneWidget);
      }
    });
  });
}
