import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant IA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: const Center(
        child: Text('Écran Assistant IA - À venir'),
      ),
    );
  }
}
