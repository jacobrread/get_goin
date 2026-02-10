import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:get_goin/goals_screen.dart';
import 'package:get_goin/models/goal.dart';
import 'package:get_goin/repositories/hive_goal_repository.dart';

class MockGoalRepository extends Mock implements HiveGoalRepository {
  @override
  Future<List<Goal>> getGoals() => (super.noSuchMethod(Invocation.method(#getGoals, []), returnValue: Future.value(<Goal>[])) as Future<List<Goal>>);

  @override
  Future<void> addGoal(Goal goal) => (super.noSuchMethod(Invocation.method(#addGoal, [goal]), returnValue: Future.value()) as Future<void>);

  @override
  Future<void> updateGoal(Goal goal) => (super.noSuchMethod(Invocation.method(#updateGoal, [goal]), returnValue: Future.value()) as Future<void>);

  @override
  Future<void> deleteGoal(String id) => (super.noSuchMethod(Invocation.method(#deleteGoal, [id]), returnValue: Future.value()) as Future<void>);
}

void main() {
  group('GoalsScreen', () {
    late MockGoalRepository mockRepository;

    setUp(() {
      mockRepository = MockGoalRepository();
    });

    testWidgets('opens create goal dialog when FAB is tapped', (WidgetTester tester) async {
      when(mockRepository.getGoals()).thenAnswer((_) async => []);
      await tester.pumpWidget(
        MaterialApp(
          home: GoalsScreen(repository: mockRepository),
        ),
      );
      await tester.pumpAndSettle();
      // Tap the FloatingActionButton
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      // The dialog should appear (look for a widget from create_goal_dialog.dart)
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('shows empty state when no goals', (WidgetTester tester) async {
      when(mockRepository.getGoals()).thenAnswer((_) async => []);
      await tester.pumpWidget(
        MaterialApp(
          home: GoalsScreen(repository: mockRepository),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No goals yet'), findsOneWidget);
      expect(find.text('Tap + to create your first goal'), findsOneWidget);
    });

    testWidgets('displays a list of goals', (WidgetTester tester) async {
      final goals = [
        Goal(
          id: '1',
          name: 'Read Books',
          target: 10,
          unit: 'books',
          valuePerUnit: 5.0,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 12, 31),
        ),
        Goal(
          id: '2',
          name: 'Run',
          target: 50,
          unit: 'km',
          valuePerUnit: 2.0,
          startDate: DateTime(2024, 2, 1),
          endDate: DateTime(2024, 12, 31),
        ),
      ];
      when(mockRepository.getGoals()).thenAnswer((_) async => goals);
      await tester.pumpWidget(
        MaterialApp(
          home: GoalsScreen(repository: mockRepository),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Read Books'), findsOneWidget);
      expect(find.text('Run'), findsOneWidget);
      expect(find.text('10 books • \$5.00 per books'), findsOneWidget);
      expect(find.text('50 km • \$2.00 per km'), findsOneWidget);
    });
  });
}
