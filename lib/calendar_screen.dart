import 'package:flutter/material.dart';
import 'package:get_goin/models/calendar_entry.dart';
import 'package:get_goin/models/goal.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'profile_screen.dart';
import 'widgets/month_navigation_bar.dart';
import 'widgets/weekday_header.dart';
import 'widgets/calendar_cell.dart';
import 'widgets/update_progress_button.dart';

class CalendarScreen extends StatefulWidget {
  final DateTime? displayedMonth;
  const CalendarScreen({super.key, this.displayedMonth});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with TickerProviderStateMixin {
    DateTime get _currentMonth => DateTime(DateTime.now().year, DateTime.now().month);
  late DateTime _displayedMonth;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _displayedMonth = widget.displayedMonth ?? DateTime.now();
    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month);
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_controller);
  }

  void _goToPreviousMonth() {
    _startSlideAnimation(1);
  }

  void _goToNextMonth() {
    _startSlideAnimation(-1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile & Stats',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! < 0) {
              _goToNextMonth();
            } else if (details.primaryVelocity! > 0) {
              _goToPreviousMonth();
            }
          }
        },
        child: Column(
          children: [
            StatsBar(),
            MonthNavigationBar(
              monthName: _monthName(_displayedMonth.month),
              year: _displayedMonth.year,
              onPrevious: _goToPreviousMonth,
              onNext: _goToNextMonth,
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FractionalTranslation(
                    translation: _slideAnimation.value,
                    child: child,
                  );
                },
                child: CalendarView(
                  key: ValueKey('${_displayedMonth.year}-${_displayedMonth.month}'),
                  displayedMonth: _displayedMonth,
                ),
              ),
            ),
            if (_displayedMonth.year == _currentMonth.year && _displayedMonth.month == _currentMonth.month)
              Provider<Box<Goal>>.value(
                value: Hive.box<Goal>('goals'),
                child: Provider<Box<CalendarEntry>>.value(
                  value: Hive.box<CalendarEntry>('calendar'),
                  child: UpdateProgressButton(
                    onProgressUpdated: () {
                      setState(() {});
                    },
                  ),
                ),
              ),
            if (_displayedMonth.year != _currentMonth.year || _displayedMonth.month != _currentMonth.month)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.today),
                  label: const Text('Go to Current Month'),
                  onPressed: _goToCurrentMonth,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _startSlideAnimation(int direction) {
    if (_controller.isAnimating) return;
    setState(() {
      if (direction == -1) {
        // Slide left (next month)
        _slideAnimation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(_controller);
        _displayedMonth = DateTime(
          _displayedMonth.month == 12 ? _displayedMonth.year + 1 : _displayedMonth.year,
          _displayedMonth.month == 12 ? 1 : _displayedMonth.month + 1,
        );
      } else {
        // Slide right (previous month)
        _slideAnimation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(_controller);
        _displayedMonth = DateTime(
          _displayedMonth.month == 1 ? _displayedMonth.year - 1 : _displayedMonth.year,
          _displayedMonth.month == 1 ? 12 : _displayedMonth.month - 1,
        );
      }
    });
    _controller.forward(from: 0).then((_) {
      setState(() {});
    });
  }

  String _monthName(int month) {
    const months = [
      '',
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  void _goToCurrentMonth() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    int direction;
    if (_displayedMonth.isBefore(currentMonth)) {
      direction = -1; // Slide left to future
    } else {
      direction = 1; // Slide right to past
    }
    setState(() {
      _slideAnimation = Tween<Offset>(
        begin: direction == -1 ? const Offset(1, 0) : const Offset(-1, 0),
        end: Offset.zero,
      ).animate(_controller);
      _displayedMonth = currentMonth;
    });
    _controller.forward(from: 0).then((_) {
      setState(() {});
    });
  }
}

// StatsBar widget (previously _StatsBar)
class StatsBar extends StatelessWidget {
  const StatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blueGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          StatItem(label: 'Streak', value: '0'),
          StatItem(label: 'Total Cash', value: '\$240.00'),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  const StatItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

// CalendarView widget (previously _CalendarView)
class CalendarView extends StatelessWidget {
  final DateTime? displayedMonth;
  const CalendarView({super.key, this.displayedMonth});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final year = displayedMonth?.year ?? now.year;
    final month = displayedMonth?.month ?? now.month;
    final isCurrentMonth = (displayedMonth?.year == now.year && displayedMonth?.month == now.month) || (displayedMonth == null);
    final today = isCurrentMonth ? now.day : -1;
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = firstDayOfMonth.weekday;
    final leadingEmpty = firstWeekday % 7;
    final prevMonth = month == 1 ? 12 : month - 1;
    final prevMonthYear = month == 1 ? year - 1 : year;
    final prevMonthDays = DateTime(prevMonthYear, prevMonth + 1, 0).day;
    final totalCells = leadingEmpty + daysInMonth;
    final rows = ((totalCells) / 7).ceil();
    final itemCount = rows * 7;

    List<Widget> cells = [];
    for (int i = 0; i < itemCount; i++) {
      int day;
      int displayMonth = month;
      int displayYear = year;
      double opacity = 1.0;
      Color cellColor;
      bool isCurrentDay = false;
      if (i < leadingEmpty) {
        day = prevMonthDays - (leadingEmpty - i - 1);
        displayMonth = prevMonth;
        displayYear = prevMonthYear;
        opacity = 0.4;
        cellColor = Colors.grey;
      } else if (i >= leadingEmpty + daysInMonth) {
        day = i - (leadingEmpty + daysInMonth) + 1;
        int nextMonthNumber = month + 1;
        int nextYear = year;
        while (nextMonthNumber > 12) {
          nextMonthNumber -= 12;
          nextYear += 1;
        }
        displayMonth = nextMonthNumber;
        displayYear = nextYear;
        opacity = 0.4;
        final displayed = DateTime(displayYear, displayMonth);
        final realNow = DateTime(now.year, now.month);
        if (displayed.isAfter(realNow)) {
          cellColor = const Color(0xFFBFC9D9);
        } else {
          cellColor = Colors.grey;
        }
      } else {
        day = i - leadingEmpty + 1;
        if (today != -1 && day > today) {
          cellColor = const Color(0xFFBFC9D9);
        } else {
          cellColor = Colors.green.shade200;
        }
        if (today != -1 && day == today) {
          isCurrentDay = true;
        }
      }
      final cellKey = ValueKey('calendar-cell-$displayYear-$displayMonth-$day');
      cells.add(
        CalendarCell(
          key: cellKey,
          day: day,
          displayMonth: displayMonth,
          displayYear: displayYear,
          opacity: opacity,
          cellColor: cellColor,
          isCurrentDay: isCurrentDay,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          WeekdayHeader(),
          SizedBox(height: 8),
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: cells,
            ),
          ),
        ],
      ),
    );
  }
}
