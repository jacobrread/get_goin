import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_goin/widgets/calendar_cell.dart';

void main() {
  group('CalendarCell', () {
    testWidgets('renders day and highlights current day', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CalendarCell(
          day: 9,
          displayMonth: 2,
          displayYear: 2026,
          opacity: 1.0,
          cellColor: Colors.green,
          isCurrentDay: true,
        ),
      ));
      expect(find.text('9'), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('renders day with correct color and opacity', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CalendarCell(
          day: 15,
          displayMonth: 2,
          displayYear: 2026,
          opacity: 0.4,
          cellColor: Colors.grey,
          isCurrentDay: false,
        ),
      ));
      expect(find.text('15'), findsOneWidget);
      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, closeTo(0.4, 0.01));
    });
  });
}
