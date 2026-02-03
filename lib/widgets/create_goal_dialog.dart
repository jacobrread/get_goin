import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/goal.dart';

class CreateGoalDialog extends StatefulWidget {
  final Function(Goal) onSave;

  const CreateGoalDialog({super.key, required this.onSave});

  @override
  State<CreateGoalDialog> createState() => _CreateGoalDialogState();
}

class _CreateGoalDialogState extends State<CreateGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _unitController = TextEditingController();
  final _valueController = TextEditingController();
  
  String _duration = '1 week';
  final List<String> _durations = ['1 week', '2 weeks', '1 month', '2 months'];

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  DateTime _calculateEndDate(String duration) {
    final now = DateTime.now();
    switch (duration) {
      case '1 week':
        return now.add(const Duration(days: 7));
      case '2 weeks':
        return now.add(const Duration(days: 14));
      case '1 month':
        return DateTime(now.year, now.month + 1, now.day);
      case '2 months':
        return DateTime(now.year, now.month + 2, now.day);
      default:
        return now.add(const Duration(days: 7));
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final goal = Goal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        target: int.parse(_targetController.text),
        unit: _unitController.text,
        valuePerUnit: double.parse(_valueController.text),
        startDate: DateTime.now(),
        endDate: _calculateEndDate(_duration),
      );
      widget.onSave(goal);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Goal'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Goal Name',
                  hintText: 'e.g., Push-ups',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetController,
                decoration: const InputDecoration(
                  labelText: 'Daily Target',
                  hintText: 'e.g., 50',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  hintText: 'e.g., reps, minutes, km',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Value per Unit (\$)',
                  hintText: 'e.g., 0.10',
                  prefixText: '\$',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _duration,
                decoration: const InputDecoration(
                  labelText: 'Duration',
                ),
                items: _durations.map((duration) {
                  return DropdownMenuItem(
                    value: duration,
                    child: Text(duration),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _duration = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
