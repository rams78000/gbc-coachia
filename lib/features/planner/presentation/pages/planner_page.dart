import 'package:flutter/material.dart';
import '../../../../features/common/presentation/widgets/navigation_menu.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Ajouter un nouvel événement
            },
          ),
        ],
      ),
      body: Center(
        child: const Text('Calendrier en construction...'),
      ),
      bottomNavigationBar: const NavigationMenu(currentIndex: 2),
    );
  }
}
