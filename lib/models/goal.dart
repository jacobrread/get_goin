import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int target;
  @HiveField(3)
  final String unit;
  @HiveField(4)
  final double valuePerUnit;
  @HiveField(5)
  final DateTime startDate;
  @HiveField(6)
  final DateTime endDate;

  Goal({
    required this.id,
    required this.name,
    required this.target,
    required this.unit,
    required this.valuePerUnit,
    required this.startDate,
    required this.endDate,
  });
}
