import 'package:hive/hive.dart';
import '../models/goal.dart';
import 'goal_repository.dart';

class HiveGoalRepository implements GoalRepository {
  final Box<Goal> _box;

  HiveGoalRepository(this._box);

  @override
  Future<List<Goal>> getGoals() async => _box.values.toList();

  @override
  Future<void> addGoal(Goal goal) async => await _box.put(goal.id, goal);

  @override
  Future<void> updateGoal(Goal goal) async => await _box.put(goal.id, goal);

  @override
  Future<void> deleteGoal(String id) async => await _box.delete(id);
}
