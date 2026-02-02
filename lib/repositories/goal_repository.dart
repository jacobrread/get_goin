import '../models/goal.dart';

abstract class GoalRepository {
  Future<List<Goal>> getGoals();
  Future<void> addGoal(Goal goal);
  Future<void> updateGoal(Goal goal);
  Future<void> deleteGoal(String id);
}
