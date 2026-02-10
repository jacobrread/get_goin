import 'package:flutter/material.dart';

class CalendarCell extends StatelessWidget {
  final int day;
  final int displayMonth;
  final int displayYear;
  final double opacity;
  final Color cellColor;
  final bool isCurrentDay;
  const CalendarCell({
    super.key,
    required this.day,
    required this.displayMonth,
    required this.displayYear,
    required this.opacity,
    required this.cellColor,
    required this.isCurrentDay,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
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
    );
  }
}
