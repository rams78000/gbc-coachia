import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gbc_coachai/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:gbc_coachai/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:gbc_coachai/features/dashboard/presentation/widgets/activity_summary_card.dart';
import 'package:gbc_coachai/features/dashboard/presentation/widgets/financial_summary_card.dart';
import 'package:gbc_coachai/features/dashboard/presentation/widgets/quick_actions_card.dart';
import 'package:gbc_coachai/features/dashboard/presentation/widgets/recent_documents_card.dart';
import 'package:gbc_coachai/features/dashboard/presentation/widgets/recent_transactions_card.dart';
import 'package:gbc_coachai/features/dashboard/presentation/widgets/upcoming_events_card.dart';
import 'package:gbc_coachai/features/documents/domain/entities/document.dart';
import 'package:gbc_coachai/features/documents/presentation/bloc/document_bloc.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const LoadDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour Entrepreneur',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _getTodayDate(),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(const RefreshDashboardData());
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardRefreshing) {
              return _buildDashboardContent(context, state.dashboardData);
            } else if (state is DashboardLoaded) {
              return _buildDashboardContent(context, state.dashboardData);
            } else if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text('Erreur: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DashboardBloc>().add(const LoadDashboardData());
                      },
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('État inconnu'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardData data) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick actions
          QuickActionsCard(
            actions: _buildQuickActions(context),
          ),
          const SizedBox(height: 16),
          
          // Financial summary
          FinancialSummaryCard(
            financialOverview: data.financialOverview,
            onTap: () {
              context.go('/finance');
            },
          ),
          const SizedBox(height: 16),
          
          // Upcoming events
          UpcomingEventsCard(
            events: data.upcomingEvents,
            onTap: () {
              context.go('/planner');
            },
            onAddEvent: () {
              context.go('/planner');
              // Idéalement déclenchement de la modale d'ajout d'événement
            },
          ),
          const SizedBox(height: 16),
          
          // Recent transactions
          RecentTransactionsCard(
            transactions: data.recentTransactions,
            onTap: () {
              context.go('/finance');
            },
          ),
          const SizedBox(height: 16),
          
          // Recent documents
          RecentDocumentsCard(
            documents: data.recentDocuments,
            onTap: () {
              context.go('/documents');
            },
            onDocumentTap: (document) {
              context.read<DocumentBloc>().add(ViewDocument(document.id));
              context.go('/documents');
            },
          ),
          const SizedBox(height: 16),
          
          // Activity summary
          ActivitySummaryCard(
            activitySummary: data.activitySummary,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<QuickAction> _buildQuickActions(BuildContext context) {
    return [
      QuickAction(
        label: 'Nouvelle transaction',
        icon: Icons.add_card,
        color: Colors.green,
        onTap: () {
          context.go('/finance');
          // Idéalement déclenchement de la modale d'ajout de transaction
        },
      ),
      QuickAction(
        label: 'Ajouter événement',
        icon: Icons.event_available,
        color: Colors.blue,
        onTap: () {
          context.go('/planner');
          // Idéalement déclenchement de la modale d'ajout d'événement
        },
      ),
      QuickAction(
        label: 'Scanner document',
        icon: Icons.document_scanner,
        color: Colors.amber,
        onTap: () {
          context.go('/documents');
          // Idéalement déclenchement de la modale d'ajout de document
        },
      ),
      QuickAction(
        label: 'Consulter IA',
        icon: Icons.smart_toy,
        color: Colors.purple,
        onTap: () {
          context.go('/chatbot');
        },
      ),
    ];
  }

  String _getTodayDate() {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE d MMMM yyyy', 'fr_FR');
    String formatted = dateFormat.format(now);
    // Capitalize first letter
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}
