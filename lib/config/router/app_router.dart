import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/chatbot/presentation/pages/chatbot_page.dart';
import '../../features/planner/presentation/pages/planner_page.dart';
import '../../features/finance/presentation/pages/finance_overview_page.dart';
import '../../features/documents/presentation/pages/documents_page.dart';
import '../../features/storage/presentation/pages/storage_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/profile_settings_page.dart';
import '../../features/settings/presentation/pages/api_settings_page.dart';
import '../../features/settings/presentation/pages/notification_settings_page.dart';
import '../../features/settings/presentation/pages/privacy_settings_page.dart';

// Routes principales
const String dashboardRoute = '/';
const String chatbotRoute = '/chatbot';
const String plannerRoute = '/planner';
const String financeRoute = '/finance';
const String documentsRoute = '/documents';
const String storageRoute = '/storage';
const String settingsRoute = '/settings';

// Sous-routes des paramètres
const String profileSettingsRoute = '/settings/profile';
const String apiSettingsRoute = '/settings/api';
const String notificationSettingsRoute = '/settings/notifications';
const String privacySettingsRoute = '/settings/privacy';

// Configuration du routeur
final GoRouter appRouter = GoRouter(
  initialLocation: dashboardRoute,
  routes: [
    GoRoute(
      path: dashboardRoute,
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: chatbotRoute,
      builder: (context, state) => const ChatbotPage(),
    ),
    GoRoute(
      path: plannerRoute,
      builder: (context, state) => const PlannerPage(),
    ),
    GoRoute(
      path: financeRoute,
      builder: (context, state) => const FinanceOverviewPage(),
    ),
    GoRoute(
      path: documentsRoute,
      builder: (context, state) => const DocumentsPage(),
    ),
    GoRoute(
      path: storageRoute,
      builder: (context, state) => const StoragePage(),
    ),
    GoRoute(
      path: settingsRoute,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: profileSettingsRoute,
      builder: (context, state) => const ProfileSettingsPage(),
    ),
    GoRoute(
      path: apiSettingsRoute,
      builder: (context, state) => const ApiSettingsPage(),
    ),
    GoRoute(
      path: notificationSettingsRoute,
      builder: (context, state) => const NotificationSettingsPage(),
    ),
    GoRoute(
      path: privacySettingsRoute,
      builder: (context, state) => const PrivacySettingsPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Page non trouvée'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'La page que vous recherchez n\'existe pas',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(dashboardRoute),
            child: const Text('Retour à l\'accueil'),
          ),
        ],
      ),
    ),
  ),
);
