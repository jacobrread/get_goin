import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_goin/widgets/create_goal_dialog.dart';
import 'package:get_goin/models/goal.dart';

void main() {
  Widget createDialogWrapper({required Function(Goal) onSave}) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CreateGoalDialog(onSave: onSave),
              );
            },
            child: const Text('Show Dialog'),
          ),
        ),
      ),
    );
  }

  testWidgets('displays all form fields', (WidgetTester tester) async {
    await tester.pumpWidget(createDialogWrapper(onSave: (_) {}));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Create Goal'), findsOneWidget);
    expect(find.text('Goal Name'), findsOneWidget);
    expect(find.text('Daily Target'), findsOneWidget);
    expect(find.text('Unit'), findsOneWidget);
    expect(find.text('Value per Unit (\$)'), findsOneWidget);
    expect(find.text('Duration'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
  });

  testWidgets('validates goal name is required', (WidgetTester tester) async {
    await tester.pumpWidget(createDialogWrapper(onSave: (_) {}));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Try to submit without entering a name
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a goal name'), findsOneWidget);
  });

  testWidgets('validates daily target is required', (WidgetTester tester) async {
    await tester.pumpWidget(createDialogWrapper(onSave: (_) {}));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Enter name but not target
    await tester.enterText(find.widgetWithText(TextFormField, 'Goal Name'), 'Push-ups');

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a target'), findsOneWidget);
  });

  testWidgets('validates daily target is a valid number', (WidgetTester tester) async {
    await tester.pumpWidget(createDialogWrapper(onSave: (_) {}));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Goal Name'), 'Push-ups');
    await tester.enterText(find.widgetWithText(TextFormField, 'Daily Target'), '0');

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid number'), findsOneWidget);
  });

  testWidgets('validates unit is required', (WidgetTester tester) async {
    await tester.pumpWidget(createDialogWrapper(onSave: (_) {}));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Goal Name'), 'Push-ups');
    await tester.enterText(find.widgetWithText(TextFormField, 'Daily Target'), '50');

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a unit'), findsOneWidget);
  });

  testWidgets('validates value per unit is required', (WidgetTester tester) async {
    await tester.pumpWidget(createDialogWrapper(onSave: (_) {}));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Goal Name'), 'Push-ups');
    await tester.enterText(find.widgetWithText(TextFormField, 'Daily Target'), '50');
    await tester.enterText(find.widgetWithText(TextFormField, 'Unit'), 'reps');

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a value'), findsOneWidget);
  });

  testWidgets('validates value per unit is a valid amount', (WidgetTester tester) async {
    await tester.pumpWidget(createDialogWrapper(onSave: (_) {}));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Goal Name'), 'Push-ups');
    await tester.enterText(find.widgetWithText(TextFormField, 'Daily Target'), '50');
    await tester.enterText(find.widgetWithText(TextFormField, 'Unit'), 'reps');
    await tester.enterText(find.widgetWithText(TextFormField, 'Value per Unit (\$)'), '0');

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid amount'), findsOneWidget);
  });

  testWidgets('creates goal with valid data', (WidgetTester tester) async {
    Goal? savedGoal;

    await tester.pumpWidget(createDialogWrapper(
      onSave: (goal) {
        savedGoal = goal;
      },
    ));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Fill in all fields
    await tester.enterText(find.widgetWithText(TextFormField, 'Goal Name'), 'Push-ups');
    await tester.enterText(find.widgetWithText(TextFormField, 'Daily Target'), '50');
    await tester.enterText(find.widgetWithText(TextFormField, 'Unit'), 'reps');
    await tester.enterText(find.widgetWithText(TextFormField, 'Value per Unit (\$)'), '0.10');

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    // Verify goal was created
    expect(savedGoal, isNotNull);
    expect(savedGoal!.name, 'Push-ups');
    expect(savedGoal!.target, 50);
    expect(savedGoal!.unit, 'reps');
    expect(savedGoal!.valuePerUnit, 0.10);
  });

  testWidgets('cancels goal creation', (WidgetTester tester) async {
    Goal? savedGoal;

    await tester.pumpWidget(createDialogWrapper(
      onSave: (goal) {
        savedGoal = goal;
      },
    ));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Goal Name'), 'Push-ups');

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Verify goal was not created
    expect(savedGoal, isNull);
    expect(find.text('Create Goal'), findsNothing);
  });

  testWidgets('has default duration of 1 week', (WidgetTester tester) async {
    await tester.pumpWidget(createDialogWrapper(onSave: (_) {}));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('1 week'), findsOneWidget);
  });

  testWidgets('can change duration', (WidgetTester tester) async {
    await tester.pumpWidget(createDialogWrapper(onSave: (_) {}));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Tap the dropdown
    await tester.tap(find.text('1 week'));
    await tester.pumpAndSettle();

    // Select a different duration
    await tester.tap(find.text('1 month').last);
    await tester.pumpAndSettle();

    expect(find.text('1 month'), findsOneWidget);
  });

  testWidgets('goal has correct end date for 1 week duration', (WidgetTester tester) async {
    Goal? savedGoal;
    final now = DateTime.now();

    await tester.pumpWidget(createDialogWrapper(
      onSave: (goal) {
        savedGoal = goal;
      },
    ));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Goal Name'), 'Test');
    await tester.enterText(find.widgetWithText(TextFormField, 'Daily Target'), '10');
    await tester.enterText(find.widgetWithText(TextFormField, 'Unit'), 'reps');
    await tester.enterText(find.widgetWithText(TextFormField, 'Value per Unit (\$)'), '0.10');

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(savedGoal, isNotNull);
    final expectedEndDate = now.add(const Duration(days: 7));
    expect(savedGoal!.endDate.difference(expectedEndDate).inHours.abs(), lessThan(1));
  });

  testWidgets('allows decimal values with up to 2 decimal places', (WidgetTester tester) async {
    Goal? savedGoal;

    await tester.pumpWidget(createDialogWrapper(
      onSave: (goal) {
        savedGoal = goal;
      },
    ));
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Goal Name'), 'Running');
    await tester.enterText(find.widgetWithText(TextFormField, 'Daily Target'), '5');
    await tester.enterText(find.widgetWithText(TextFormField, 'Unit'), 'km');
    await tester.enterText(find.widgetWithText(TextFormField, 'Value per Unit (\$)'), '2.50');

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(savedGoal, isNotNull);
    expect(savedGoal!.valuePerUnit, 2.50);
  });
}
