import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_goin/calendar_screen.dart';
import 'package:get_goin/widgets/month_navigation_bar.dart';
import 'package:get_goin/widgets/update_progress_button.dart';

String _monthName(int month) {
  const months = [
    '',
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return months[month];
}

void main() {
  group('CalendarScreen', () {
    testWidgets('shows current month by default', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarScreen()));
      final now = DateTime.now();
      expect(find.textContaining('${_monthName(now.month)} ${now.year}'), findsOneWidget);
      expect(find.byIcon(Icons.today), findsNothing);
    });

    testWidgets('left/right arrows navigate months and show button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarScreen()));
      final monthNavBarFinder = find.byType(MonthNavigationBar);
      expect(monthNavBarFinder, findsOneWidget);
      // Print all IconButton widgets and their icons for diagnosis
      final iconButtons = tester.widgetList<IconButton>(find.byType(IconButton));
      for (final btn in iconButtons) {
        tester.printToConsole('IconButton: icon=${btn.icon.runtimeType}, tooltip=${btn.tooltip}');
      }
      // Tap right arrow (next month)
      final rightArrowFinder = find.byIcon(Icons.arrow_forward);
      tester.printToConsole('find.byIcon(Icons.arrow_forward): ${tester.widgetList<IconButton>(rightArrowFinder).length} found');
      // Fallback: find by tooltip
      final rightArrowTooltipFinder = find.byTooltip('Next Month');
      tester.printToConsole('find.byTooltip("Next Month"): ${tester.widgetList<IconButton>(rightArrowTooltipFinder).length} found');
      expect(rightArrowFinder, findsOneWidget);
      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      // Print displayed month after navigation
      final monthTextFinder = find.descendant(of: monthNavBarFinder, matching: find.byType(Text));
      final monthText = tester.widget<Text>(monthTextFinder.at(0)).data;
      tester.printToConsole('Displayed month after right arrow tap: $monthText');
      // Assert displayed month is not current month
      final now = DateTime.now();
      final currentMonthText = '${_monthName(now.month)} ${now.year}';
      expect(monthText, isNot(equals(currentMonthText)));
      // Now expect 'Go to Current Month' button
      expect(find.byIcon(Icons.today), findsOneWidget);
      // Tap left arrow (previous month)
      final iconButtonsAfter = tester.widgetList<IconButton>(find.byType(IconButton));
      for (final btn in iconButtonsAfter) {
        tester.printToConsole('After tap: IconButton: icon=${btn.icon.runtimeType}, tooltip=${btn.tooltip}');
      }
      final leftArrowFinder = find.byIcon(Icons.arrow_back);
      tester.printToConsole('find.byIcon(Icons.arrow_back): ${tester.widgetList<IconButton>(leftArrowFinder).length} found');
      // Fallback: find by tooltip
      final leftArrowTooltipFinder = find.byTooltip('Previous Month');
      tester.printToConsole('find.byTooltip("Previous Month"): ${tester.widgetList<IconButton>(leftArrowTooltipFinder).length} found');
      expect(leftArrowFinder, findsOneWidget);
      await tester.tap(leftArrowFinder);
      await tester.pumpAndSettle();
      // Print displayed month after navigation
      final monthTextAfter = tester.widget<Text>(monthTextFinder.at(0)).data;
      tester.printToConsole('Displayed month after left arrow tap: $monthTextAfter');
      // Assert displayed month IS current month
      expect(monthTextAfter, equals(currentMonthText));
      // Now expect 'Go to Current Month' button is NOT present
      expect(find.byIcon(Icons.today), findsNothing);
    });

    testWidgets('Go to Current Month button animates to current month and hides', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarScreen()));
      final monthNavBarFinder = find.byType(MonthNavigationBar);
      final iconButtons = find.descendant(of: monthNavBarFinder, matching: find.byType(IconButton));
      // Assert initial month is current
      final now = DateTime.now();
      expect(find.textContaining('${_monthName(now.month)} ${now.year}'), findsOneWidget);
      // Go to next month (away from current month)
      await tester.tap(iconButtons.at(1));
      await tester.pumpAndSettle();
      // Assert displayed month is NOT current
      expect(find.textContaining('${_monthName(now.month)} ${now.year}'), findsNothing);
      // Print widget tree for diagnosis
      tester.printToConsole('Widget tree after navigation: ${tester.allWidgets.map((w) => w.runtimeType.toString()).join(',')}');
      // Now the 'Go to Current Month' button should be present
      final goToCurrentMonthIconFinder = find.byIcon(Icons.today);
      expect(goToCurrentMonthIconFinder, findsOneWidget);
      // Tap Go to Current Month
      await tester.tap(goToCurrentMonthIconFinder);
      await tester.pumpAndSettle();
      // Assert returned to current month
      expect(find.textContaining('${_monthName(now.month)} ${now.year}'), findsOneWidget);
      expect(find.byIcon(Icons.today), findsNothing);
    });

    testWidgets('swipe left/right navigates months', (WidgetTester tester) async {
      // Start from January 2026
      final jan2026 = DateTime(2026, 1);
      await tester.pumpWidget(MaterialApp(home: CalendarScreen(displayedMonth: jan2026)));
      final monthNavBarFinder = find.byType(MonthNavigationBar);
      final monthTextFinder = find.descendant(of: monthNavBarFinder, matching: find.byType(Text));
      // Swipe left (should not advance month)
      await tester.drag(find.byType(CalendarScreen), const Offset(-300, 0));
      await tester.pumpAndSettle();
      final monthTextAfterLeft = tester.widget<Text>(monthTextFinder.at(0)).data;
      tester.printToConsole('Displayed month after swipe left: $monthTextAfterLeft');
      expect(monthTextAfterLeft, equals('January 2026'));
      expect(find.byIcon(Icons.today), findsOneWidget);
      // Swipe right (should not go before January)
      await tester.drag(find.byType(CalendarScreen), const Offset(300, 0));
      await tester.pumpAndSettle();
      final monthTextAfterRight = tester.widget<Text>(monthTextFinder.at(0)).data;
      tester.printToConsole('Displayed month after swipe right: $monthTextAfterRight');
      expect(monthTextAfterRight, equals('January 2026'));
      expect(find.byIcon(Icons.today), findsOneWidget);
    });

    testWidgets('renders calendar and update progress button for current month', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: CalendarScreen(),
      ));
      expect(find.byType(CalendarScreen), findsOneWidget);
      expect(find.byType(UpdateProgressButton), findsOneWidget);
    });

    testWidgets('hides update progress button for non-current month', (WidgetTester tester) async {
      final displayedMonth = DateTime(DateTime.now().year, DateTime.now().month - 1);
      await tester.pumpWidget(MaterialApp(
        home: CalendarScreen(displayedMonth: displayedMonth),
      ));
      expect(find.byType(UpdateProgressButton), findsNothing);
    });
  });
}
