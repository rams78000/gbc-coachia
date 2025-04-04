import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gbc_coachia/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gbc_coachia/features/chatbot/presentation/pages/chatbot_page.dart';
import 'package:gbc_coachia/features/finance/presentation/pages/finance_overview_page.dart';
import 'scaffold_with_navbar.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return const DashboardPage();
            },
          ),
          GoRoute(
            path: '/chatbot',
            builder: (BuildContext context, GoRouterState state) {
              return const ChatbotPage();
            },
          ),
          GoRoute(
            path: '/finance',
            builder: (BuildContext context, GoRouterState state) {
              return const FinanceOverviewPage();
            },
          ),
        ],
      ),
    ],
  );
}
