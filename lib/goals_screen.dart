import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/goal.dart';
import 'repositories/hive_goal_repository.dart';
import 'widgets/create_goal_dialog.dart';



class GoalsScreen extends StatefulWidget {
  final HiveGoalRepository? repository;
  const GoalsScreen({super.key, this.repository});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}


class _GoalsScreenState extends State<GoalsScreen> {
  late HiveGoalRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? HiveGoalRepository(Hive.box<Goal>('goals'));
  }

  void _showCreateGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateGoalDialog(
        onSave: (goal) async {
          await _repository.addGoal(goal);
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Goals'),
      ),
      body: FutureBuilder<List<Goal>>(
        future: _repository.getGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final goals = snapshot.data ?? [];

          if (goals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No goals yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to create your first goal',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(goal.name.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(goal.name),
                  subtitle: Text(
                    '${goal.target} ${goal.unit} • \$${goal.valuePerUnit.toStringAsFixed(2)} per ${goal.unit}',
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Goal'),
                            content: Text(
                              'Are you sure you want to delete "${goal.name}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await _repository.deleteGoal(goal.id);
                          setState(() {});
                        }
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateGoalDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
