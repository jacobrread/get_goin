import '../models/calendar_entry.dart';
import '../models/streak.dart';
import '../models/monetary.dart';
import '../repositories/calendar_repository.dart';
import '../repositories/streak_repository.dart';
import '../repositories/monetary_repository.dart';
import '../repositories/goal_repository.dart';

/// Service to handle penalty logic for missed days.
class PenaltyService {
  final CalendarRepository calendarRepo;
  final StreakRepository streakRepo;
  final MonetaryRepository monetaryRepo;
  final GoalRepository goalRepo;

  PenaltyService({
    required this.calendarRepo,
    required this.streakRepo,
    required this.monetaryRepo,
    required this.goalRepo,
  });

  /// Applies penalties for missed days for all goals.
  Future<void> applyPenalties(DateTime today) async {
    final goals = await goalRepo.getGoals();
    for (final goal in goals) {
      final entries = await calendarRepo.getEntriesByGoal(goal.id);
      final streak = await streakRepo.getStreak(goal.id) ?? Streak(goalId: goal.id, currentStreak: 0, maxStreak: 0, lastSuccessDate: today);
      int consecutiveMisses = 0;
      DateTime start = goal.startDate;
      DateTime end = today;
      for (DateTime d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
        final entry = entries.firstWhere(
          (e) => e.date.year == d.year && e.date.month == d.month && e.date.day == d.day,
          orElse: () => CalendarEntry(id: '', goalId: goal.id, date: d, progress: 0, success: false),
        );
        if (!entry.success) {
          consecutiveMisses++;
          // Deduct penalty for this missed day
          await _deductPenalty(goal.penaltyAmount);
          if (consecutiveMisses >= 2) {
            // Reset streak after two consecutive misses
            await streakRepo.resetStreak(goal.id);
            break;
          }
        } else {
          consecutiveMisses = 0;
        }
      }
    }
  }

  Future<void> _deductPenalty(double amount) async {
    final monetary = await monetaryRepo.getMonetary();
    final newTotal = monetary.total - amount;
    await monetaryRepo.updateMonetary(Monetary(total: newTotal < 0 ? 0 : newTotal, spent: monetary.spent));
  }
}
