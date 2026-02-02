import '../models/calendar_entry.dart';

abstract class CalendarRepository {
  Future<List<CalendarEntry>> getEntries();
  Future<void> addEntry(CalendarEntry entry);
  Future<void> updateEntry(CalendarEntry entry);
  Future<void> deleteEntry(String id);
}
