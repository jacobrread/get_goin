import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_goin/widgets/month_navigation_bar.dart';

void main() {
  group('MonthNavigationBar', () {
    testWidgets('renders month and year, responds to button presses', (WidgetTester tester) async {
      bool prevPressed = false;
      bool nextPressed = false;
      await tester.pumpWidget(MaterialApp(
        home: MonthNavigationBar(
          monthName: 'February',
          year: 2026,
          onPrevious: () => prevPressed = true,
          onNext: () => nextPressed = true,
        ),
      ));
      expect(find.text('February 2026'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      expect(prevPressed, isTrue);
      await tester.tap(find.byIcon(Icons.arrow_forward));
      expect(nextPressed, isTrue);
    });
  });
}
