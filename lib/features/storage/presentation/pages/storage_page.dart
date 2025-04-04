import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StoragePage extends StatelessWidget {
  const StoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stockage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: const Center(
        child: Text('Écran Stockage - À venir'),
      ),
    );
  }
}
