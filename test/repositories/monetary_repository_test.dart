import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:get_goin/models/monetary.dart';
import 'package:get_goin/repositories/monetary_repository.dart';
import 'dart:io';

void main() {
  Hive.registerAdapter(MonetaryAdapter());
  group('HiveMonetaryRepository', () {
    late Box<Monetary> box;
    late HiveMonetaryRepository repo;
    late Directory testDir;

    setUp(() async {
      testDir = await Directory.systemTemp.createTemp('hive_test_monetary');
      Hive.init(testDir.path);
      box = await Hive.openBox<Monetary>('testMonetaryBox');
      await box.clear();
      repo = HiveMonetaryRepository(box);
    });

    tearDown(() async {
      await box.close();
      await testDir.delete(recursive: true);
    });

    test('getMonetary returns default when empty', () async {
      final monetary = await repo.getMonetary();
      expect(monetary.total, 0);
      expect(monetary.spent, 0);
    });

    test('updateMonetary updates value', () async {
      final m = Monetary(total: 100, spent: 10);
      await repo.updateMonetary(m);
      final result = await repo.getMonetary();
      expect(result.total, 100);
      expect(result.spent, 10);
    });

    test('spend updates spent if available', () async {
      await repo.updateMonetary(Monetary(total: 50, spent: 10));
      await repo.spend(20);
      final result = await repo.getMonetary();
      expect(result.spent, 30);
      await repo.spend(30); // Should not exceed total
      expect((await repo.getMonetary()).spent, 30);
    });
  });
}
