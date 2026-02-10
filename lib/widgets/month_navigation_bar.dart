import 'package:flutter/material.dart';

class MonthNavigationBar extends StatelessWidget {
  final String monthName;
  final int year;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  const MonthNavigationBar({required this.monthName, required this.year, required this.onPrevious, required this.onNext, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Previous Month',
            onPressed: onPrevious,
          ),
          Text(
            '$monthName $year',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Next Month',
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
