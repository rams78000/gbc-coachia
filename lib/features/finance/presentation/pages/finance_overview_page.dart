import 'package:flutter/material.dart';

/// Page de vue d'ensemble des finances
class FinanceOverviewPage extends StatelessWidget {
  const FinanceOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finances'),
      ),
      body: const Center(
        child: Text('Contenu des finances à venir'),
      ),
    );
  }
}