import 'package:flutter/material.dart';
import 'widgets/empty_feature.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: const EmptyFeature(
        icon: Icons.people_outline,
        message: 'Friends feature coming soon',
      ),
    );
  }
}
