import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/goal.dart';

class CreateGoalDialog extends StatefulWidget {
  final Function(Goal) onSave;
  final Goal? existingGoal;
  final Function(Goal)? onEdit;

  const CreateGoalDialog({super.key, required this.onSave, this.existingGoal, this.onEdit});

  @override
  State<CreateGoalDialog> createState() => _CreateGoalDialogState();
}

class _CreateGoalDialogState extends State<CreateGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _unitController = TextEditingController();
  final _valueController = TextEditingController();
  final _penaltyController = TextEditingController();

  String _duration = '1 week';
  final List<String> _durations = ['1 week', '2 weeks', '1 month', '2 months'];
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    if (widget.existingGoal != null) {
      final g = widget.existingGoal!;
      _nameController.text = g.name;
      _targetController.text = g.target.toString();
      _unitController.text = g.unit;
      _valueController.text = g.valuePerUnit.toString();
      _penaltyController.text = g.penaltyAmount.toString();
      _startDate = g.startDate;
      _endDate = g.endDate;
      // Guess duration string from dates (approximate)
      final diff = g.endDate.difference(g.startDate).inDays;
      if (diff <= 7) {
        _duration = '1 week';
      } else if (diff <= 14) {
        _duration = '2 weeks';
      } else if (diff <= 31) {
        _duration = '1 month';
      } else {
        _duration = '2 months';
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    _valueController.dispose();
    _penaltyController.dispose();
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
      final isEdit = widget.existingGoal != null;
      final goal = Goal(
        id: isEdit ? widget.existingGoal!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        target: int.parse(_targetController.text),
        unit: _unitController.text,
        valuePerUnit: double.parse(_valueController.text),
        startDate: isEdit ? _startDate! : DateTime.now(),
        endDate: isEdit ? _endDate! : _calculateEndDate(_duration),
        penaltyAmount: double.parse(_penaltyController.text),
      );
      if (isEdit && widget.onEdit != null) {
        widget.onEdit!(goal);
      } else {
        widget.onSave(goal);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingGoal != null ? 'Edit Goal' : 'Create Goal'),
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
              TextFormField(
                controller: _penaltyController,
                decoration: const InputDecoration(
                  labelText: 'Penalty Amount (\$)',
                  hintText: 'e.g., 10.00',
                  prefixText: '\$',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a penalty amount';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
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
                onChanged: widget.existingGoal != null
                    ? null // Disable changing duration for edit
                    : (value) {
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
          child: Text(widget.existingGoal != null ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}
