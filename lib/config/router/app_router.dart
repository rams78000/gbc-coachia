import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/config/di/service_locator.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gbc_coachia/features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'package:gbc_coachia/features/chatbot/presentation/pages/chatbot_page.dart';
import 'package:gbc_coachia/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gbc_coachia/features/documents/presentation/bloc/document_bloc.dart';
import 'package:gbc_coachia/features/documents/presentation/pages/document_create_page.dart';
import 'package:gbc_coachia/features/documents/presentation/pages/document_detail_page.dart';
import 'package:gbc_coachia/features/documents/presentation/pages/document_templates_page.dart';
import 'package:gbc_coachia/features/documents/presentation/pages/documents_page.dart';
import 'package:gbc_coachia/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:gbc_coachia/features/finance/presentation/pages/finance_overview_page.dart';
import 'package:gbc_coachia/features/planner/presentation/pages/planner_page.dart';
import 'package:gbc_coachia/features/profile/presentation/pages/profile_page.dart';
import 'package:gbc_coachia/features/shared/presentation/pages/not_found_page.dart';
import 'package:gbc_coachia/features/shared/presentation/widgets/main_scaffold.dart';
import 'package:go_router/go_router.dart';

/// Gestionnaire de routes de l'application
class AppRouter {
  /// Crée et configure le routeur de l'application
  static GoRouter router(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      redirect: (BuildContext context, GoRouterState state) {
        // Logique de redirection basée sur l'état d'authentification
        // Exemple: Si l'utilisateur n'est pas connecté, rediriger vers /login
        final String path = state.uri.path;
        if (authState is Unauthenticated && 
            path != '/login' &&
            path != '/register') {
          return '/login';
        }
        
        // Pas de redirection
        return null;
      },
      routes: [
        // Destination principale avec bottom navigation bar
        ShellRoute(
          builder: (context, state, child) => MainScaffold(child: child),
          routes: [
            // Dashboard (page d'accueil)
            GoRoute(
              path: '/',
              name: 'dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
            
            // Chatbot
            GoRoute(
              path: '/chatbot',
              name: 'chatbot',
              builder: (context, state) => BlocProvider(
                create: (context) => serviceLocator<ChatbotBloc>(),
                child: const ChatbotPage(),
              ),
            ),
            
            // Planner
            GoRoute(
              path: '/planner',
              name: 'planner',
              builder: (context, state) => const PlannerPage(),
            ),
            
            // Finances
            GoRoute(
              path: '/finances',
              name: 'finances',
              builder: (context, state) => BlocProvider(
                create: (context) => serviceLocator<FinanceBloc>(),
                child: const FinanceOverviewPage(),
              ),
            ),
            
            // Documents
            GoRoute(
              path: '/documents',
              name: 'documents',
              builder: (context, state) => BlocProvider(
                create: (context) => serviceLocator<DocumentBloc>(),
                child: const DocumentsPage(),
              ),
              routes: [
                // Liste des modèles de document
                GoRoute(
                  path: 'templates',
                  name: 'document_templates',
                  builder: (context, state) => const DocumentTemplatesPage(),
                ),
                // Création d'un document à partir d'un modèle
                GoRoute(
                  path: 'create',
                  name: 'document_create',
                  builder: (context, state) {
                    final templateId = state.uri.queryParameters['templateId'] ?? '';
                    return DocumentCreatePage(templateId: templateId);
                  },
                ),
                // Détail d'un document
                GoRoute(
                  path: 'detail',
                  name: 'document_detail',
                  builder: (context, state) {
                    final documentId = state.uri.queryParameters['documentId'] ?? '';
                    return DocumentDetailPage(documentId: documentId);
                  },
                ),
              ],
            ),
            
            // Profil
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
        
        // Routes hors navigation principale
        // (comme login, register, notifications, settings, etc.)
      ],
      errorBuilder: (context, state) => const NotFoundPage(),
    );
  }
}
