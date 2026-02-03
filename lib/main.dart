import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'main_navigation.dart';
import 'models/goal.dart';
import 'models/calendar_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(CalendarEntryAdapter());
  
  // Open boxes
  await Hive.openBox<Goal>('goals');
  await Hive.openBox<CalendarEntry>('calendar');
  
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
