import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinanceOverviewPage extends StatelessWidget {
  const FinanceOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: const Center(
        child: Text('Écran Finance - À venir'),
      ),
    );
  }
}
