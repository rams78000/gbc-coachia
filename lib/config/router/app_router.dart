import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/chatbot/presentation/pages/chatbot_page.dart';
import 'package:gbc_coachia/features/chatbot/presentation/pages/conversation_detail_page.dart';
import 'package:gbc_coachia/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gbc_coachia/features/documents/presentation/pages/documents_page.dart';
import 'package:gbc_coachia/features/finance/presentation/pages/finance_overview_page.dart';
import 'package:gbc_coachia/features/planner/presentation/pages/planner_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/chatbot',
            name: 'chatbot',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const ChatbotPage(),
            ),
            routes: [
              GoRoute(
                path: 'conversation/:id',
                name: 'conversation_detail',
                pageBuilder: (context, state) {
                  final conversationId = state.pathParameters['id'] ?? '';
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: ConversationDetailPage(
                      conversationId: conversationId,
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/planner',
            name: 'planner',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const PlannerPage(),
            ),
          ),
          GoRoute(
            path: '/finance',
            name: 'finance',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const FinanceOverviewPage(),
            ),
          ),
          GoRoute(
            path: '/documents',
            name: 'documents',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const DocumentsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}

class ScaffoldWithBottomNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithBottomNavBar({super.key, required this.child});

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  int _currentIndex = 0;

  static const List<_NavigationDestination> _destinations = [
    _NavigationDestination(
      route: '/dashboard',
      icon: Icons.dashboard,
      label: 'Tableau de bord',
    ),
    _NavigationDestination(
      route: '/chatbot',
      icon: Icons.chat,
      label: 'Assistant IA',
    ),
    _NavigationDestination(
      route: '/planner',
      icon: Icons.calendar_month,
      label: 'Planning',
    ),
    _NavigationDestination(
      route: '/finance',
      icon: Icons.account_balance_wallet,
      label: 'Finances',
    ),
    _NavigationDestination(
      route: '/documents',
      icon: Icons.folder,
      label: 'Documents',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Convert the current location path to an index for the BottomNavigationBar
    final String location = GoRouterState.of(context).matchedLocation;
    
    // Check if we're on a route that shouldn't show the bottom navigation
    final bool showBottomNav = !location.contains('/chatbot/conversation/');
    
    // Get the index of the current route in our destinations
    final String baseRoute = location.split('/').length > 1 ? '/${location.split('/')[1]}' : '/dashboard';
    final int index = _destinations.indexWhere((destination) => destination.route == baseRoute);
    _currentIndex = index >= 0 ? index : 0;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: showBottomNav ? NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          _onItemTapped(index, context);
        },
        destinations: _destinations
            .map(
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                label: destination.label,
              ),
            )
            .toList(),
      ) : null,
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    // Navigate using the GoRouter
    GoRouter.of(context).go(_destinations[index].route);
  }
}

class _NavigationDestination {
  final String route;
  final IconData icon;
  final String label;

  const _NavigationDestination({
    required this.route,
    required this.icon,
    required this.label,
  });
}
