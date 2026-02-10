import 'package:flutter/material.dart';
import 'widgets/empty_feature.dart';

class SpendingScreen extends StatelessWidget {
  const SpendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending'),
      ),
      body: const EmptyFeature(
        icon: Icons.shopping_bag_outlined,
        message: 'Spending feature coming soon',
      ),
    );
  }
}
