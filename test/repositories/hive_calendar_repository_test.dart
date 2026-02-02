import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:get_goin/models/calendar_entry.dart';
import 'package:get_goin/repositories/hive_calendar_repository.dart';

void main() {
  late Box<CalendarEntry> mockBox;
  late HiveCalendarRepository repository;

  setUpAll(() {
    // Initialize Hive once for all tests
    Hive.init('test_hive');
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CalendarEntryAdapter());
    }
  });

  tearDownAll(() async {
    await Hive.close();
    await Hive.deleteFromDisk();
  });

  group('HiveCalendarRepository', () {
    setUp(() async {
      mockBox = await Hive.openBox<CalendarEntry>('test_calendar');
      repository = HiveCalendarRepository(mockBox);
    });

    tearDown(() async {
      await mockBox.clear();
      await mockBox.close();
    });

    test('addEntry adds a calendar entry to the box', () async {
      final entry = CalendarEntry(
        id: '1',
        goalId: 'goal-1',
        date: DateTime(2026, 2, 2),
        progress: 50,
        success: true,
      );

      await repository.addEntry(entry);

      expect(mockBox.get('1'), isNotNull);
      expect(mockBox.get('1')?.goalId, 'goal-1');
      expect(mockBox.get('1')?.progress, 50);
    });

    test('getEntries returns all calendar entries', () async {
      final entry1 = CalendarEntry(
        id: '1',
        goalId: 'goal-1',
        date: DateTime(2026, 2, 1),
        progress: 50,
        success: true,
      );

      final entry2 = CalendarEntry(
        id: '2',
        goalId: 'goal-2',
        date: DateTime(2026, 2, 2),
        progress: 75,
        success: true,
      );

      await repository.addEntry(entry1);
      await repository.addEntry(entry2);

      final entries = await repository.getEntries();

      expect(entries.length, 2);
      expect(entries.any((e) => e.id == '1'), true);
      expect(entries.any((e) => e.id == '2'), true);
    });

    test('updateEntry updates an existing calendar entry', () async {
      final entry = CalendarEntry(
        id: '1',
        goalId: 'goal-1',
        date: DateTime(2026, 2, 1),
        progress: 50,
        success: false,
      );

      await repository.addEntry(entry);

      final updatedEntry = CalendarEntry(
        id: '1',
        goalId: 'goal-1',
        date: DateTime(2026, 2, 1),
        progress: 100,
        success: true,
      );

      await repository.updateEntry(updatedEntry);

      final result = mockBox.get('1');
      expect(result?.progress, 100);
      expect(result?.success, true);
    });

    test('deleteEntry removes a calendar entry from the box', () async {
      final entry = CalendarEntry(
        id: '1',
        goalId: 'goal-1',
        date: DateTime(2026, 2, 1),
        progress: 50,
        success: true,
      );

      await repository.addEntry(entry);
      expect(mockBox.get('1'), isNotNull);

      await repository.deleteEntry('1');
      expect(mockBox.get('1'), isNull);
    });

    test('getEntries returns empty list when no entries exist', () async {
      final entries = await repository.getEntries();
      expect(entries, isEmpty);
    });

    test('handles multiple entries for same goal', () async {
      final entry1 = CalendarEntry(
        id: '1',
        goalId: 'goal-1',
        date: DateTime(2026, 2, 1),
        progress: 50,
        success: true,
      );

      final entry2 = CalendarEntry(
        id: '2',
        goalId: 'goal-1',
        date: DateTime(2026, 2, 2),
        progress: 75,
        success: true,
      );

      await repository.addEntry(entry1);
      await repository.addEntry(entry2);

      final entries = await repository.getEntries();
      final goalEntries = entries.where((e) => e.goalId == 'goal-1').toList();

      expect(goalEntries.length, 2);
    });

    test('handles unsuccessful entry', () async {
      final entry = CalendarEntry(
        id: '1',
        goalId: 'goal-1',
        date: DateTime(2026, 2, 1),
        progress: 0,
        success: false,
      );

      await repository.addEntry(entry);

      final result = mockBox.get('1');
      expect(result?.success, false);
      expect(result?.progress, 0);
    });
  });
}
