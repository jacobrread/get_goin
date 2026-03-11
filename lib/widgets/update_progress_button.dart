import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../models/calendar_entry.dart';
import 'update_progress_dialog.dart';

class UpdateProgressButton extends StatelessWidget {
  final VoidCallback onProgressUpdated;
  const UpdateProgressButton({super.key, required this.onProgressUpdated});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: 220,
        height: 84,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            final goalsRepo = Provider.of<Box<Goal>>(context, listen: false);
            final calendarRepo = Provider.of<Box<CalendarEntry>>(context, listen: false);
            final goals = goalsRepo.values.toList();
            if (goals.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No goals to update.')));
              return;
            }
            await showDialog(
              context: context,
              builder: (context) => UpdateProgressDialog(
                goals: List<Goal>.from(goals),
                onSave: (progressByGoal) async {
                  final now = DateTime.now();
                  for (final entry in progressByGoal.entries) {
                    final goalId = entry.key;
                    final progress = entry.value;
                    final id = '${goalId}_${now.year}_${now.month}_${now.day}';
                    final calendarEntry = CalendarEntry(
                      id: id,
                      goalId: goalId,
                      date: DateTime(now.year, now.month, now.day),
                      progress: progress,
                      success: progress > 0,
                    );
                    await calendarRepo.put(id, calendarEntry);
                  }
                  onProgressUpdated();
                },
              ),
            );
          },
          child: const Text('💪'),
        ),
      ),
    );
  }
}
