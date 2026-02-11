import 'package:flutter_test/flutter_test.dart';
import 'package:get_goin/services/penalty_service.dart';
import 'package:get_goin/models/goal.dart';
import 'package:get_goin/models/calendar_entry.dart';
import 'package:get_goin/models/streak.dart';
import 'package:get_goin/models/monetary.dart';
import 'package:get_goin/repositories/goal_repository.dart';
import 'package:get_goin/repositories/calendar_repository.dart';
import 'package:get_goin/repositories/streak_repository.dart';
import 'package:get_goin/repositories/monetary_repository.dart';
import 'package:logger/logger.dart';


class MockGoalRepository implements GoalRepository {
  final logger = Logger();
  List<Goal> goals;
  MockGoalRepository(this.goals);
  @override
  Future<List<Goal>> getGoals() async => goals;
  @override
  Future<void> addGoal(Goal goal) async {}
  @override
  Future<void> updateGoal(Goal goal) async {}
  @override
  Future<void> deleteGoal(String id) async {}
  @override
  Future<Goal?> getGoalById(String id) async {
    try {
      return goals.firstWhere((g) => g.id == id);
    } catch (e, stack) {
      logger.e('Error in getGoalById', error: e, stackTrace: stack);
      return null;
    }
  }
}

class MockCalendarRepository implements CalendarRepository {
  final logger = Logger();
  Map<String, List<CalendarEntry>> entriesByGoal;
  MockCalendarRepository(this.entriesByGoal);

  @override
  Future<List<CalendarEntry>> getEntries() async => entriesByGoal.values.expand((e) => e).toList();
  @override
  Future<void> addEntry(CalendarEntry entry) async {}
  @override
  Future<void> updateEntry(CalendarEntry entry) async {}
  @override
  Future<void> deleteEntry(String id) async {}
  @override
  Future<List<CalendarEntry>> getEntriesByGoal(String goalId) async => entriesByGoal[goalId] ?? [];
  @override
  Future<CalendarEntry?> getEntryByDate(String goalId, DateTime date) async {
    try {
      return (entriesByGoal[goalId] ?? []).firstWhere(
        (e) => e.date.year == date.year && e.date.month == date.month && e.date.day == date.day,
      );
    } catch (e, stack) {
      logger.e('Error in getEntryByDate', error: e, stackTrace: stack);
      return null;
    }
  }
}

class MockStreakRepository implements StreakRepository {
  Map<String, Streak> streaks;
  MockStreakRepository(this.streaks);
  @override
  Future<Streak?> getStreak(String goalId) async => streaks[goalId];
  @override
  Future<void> updateStreak(Streak streak) async => streaks[streak.goalId] = streak;
  @override
  Future<void> resetStreak(String goalId) async {
    final s = streaks[goalId];
    if (s != null) {
      streaks[goalId] = Streak(goalId: s.goalId, currentStreak: 0, maxStreak: s.maxStreak, lastSuccessDate: DateTime.now());
    }
  }
}

class MockMonetaryRepository implements MonetaryRepository {
  Monetary monetary;
  MockMonetaryRepository(this.monetary);
  @override
  Future<Monetary> getMonetary() async => monetary;
  @override
  Future<void> updateMonetary(Monetary m) async => monetary = m;
  @override
  Future<void> spend(double amount) async {
    if (monetary.available >= amount) {
      monetary = Monetary(total: monetary.total, spent: monetary.spent + amount);
    }
  }
}

void main() {
  test('PenaltyService applies penalty and resets streak after two misses', () async {
    final goal = Goal(
      id: 'g1',
      name: 'Pushups',
      target: 10,
      unit: 'reps',
      valuePerUnit: 0.1,
      startDate: DateTime(2026, 2, 1),
      endDate: DateTime(2026, 2, 5),
      penaltyAmount: 1.0,
    );
    final entries = [
      CalendarEntry(id: 'e1', goalId: 'g1', date: DateTime(2026, 2, 1), progress: 10, success: true),
      CalendarEntry(id: 'e2', goalId: 'g1', date: DateTime(2026, 2, 2), progress: 0, success: false),
      CalendarEntry(id: 'e3', goalId: 'g1', date: DateTime(2026, 2, 3), progress: 0, success: false),
      CalendarEntry(id: 'e4', goalId: 'g1', date: DateTime(2026, 2, 4), progress: 10, success: true),
      CalendarEntry(id: 'e5', goalId: 'g1', date: DateTime(2026, 2, 5), progress: 10, success: true),
    ];
    final streak = Streak(goalId: 'g1', currentStreak: 2, maxStreak: 2, lastSuccessDate: DateTime(2026, 2, 1));
    final monetary = Monetary(total: 10.0, spent: 0.0);
    final goalRepo = MockGoalRepository([goal]);
    final calendarRepo = MockCalendarRepository({'g1': entries});
    final streakRepo = MockStreakRepository({'g1': streak});
    final monetaryRepo = MockMonetaryRepository(monetary);
    final penaltyService = PenaltyService(
      calendarRepo: calendarRepo,
      streakRepo: streakRepo,
      monetaryRepo: monetaryRepo,
      goalRepo: goalRepo,
    );
    await penaltyService.applyPenalties(DateTime(2026, 2, 5));
    expect(monetaryRepo.monetary.total, lessThan(10.0));
    expect(streakRepo.streaks['g1']!.currentStreak, 0);
  });
}
