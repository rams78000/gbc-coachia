import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationMenu extends StatelessWidget {
  final int currentIndex;

  const NavigationMenu({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final goldColor = const Color(0xFFFFD700);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Assistant',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Planning',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'Finances',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          label: 'Documents',
        ),
      ],
      onTap: (index) {
        if (index == currentIndex) return;
        
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/chatbot');
            break;
          case 2:
            context.go('/planner');
            break;
          case 3:
            context.go('/finance');
            break;
          case 4:
            context.go('/documents');
            break;
        }
      },
    );
  }
}
