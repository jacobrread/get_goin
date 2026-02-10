import 'package:hive/hive.dart';
import '../models/calendar_entry.dart';
import 'calendar_repository.dart';

class HiveCalendarRepository implements CalendarRepository {
  final Box<CalendarEntry> _box;

  HiveCalendarRepository(this._box);

  @override
  Future<List<CalendarEntry>> getEntries() async => _box.values.toList();

  @override
  Future<void> addEntry(CalendarEntry entry) async => await _box.put(entry.id, entry);

  @override
  Future<void> updateEntry(CalendarEntry entry) async => await _box.put(entry.id, entry);

  @override
  Future<void> deleteEntry(String id) async => await _box.delete(id);

  @override
  Future<List<CalendarEntry>> getEntriesByGoal(String goalId) async =>
      _box.values.where((entry) => entry.goalId == goalId).toList();

  @override
  Future<CalendarEntry?> getEntryByDate(String goalId, DateTime date) async {
    try {
      return _box.values.firstWhere(
        (entry) => entry.goalId == goalId &&
                   entry.date.year == date.year &&
                   entry.date.month == date.month &&
                   entry.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }
}
