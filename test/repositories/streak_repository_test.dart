import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:get_goin/models/streak.dart';
import 'package:get_goin/repositories/streak_repository.dart';
import 'dart:io';

void main() {
  Hive.registerAdapter(StreakAdapter());
  group('HiveStreakRepository', () {
    late Box<Streak> box;
    late HiveStreakRepository repo;
    late Directory testDir;

    setUp(() async {
      testDir = await Directory.systemTemp.createTemp('hive_test_streak');
      Hive.init(testDir.path);
      box = await Hive.openBox<Streak>('testStreakBox');
      await box.clear();
      repo = HiveStreakRepository(box);
    });

    tearDown(() async {
      await box.close();
      await testDir.delete(recursive: true);
    });

    test('getStreak returns null when not found', () async {
      final streak = await repo.getStreak('goal1');
      expect(streak, isNull);
    });

    test('updateStreak stores streak', () async {
      final s = Streak(goalId: 'goal1', currentStreak: 5, maxStreak: 10, lastSuccessDate: DateTime(2024, 1, 1));
      await repo.updateStreak(s);
      final result = await repo.getStreak('goal1');
      expect(result?.currentStreak, 5);
      expect(result?.maxStreak, 10);
      expect(result?.lastSuccessDate, DateTime(2024, 1, 1));
    });

    test('resetStreak resets streak', () async {
      final s = Streak(goalId: 'goal1', currentStreak: 5, maxStreak: 10, lastSuccessDate: DateTime(2024, 1, 1));
      await repo.updateStreak(s);
      await repo.resetStreak('goal1');
      final result = await repo.getStreak('goal1');
      expect(result?.currentStreak, 0);
      expect(result?.maxStreak, 10);
      expect(result?.lastSuccessDate.day, DateTime.now().day);
    });
  });
}
