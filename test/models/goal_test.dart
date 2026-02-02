import 'package:flutter_test/flutter_test.dart';
import 'package:get_goin/models/goal.dart';

void main() {
  group('Goal', () {
    test('creates a goal with all required fields', () {
      final startDate = DateTime(2026, 1, 1);
      final endDate = DateTime(2026, 12, 31);
      
      final goal = Goal(
        id: '1',
        name: 'Run 100km',
        target: 100,
        unit: 'km',
        valuePerUnit: 1.0,
        startDate: startDate,
        endDate: endDate,
      );

      expect(goal.id, '1');
      expect(goal.name, 'Run 100km');
      expect(goal.target, 100);
      expect(goal.unit, 'km');
      expect(goal.valuePerUnit, 1.0);
      expect(goal.startDate, startDate);
      expect(goal.endDate, endDate);
    });

    test('handles fractional valuePerUnit', () {
      final goal = Goal(
        id: '2',
        name: 'Walk 10000 steps',
        target: 10000,
        unit: 'steps',
        valuePerUnit: 0.5,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
      );

      expect(goal.valuePerUnit, 0.5);
    });
  });
}
