import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'goals_screen.dart';
import 'spending_screen.dart';
import 'friends_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CalendarScreen(),
    const GoalsScreen(),
    const SpendingScreen(),
    const FriendsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Spending',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'Friends',
          ),
        ],
      ),
    );
  }
}
