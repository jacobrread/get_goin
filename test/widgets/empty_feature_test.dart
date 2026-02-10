import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_goin/widgets/empty_feature.dart';

void main() {
  group('EmptyFeature', () {
    testWidgets('renders icon and message', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: EmptyFeature(
          icon: Icons.person_outline,
          message: 'Test message',
        ),
      ));
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.text('Test message'), findsOneWidget);
    });
  });
}
