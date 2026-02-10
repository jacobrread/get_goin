import 'package:flutter/material.dart';

class WeekdayHeader extends StatelessWidget {
  const WeekdayHeader({super.key});
  @override
  Widget build(BuildContext context) {
    const weekdayAbbr = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
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
    );
  }
}
