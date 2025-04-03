import 'package:flutter/material.dart';

/// Chatbot screen
class ChatbotScreen extends StatelessWidget {
  /// Creates a ChatbotScreen
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant IA'),
      ),
      body: const Center(
        child: Text('Écran Assistant IA - À développer'),
      ),
    );
  }
}
