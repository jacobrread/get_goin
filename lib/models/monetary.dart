import 'package:hive/hive.dart';

part 'monetary.g.dart';

/// Model for monetary state.
@HiveType(typeId: 3)
class Monetary {
  @HiveField(0)
  final double total;
  @HiveField(1)
  final double spent;

  /// Creates a Monetary object.
  Monetary({
    required this.total,
    required this.spent,
  });

  /// Returns the available amount (total minus spent).
  double get available => total - spent;
}