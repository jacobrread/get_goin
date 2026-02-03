import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:get_goin/goals_screen.dart';
import 'package:get_goin/models/goal.dart';
import 'package:get_goin/repositories/hive_goal_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

void main() {
  late Box<Goal> goalBox;
  late String testBoxName;

  setUpAll(() async {
    // Initialize HiveFlutter for widget tests (prevents hangs)
    TestWidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GoalAdapter());
    }

    // Mock path_provider for widget tests
    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getApplicationDocumentsDirectory':
            return '/tmp/app_docs';
          case 'getTemporaryDirectory':
            return '/tmp/temp';
          case 'getApplicationSupportDirectory':
            return '/tmp/app_support';
          case 'getLibraryDirectory':
            return '/tmp/library';
          case 'getDownloadsDirectory':
            return '/tmp/downloads';
          default:
            return '/tmp';
        }
      },
    );
  });

  setUp(() async {
    // Use unique box name for each test
    testBoxName = 'goals_test_${DateTime.now().millisecondsSinceEpoch}';
    goalBox = await Hive.openBox<Goal>(testBoxName);
  });

  tearDown(() async {
    await goalBox.clear();
    await goalBox.close();
  });

  tearDownAll(() async {
    await tearDownTestHive();
  });

  Widget createGoalsScreen([HiveGoalRepository? repo]) {
    return MaterialApp(
      home: GoalsScreen(repository: repo),
    );
  }

  testWidgets('shows empty state when no goals exist', (WidgetTester tester) async {
    final repo = HiveGoalRepository(goalBox);
    await tester.pumpWidget(createGoalsScreen(repo));
    await tester.pumpAndSettle();

    expect(find.text('No goals yet'), findsOneWidget);
    expect(find.text('Tap + to create your first goal'), findsOneWidget);
    expect(find.byIcon(Icons.flag_outlined), findsOneWidget);
  });

  // testWidgets('displays goals in a list', (WidgetTester tester) async {
  //   // Add test goals
  //   final goal1 = Goal(
  //     id: '1',
  //     name: 'Push-ups',
  //     target: 50,
  //     unit: 'reps',
  //     valuePerUnit: 0.10,
  //     startDate: DateTime(2026, 1, 1),
  //     endDate: DateTime(2026, 2, 1),
  //   );

  //   final goal2 = Goal(
  //     id: '2',
  //     name: 'Running',
  //     target: 5,
  //     unit: 'km',
  //     valuePerUnit: 2.00,
  //     startDate: DateTime(2026, 1, 1),
  //     endDate: DateTime(2026, 2, 1),
  //   );

  //   await goalBox.put(goal1.id, goal1);
  //   await goalBox.put(goal2.id, goal2);

  //   final repo = HiveGoalRepository(goalBox);
  //   debugPrint('Pumping GoalsScreen widget...');
  //   await tester.pumpWidget(createGoalsScreen(repo));
  //   debugPrint('First pump done.');
  //   await tester.pump();
  //   debugPrint('Second pump done.');
  //   await tester.pump(const Duration(seconds: 1));
  //   debugPrint('Third pump (1s) done.');

  //   expect(find.text('Push-ups'), findsOneWidget);
  //   expect(find.text('Running'), findsOneWidget);
  //   expect(find.text('50 reps • \$0.10 per reps'), findsOneWidget);
  //   expect(find.text('5 km • \$2.00 per km'), findsOneWidget);
  // });

  testWidgets('shows delete confirmation dialog', (WidgetTester tester) async {
    final goal = Goal(
      id: '1',
      name: 'Test Goal',
      target: 10,
      unit: 'reps',
      valuePerUnit: 0.50,
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 2, 1),
    );

    await goalBox.put(goal.id, goal);

    final repo = HiveGoalRepository(goalBox);
    await tester.pumpWidget(createGoalsScreen(repo));
    await tester.pumpAndSettle();

    // Open the popup menu
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();

    // Tap delete option
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Verify confirmation dialog appears
    expect(find.text('Delete Goal'), findsOneWidget);
    expect(find.text('Are you sure you want to delete "Test Goal"?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsAtLeast(1));
  });

  testWidgets('deletes goal when confirmed', (WidgetTester tester) async {
    final goal = Goal(
      id: '1',
      name: 'Test Goal',
      target: 10,
      unit: 'reps',
      valuePerUnit: 0.50,
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 2, 1),
    );

    await goalBox.put(goal.id, goal);

    final repo = HiveGoalRepository(goalBox);
    await tester.pumpWidget(createGoalsScreen(repo));
    await tester.pumpAndSettle();

    expect(find.text('Test Goal'), findsOneWidget);

    // Open the popup menu
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();

    // Tap delete option
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Confirm deletion
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    // Verify goal is deleted
    expect(find.text('Test Goal'), findsNothing);
    expect(find.text('No goals yet'), findsOneWidget);
  });

  testWidgets('cancels deletion when cancel is pressed', (WidgetTester tester) async {
    final goal = Goal(
      id: '1',
      name: 'Test Goal',
      target: 10,
      unit: 'reps',
      valuePerUnit: 0.50,
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 2, 1),
    );

    await goalBox.put(goal.id, goal);

    final repo = HiveGoalRepository(goalBox);
    await tester.pumpWidget(createGoalsScreen(repo));
    await tester.pumpAndSettle();

    expect(find.text('Test Goal'), findsOneWidget);

    // Open the popup menu
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();

    // Tap delete option
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Cancel deletion
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Verify goal still exists
    expect(find.text('Test Goal'), findsOneWidget);
  });

  testWidgets('shows create goal dialog when FAB is tapped', (WidgetTester tester) async {
    final repo = HiveGoalRepository(goalBox);
    await tester.pumpWidget(createGoalsScreen(repo));
    await tester.pumpAndSettle();

    // Tap the FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.text('Create Goal'), findsOneWidget);
    expect(find.text('Goal Name'), findsOneWidget);
    expect(find.text('Daily Target'), findsOneWidget);
    expect(find.text('Unit'), findsOneWidget);
    expect(find.text('Value per Unit (\$)'), findsOneWidget);
    expect(find.text('Duration'), findsOneWidget);
  });

  testWidgets('has correct app bar title', (WidgetTester tester) async {
    final repo = HiveGoalRepository(goalBox);
    await tester.pumpWidget(createGoalsScreen(repo));
    await tester.pumpAndSettle();

    expect(find.text('My Goals'), findsOneWidget);
  });
}
