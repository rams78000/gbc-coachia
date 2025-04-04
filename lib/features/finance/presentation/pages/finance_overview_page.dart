import 'package:flutter/material.dart';
import '../../../../features/common/presentation/widgets/navigation_menu.dart';

class FinanceOverviewPage extends StatelessWidget {
  const FinanceOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finances'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filtrer les transactions
            },
          ),
        ],
      ),
      body: Center(
        child: const Text('Aperçu financier en construction...'),
      ),
      bottomNavigationBar: const NavigationMenu(currentIndex: 3),
    );
  }
}
