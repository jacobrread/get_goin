import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'main_navigation.dart';
import 'models/goal.dart';
import 'models/calendar_entry.dart';
import 'models/streak.dart';
import 'models/monetary.dart';
import 'repositories/hive_goal_repository.dart';
import 'repositories/hive_calendar_repository.dart';
import 'repositories/streak_repository.dart';
import 'repositories/monetary_repository.dart';
import 'services/penalty_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(CalendarEntryAdapter());
  Hive.registerAdapter(StreakAdapter());
  Hive.registerAdapter(MonetaryAdapter());

  // Open boxes
  final goalBox = await Hive.openBox<Goal>('goals');
  final calendarBox = await Hive.openBox<CalendarEntry>('calendar');
  final streakBox = await Hive.openBox<Streak>('streaks');
  final monetaryBox = await Hive.openBox<Monetary>('monetary');

  // Create repositories
  final goalRepo = HiveGoalRepository(goalBox);
  final calendarRepo = HiveCalendarRepository(calendarBox);
  final streakRepo = HiveStreakRepository(streakBox);
  final monetaryRepo = HiveMonetaryRepository(monetaryBox);

  // Run penalty logic on startup
  final penaltyService = PenaltyService(
    calendarRepo: calendarRepo,
    streakRepo: streakRepo,
    monetaryRepo: monetaryRepo,
    goalRepo: goalRepo,
  );
  await penaltyService.applyPenalties(DateTime.now());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Goin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const MainNavigation(),
    );
  }
}
