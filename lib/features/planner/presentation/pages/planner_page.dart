import 'package:flutter/material.dart';

/// Page du planificateur
class PlannerPage extends StatelessWidget {
  const PlannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificateur'),
      ),
      body: const Center(
        child: Text('Contenu du planificateur à venir'),
      ),
    );
  }
}