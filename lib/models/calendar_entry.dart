import 'package:hive/hive.dart';

part 'calendar_entry.g.dart';

@HiveType(typeId: 1)
class CalendarEntry {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String goalId;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final int progress;
  @HiveField(4)
  final bool success;

  CalendarEntry({
    required this.id,
    required this.goalId,
    required this.date,
    required this.progress,
    required this.success,
  });
}
