import '../models/calendar_entry.dart';
import 'package:hive/hive.dart';

/// Abstract repository for calendar entries.
/// Provides methods to manage calendar data.
abstract class CalendarRepository {
  /// Returns all calendar entries.
  Future<List<CalendarEntry>> getEntries();
  /// Adds a new calendar entry.
  Future<void> addEntry(CalendarEntry entry);
  /// Updates an existing calendar entry.
  Future<void> updateEntry(CalendarEntry entry);
  /// Deletes a calendar entry by its id.
  Future<void> deleteEntry(String id);
  /// Returns entries for a specific goal.
  Future<List<CalendarEntry>> getEntriesByGoal(String goalId);
  /// Returns the entry for a goal on a specific date.
  Future<CalendarEntry?> getEntryByDate(String goalId, DateTime date);
}

/// Hive implementation of CalendarRepository.
class HiveCalendarRepository implements CalendarRepository {
  final Box<CalendarEntry> _box;

  /// Creates a HiveCalendarRepository with the given Hive box.
  HiveCalendarRepository(this._box);

  @override
  /// Returns all calendar entries from Hive.
  Future<List<CalendarEntry>> getEntries() async => _box.values.toList();

  @override
  /// Adds a new calendar entry to Hive.
  Future<void> addEntry(CalendarEntry entry) async => _box.put(entry.id, entry);

  @override
  /// Updates an existing calendar entry in Hive.
  Future<void> updateEntry(CalendarEntry entry) async => _box.put(entry.id, entry);

  @override
  /// Deletes a calendar entry by id from Hive.
  Future<void> deleteEntry(String id) async => _box.delete(id);

  @override
    /// Returns entries for a specific goal from Hive.
    Future<List<CalendarEntry>> getEntriesByGoal(String goalId) async =>
      _box.values.where((e) => e.goalId == goalId).toList();

  @override
  /// Returns the entry for a goal on a specific date from Hive.
  Future<CalendarEntry?> getEntryByDate(String goalId, DateTime date) async {
    try {
      return _box.values.firstWhere(
        (e) => e.goalId == goalId && e.date.year == date.year && e.date.month == date.month && e.date.day == date.day,
      );
    } catch (_) {
      return null;
    }
  }
}
