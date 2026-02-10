import '../models/monetary.dart';
import 'package:hive/hive.dart';

/// Abstract repository for monetary data.
/// Provides methods to manage monetary state.
abstract class MonetaryRepository {
  /// Returns the current monetary state.
  Future<Monetary> getMonetary();
  /// Updates the monetary state.
  Future<void> updateMonetary(Monetary monetary);
  /// Spends a given amount if available.
  Future<void> spend(double amount);
}

/// Hive implementation of MonetaryRepository.
class HiveMonetaryRepository implements MonetaryRepository {
  final Box<Monetary> _box;

  /// Creates a HiveMonetaryRepository with the given Hive box.
  HiveMonetaryRepository(this._box);

  @override
  /// Returns the current monetary state from Hive.
  Future<Monetary> getMonetary() async => _box.get('monetary') ?? Monetary(total: 0, spent: 0);

  @override
  /// Updates the monetary state in Hive.
  Future<void> updateMonetary(Monetary monetary) async => _box.put('monetary', monetary);

  @override
  /// Spends a given amount if available in Hive.
  Future<void> spend(double amount) async {
    final monetary = await getMonetary();
    final newSpent = monetary.spent + amount;
    if (newSpent <= monetary.total) {
      await updateMonetary(Monetary(total: monetary.total, spent: newSpent));
    }
  }
}
