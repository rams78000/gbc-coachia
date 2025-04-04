import 'package:flutter/material.dart';
import '../../../../features/common/presentation/widgets/navigation_menu.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Action de recherche
            },
          ),
        ],
      ),
      body: Center(
        child: const Text('Page Documents en construction...'),
      ),
      bottomNavigationBar: const NavigationMenu(currentIndex: 4),
    );
  }
}
