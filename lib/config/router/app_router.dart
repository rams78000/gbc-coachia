import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/chatbot/presentation/pages/chatbot_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/documents/presentation/pages/documents_page.dart';
import '../../features/finance/presentation/pages/finance_overview_page.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/planner/presentation/pages/planner_page.dart';
import '../../features/settings/presentation/pages/onboarding_settings_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/storage/presentation/pages/storage_page.dart';
import '../di/service_locator.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => getIt<OnboardingBloc>(),
            child: const OnboardingPage(),
          ),
        ),
      ),
      
      // Dashboard
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DashboardPage(),
        ),
      ),
      
      // Chatbot
      GoRoute(
        path: '/chatbot',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ChatbotPage(),
        ),
      ),
      
      // Planner
      GoRoute(
        path: '/planner',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const PlannerPage(),
        ),
      ),
      
      // Finance
      GoRoute(
        path: '/finance',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const FinanceOverviewPage(),
        ),
      ),
      
      // Documents
      GoRoute(
        path: '/documents',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DocumentsPage(),
        ),
      ),
      
      // Storage
      GoRoute(
        path: '/storage',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const StoragePage(),
        ),
      ),
      
      // Settings
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SettingsPage(),
        ),
        routes: [
          // Sous-route pour accéder à l'onboarding depuis les paramètres
          GoRoute(
            path: 'onboarding',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: BlocProvider(
                create: (context) => getIt<OnboardingBloc>(),
                child: const OnboardingSettingsPage(),
              ),
            ),
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Page non trouvée'),
          backgroundColor: const Color(0xFFB87333),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Color(0xFFB87333),
              ),
              const SizedBox(height: 16),
              const Text(
                'Page non trouvée',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('L\'URL ${state.uri.path} n\'existe pas'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB87333),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retour à l\'accueil'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
