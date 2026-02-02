import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:get_goin/models/goal.dart';
import 'package:get_goin/repositories/hive_goal_repository.dart';

void main() {
  late Box<Goal> mockBox;
  late HiveGoalRepository repository;

  setUpAll(() {
    // Initialize Hive once for all tests
    Hive.init('test_hive');
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GoalAdapter());
    }
  });

  tearDownAll(() async {
    await Hive.close();
    await Hive.deleteFromDisk();
  });

  group('HiveGoalRepository', () {
    setUp(() async {
      mockBox = await Hive.openBox<Goal>('test_goals');
      repository = HiveGoalRepository(mockBox);
    });

    tearDown(() async {
      await mockBox.clear();
      await mockBox.close();
    });

    test('addGoal adds a goal to the box', () async {
      final goal = Goal(
        id: '1',
        name: 'Run 100km',
        target: 100,
        unit: 'km',
        valuePerUnit: 1.0,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
      );

      await repository.addGoal(goal);

      expect(mockBox.get('1'), isNotNull);
      expect(mockBox.get('1')?.name, 'Run 100km');
    });

    test('getGoals returns all goals', () async {
      final goal1 = Goal(
        id: '1',
        name: 'Goal 1',
        target: 100,
        unit: 'km',
        valuePerUnit: 1.0,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
      );

      final goal2 = Goal(
        id: '2',
        name: 'Goal 2',
        target: 200,
        unit: 'steps',
        valuePerUnit: 0.5,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
      );

      await repository.addGoal(goal1);
      await repository.addGoal(goal2);

      final goals = await repository.getGoals();

      expect(goals.length, 2);
      expect(goals.any((g) => g.id == '1'), true);
      expect(goals.any((g) => g.id == '2'), true);
    });

    test('updateGoal updates an existing goal', () async {
      final goal = Goal(
        id: '1',
        name: 'Original Name',
        target: 100,
        unit: 'km',
        valuePerUnit: 1.0,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
      );

      await repository.addGoal(goal);

      final updatedGoal = Goal(
        id: '1',
        name: 'Updated Name',
        target: 150,
        unit: 'km',
        valuePerUnit: 1.0,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
      );

      await repository.updateGoal(updatedGoal);

      final result = mockBox.get('1');
      expect(result?.name, 'Updated Name');
      expect(result?.target, 150);
    });

    test('deleteGoal removes a goal from the box', () async {
      final goal = Goal(
        id: '1',
        name: 'To Delete',
        target: 100,
        unit: 'km',
        valuePerUnit: 1.0,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
      );

      await repository.addGoal(goal);
      expect(mockBox.get('1'), isNotNull);

      await repository.deleteGoal('1');
      expect(mockBox.get('1'), isNull);
    });

    test('getGoals returns empty list when no goals exist', () async {
      final goals = await repository.getGoals();
      expect(goals, isEmpty);
    });
  });
}
