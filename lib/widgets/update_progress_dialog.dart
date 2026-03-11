import 'package:flutter/material.dart';
import '../models/goal.dart';

class UpdateProgressDialog extends StatefulWidget {
  final List<Goal> goals;
  final void Function(Map<String, int> progressByGoal) onSave;

  const UpdateProgressDialog({super.key, required this.goals, required this.onSave});

  @override
  State<UpdateProgressDialog> createState() => _UpdateProgressDialogState();
}

class _UpdateProgressDialogState extends State<UpdateProgressDialog> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (final goal in widget.goals) {
      _controllers[goal.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _save() {
    final progressByGoal = <String, int>{};
    for (final goal in widget.goals) {
      final text = _controllers[goal.id]?.text ?? '';
      final value = int.tryParse(text) ?? 0;
      progressByGoal[goal.id] = value;
    }
    widget.onSave(progressByGoal);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Progress'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.goals.map((goal) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _controllers[goal.id],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: goal.name,
                  hintText: 'Enter progress for today',
                  suffixText: goal.unit,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
