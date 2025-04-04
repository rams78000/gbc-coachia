import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Widget fournissant une structure d'écran cohérente avec navigation
class AppScaffold extends StatefulWidget {
  /// Titre de l'écran
  final String title;

  /// Contenu principal de l'écran
  final Widget body;

  /// Ajoute un bouton de retour s'il est à true
  final bool showBackButton;

  /// Actions additionnelles dans l'AppBar
  final List<Widget>? actions;

  /// Constructeur
  const AppScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.showBackButton = false,
    this.actions,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => GoRouter.of(context).pop(),
              )
            : null,
        actions: widget.actions,
      ),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBar.item(
            icon: Icon(Icons.dashboard),
            label: 'Tableau de bord',
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.chat),
            label: 'IA Coach',
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.calendar_today),
            label: 'Planifier',
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Finances',
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/chatbot');
        break;
      case 2:
        GoRouter.of(context).go('/planner');
        break;
      case 3:
        GoRouter.of(context).go('/finance');
        break;
      case 4:
        GoRouter.of(context).go('/profile');
        break;
    }
  }
}
