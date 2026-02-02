import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  final DateTime? displayedMonth;
  const CalendarScreen({super.key, this.displayedMonth});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = widget.displayedMonth ?? DateTime.now();
    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month);
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.month == 1 ? _displayedMonth.year - 1 : _displayedMonth.year,
        _displayedMonth.month == 1 ? 12 : _displayedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.month == 12 ? _displayedMonth.year + 1 : _displayedMonth.year,
        _displayedMonth.month == 12 ? 1 : _displayedMonth.month + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
      ),
      body: Column(
        children: [
          _StatsBar(),
          // Month navigation and calendar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: _goToPreviousMonth,
                ),
                Text(
                  '${_monthName(_displayedMonth.month)} ${_displayedMonth.year}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: _goToNextMonth,
                ),
              ],
            ),
          ),
          Expanded(child: _CalendarView(displayedMonth: _displayedMonth)),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
}

class _StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder for stats
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blueGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(label: 'Streak', value: '0'),
          _StatItem(label: 'Total Cash', value: '\$240.00'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

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

class _CalendarView extends StatelessWidget {
  final DateTime? displayedMonth;
  const _CalendarView({this.displayedMonth});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final year = displayedMonth?.year ?? now.year;
    final month = displayedMonth?.month ?? now.month;
    // If displayedMonth is the current month, use today's day, else -1
    final isCurrentMonth = (displayedMonth?.year == now.year && displayedMonth?.month == now.month) || (displayedMonth == null);
    final today = isCurrentMonth ? now.day : -1;
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // Use Sunday as the first day of the week (column 0)
    final firstWeekday = firstDayOfMonth.weekday; // 1 (Mon) - 7 (Sun)
    // For Sunday, leadingEmpty should be 0; for Monday, 1; ... Saturday, 6
    final leadingEmpty = firstWeekday % 7;
    final prevMonth = month == 1 ? 12 : month - 1;
    final prevMonthYear = month == 1 ? year - 1 : year;
    final prevMonthDays = DateTime(prevMonthYear, prevMonth + 1, 0).day;
    final totalCells = leadingEmpty + daysInMonth;
    final rows = ((totalCells) / 7).ceil();
    final itemCount = rows * 7;

    // Weekday abbreviations, Sunday first
    const weekdayAbbr = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    // Build a list of all cells to guarantee all days are present
    List<Widget> cells = [];
    for (int i = 0; i < itemCount; i++) {
      int day;
      int displayMonth = month;
      int displayYear = year;
      double opacity = 1.0;
      Color cellColor;

      bool isCurrentDay = false;
      if (i < leadingEmpty) {
        // Previous month
        day = prevMonthDays - (leadingEmpty - i - 1);
        displayMonth = prevMonth;
        displayYear = prevMonthYear;
        opacity = 0.4;
        cellColor = Colors.grey;
      } else if (i >= leadingEmpty + daysInMonth) {
        // Next month or future months
        day = i - (leadingEmpty + daysInMonth) + 1;
        // Calculate correct displayMonth and displayYear for overflow
        int offset = i - (leadingEmpty + daysInMonth);
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
          cellColor = const Color(0xFFBFC9D9); // Neutral gray with a hint of blue
        } else {
          cellColor = Colors.grey;
        }
      } else {
        // Current month
        day = i - leadingEmpty + 1;
        if (today != -1 && day > today) {
          cellColor = const Color(0xFFBFC9D9); // Neutral gray with a hint of blue
        } else {
          cellColor = Colors.green.shade200; // Green for past and present days
        }
        // Highlight current day
        if (today != -1 && day == today) {
          isCurrentDay = true;
        }
      }

      final cellKey = ValueKey('calendar-cell-$displayYear-$displayMonth-$day');
      // ignore: avoid_print
      print('Rendering cell: $cellKey');
      cells.add(
        Opacity(
          opacity: opacity,
          child: Container(
            key: cellKey,
            decoration: BoxDecoration(
              color: cellColor,
              borderRadius: BorderRadius.circular(8),
              border: isCurrentDay ? Border.all(color: Colors.blue, width: 3) : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isCurrentDay ? FontWeight.bold : FontWeight.w500,
                  color: isCurrentDay ? Colors.blue.shade900 : null,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekdayAbbr
                .map((abbr) => Expanded(
                      child: Center(
                        child: Text(
                          abbr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
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
