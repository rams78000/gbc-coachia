import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Scaffold principal avec navigation bottom bar
class MainScaffold extends StatefulWidget {
  final Widget child;
  
  const MainScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);
  
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          
          // Navigation basée sur l'index
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
              context.go('/finances');
              break;
            case 4:
              context.go('/documents');
              break;
            case 5:
              context.go('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Tableau',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: 'Assistant',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Planner',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Finances',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: 'Documents',
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
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  void _updateCurrentIndex() {
    final String location = GoRouterState.of(context).uri.path;
    
    if (location == '/' || location.startsWith('/dashboard')) {
      setState(() => _currentIndex = 0);
    } else if (location.startsWith('/chatbot')) {
      setState(() => _currentIndex = 1);
    } else if (location.startsWith('/planner')) {
      setState(() => _currentIndex = 2);
    } else if (location.startsWith('/finances')) {
      setState(() => _currentIndex = 3);
    } else if (location.startsWith('/documents')) {
      setState(() => _currentIndex = 4);
    } else if (location.startsWith('/profile')) {
      setState(() => _currentIndex = 5);
    }
  }
}