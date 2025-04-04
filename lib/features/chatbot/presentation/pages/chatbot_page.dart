import 'package:flutter/material.dart';
import '../../../../features/common/presentation/widgets/navigation_menu.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant IA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Afficher un menu d'options
            },
          ),
        ],
      ),
      body: Center(
        child: const Text('Interface de chat en construction...'),
      ),
      bottomNavigationBar: const NavigationMenu(currentIndex: 1),
    );
  }
}
