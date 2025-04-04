import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Widget Scaffold avec une barre de navigation en bas
class ScaffoldWithNavbar extends StatelessWidget {
  /// Constructeur
  const ScaffoldWithNavbar({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// L'enfant à afficher dans le corps du scaffold
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Déterminez la section active en fonction de l'emplacement actuel
    final location = GoRouterState.of(context).location;
    int currentIndex = 0;
    
    if (location.startsWith('/dashboard')) {
      currentIndex = 0;
    } else if (location.startsWith('/chatbot')) {
      currentIndex = 1;
    } else if (location.startsWith('/planner')) {
      currentIndex = 2;
    } else if (location.startsWith('/finance')) {
      currentIndex = 3;
    } else if (location.startsWith('/profile')) {
      currentIndex = 4;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          // Naviguez vers la page correspondante
          switch (index) {
            case 0:
              context.go('/dashboard');
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
              context.go('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: 'Assistant',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Planifier',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Finances',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
