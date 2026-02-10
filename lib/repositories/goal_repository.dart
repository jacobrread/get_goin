import '../models/goal.dart';
import 'package:hive/hive.dart';

/// Abstract repository for goals.
/// Provides methods to manage goal data.
abstract class GoalRepository {
  /// Returns all goals.
  Future<List<Goal>> getGoals();
  /// Adds a new goal.
  Future<void> addGoal(Goal goal);
  /// Updates an existing goal.
  Future<void> updateGoal(Goal goal);
  /// Deletes a goal by its id.
  Future<void> deleteGoal(String id);
  /// Returns a goal by its id.
  Future<Goal?> getGoalById(String id);
}

/// Hive implementation of GoalRepository.
class HiveGoalRepository implements GoalRepository {
  final Box<Goal> _box;

  /// Creates a HiveGoalRepository with the given Hive box.
  HiveGoalRepository(this._box);

  @override
  /// Returns all goals from Hive.
  Future<List<Goal>> getGoals() async => _box.values.toList();

  @override
  /// Adds a new goal to Hive.
  Future<void> addGoal(Goal goal) async => _box.put(goal.id, goal);

  @override
  /// Updates an existing goal in Hive.
  Future<void> updateGoal(Goal goal) async => _box.put(goal.id, goal);

  @override
  /// Deletes a goal by id from Hive.
  Future<void> deleteGoal(String id) async => _box.delete(id);

  @override
  /// Returns a goal by id from Hive.
  Future<Goal?> getGoalById(String id) async => _box.get(id);
}
