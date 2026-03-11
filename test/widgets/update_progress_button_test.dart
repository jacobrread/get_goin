import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_goin/widgets/update_progress_button.dart';
import 'package:get_goin/models/goal.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';

class MockBox<T> extends Mock implements Box<T> {
  @override
  Iterable<T> get values => <T>[];
}

@GenerateMocks([Box])

void main() {
  group('UpdateProgressButton', () {
    testWidgets('renders button and opens dialog', (WidgetTester tester) async {
      final mockGoalsBox = MockBox<Goal>();
      final mockCalendarBox = MockBox<dynamic>();
      bool progressUpdated = false;
      await tester.pumpWidget(
        Provider<Box<Goal>>.value(
          value: mockGoalsBox,
          child: Provider<Box<dynamic>>.value(
            value: mockCalendarBox,
            child: MaterialApp(
              home: Scaffold(
                body: UpdateProgressButton(
                  onProgressUpdated: () {
                    progressUpdated = true;
                  },
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(ElevatedButton), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      // Dialog should open, but since no goals are present, a SnackBar is shown
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
