import 'package:flutter/material.dart';

/// Finance screen
class FinanceScreen extends StatelessWidget {
  /// Creates a FinanceScreen
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finances'),
      ),
      body: const Center(
        child: Text('Écran Finances - À développer'),
      ),
    );
  }
}
