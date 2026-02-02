import 'package:flutter_test/flutter_test.dart';
import 'package:get_goin/models/calendar_entry.dart';

void main() {
  group('CalendarEntry', () {
    test('creates a calendar entry with all required fields', () {
      final date = DateTime(2026, 2, 2);
      
      final entry = CalendarEntry(
        id: '1',
        goalId: 'goal-1',
        date: date,
        progress: 50,
        success: true,
      );

      expect(entry.id, '1');
      expect(entry.goalId, 'goal-1');
      expect(entry.date, date);
      expect(entry.progress, 50);
      expect(entry.success, true);
    });

    test('creates unsuccessful entry', () {
      final entry = CalendarEntry(
        id: '2',
        goalId: 'goal-1',
        date: DateTime(2026, 2, 1),
        progress: 0,
        success: false,
      );

      expect(entry.success, false);
      expect(entry.progress, 0);
    });

    test('handles partial progress', () {
      final entry = CalendarEntry(
        id: '3',
        goalId: 'goal-1',
        date: DateTime(2026, 2, 1),
        progress: 75,
        success: true,
      );

      expect(entry.progress, 75);
    });
  });
}
