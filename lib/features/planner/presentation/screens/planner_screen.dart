import 'package:flutter/material.dart';

/// Planner screen
class PlannerScreen extends StatelessWidget {
  /// Creates a PlannerScreen
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificateur'),
      ),
      body: const Center(
        child: Text('Écran Planificateur - À développer'),
      ),
    );
  }
}
