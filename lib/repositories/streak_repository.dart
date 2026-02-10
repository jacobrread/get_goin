import '../models/streak.dart';
import 'package:hive/hive.dart';

/// Abstract repository for streaks.
/// Provides methods to manage streak data.
abstract class StreakRepository {
  /// Returns the streak for a specific goal.
  Future<Streak?> getStreak(String goalId);
  /// Updates the streak for a specific goal.
  Future<void> updateStreak(Streak streak);
  /// Resets the streak for a specific goal.
  Future<void> resetStreak(String goalId);
}

/// Hive implementation of StreakRepository.
class HiveStreakRepository implements StreakRepository {
  final Box<Streak> _box;

  /// Creates a HiveStreakRepository with the given Hive box.
  HiveStreakRepository(this._box);

  @override
  /// Returns the streak for a specific goal from Hive.
  Future<Streak?> getStreak(String goalId) async => _box.get(goalId);

  @override
  /// Updates the streak for a specific goal in Hive.
  Future<void> updateStreak(Streak streak) async => _box.put(streak.goalId, streak);

  @override
  /// Resets the streak for a specific goal in Hive.
  Future<void> resetStreak(String goalId) async {
    final streak = _box.get(goalId);
    if (streak != null) {
      final reset = Streak(
        goalId: streak.goalId,
        currentStreak: 0,
        maxStreak: streak.maxStreak,
        lastSuccessDate: DateTime.now(),
      );
      await _box.put(goalId, reset);
    }
  }
}
