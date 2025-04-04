import 'package:flutter/material.dart';

/// Page du tableau de bord principal
class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
      ),
      body: const Center(
        child: Text('Contenu du tableau de bord à venir'),
      ),
    );
  }
}