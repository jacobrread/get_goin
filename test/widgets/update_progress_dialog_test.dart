import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_goin/widgets/update_progress_dialog.dart';
import 'package:get_goin/models/goal.dart';

void main() {
  group('UpdateProgressDialog', () {
    testWidgets('shows fields for each goal and saves progress', (WidgetTester tester) async {
      final goals = [
        Goal(
          id: '1',
          name: 'Push-ups',
          target: 10,
          unit: 'reps',
          valuePerUnit: 0.1,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          penaltyAmount: 1.0,
        ),
        Goal(
          id: '2',
          name: 'Running',
          target: 5,
          unit: 'km',
          valuePerUnit: 0.5,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          penaltyAmount: 2.0,
        ),
      ];
      Map<String, int>? saved;
      await tester.pumpWidget(MaterialApp(
        home: UpdateProgressDialog(
          goals: goals,
          onSave: (progress) {
            saved = progress;
          },
        ),
      ));
      expect(find.text('Push-ups'), findsOneWidget);
      expect(find.text('Running'), findsOneWidget);
      await tester.enterText(find.widgetWithText(TextFormField, 'Push-ups'), '15');
      await tester.enterText(find.widgetWithText(TextFormField, 'Running'), '3');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(saved, isNotNull);
      expect(saved!['1'], 15);
      expect(saved!['2'], 3);
    });
  });
}
