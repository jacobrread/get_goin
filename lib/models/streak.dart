import 'package:hive/hive.dart';

part 'streak.g.dart';

/// Model for goal streaks.
@HiveType(typeId: 2)
class Streak {
  @HiveField(0)
  final String goalId;
  @HiveField(1)
  final int currentStreak;
  @HiveField(2)
  final int maxStreak;
  @HiveField(3)
  final DateTime lastSuccessDate;

  /// Creates a Streak object.
  Streak({
    required this.goalId,
    required this.currentStreak,
    required this.maxStreak,
    required this.lastSuccessDate,
  });
}
