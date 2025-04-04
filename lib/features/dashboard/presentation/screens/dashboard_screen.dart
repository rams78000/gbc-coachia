import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../finance/domain/repositories/finance_repository.dart';
import '../../../finance/presentation/bloc/finance_bloc.dart';
import '../../../planner/domain/repositories/planner_repository.dart';
import '../../../planner/presentation/bloc/planner_bloc.dart';

/// Écran du tableau de bord
class DashboardScreen extends StatefulWidget {
  /// Constructeur
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Charger les données financières
    context.read<FinanceBloc>().add(const LoadTransactions());
    
    // Charger les événements du planificateur
    context.read<PlannerBloc>().add(const LoadEvents());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Tableau de bord',
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec salutation
              _WelcomeHeader(),
              const SizedBox(height: 24),
              
              // Aperçu financier
              _FinanceOverview(),
              const SizedBox(height: 24),
              
              // Événements à venir
              _UpcomingEvents(),
              const SizedBox(height: 24),
              
              // Liens rapides
              _QuickLinks(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget d'en-tête avec salutation
class _WelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final hour = now.hour;
    
    String greeting;
    if (hour < 12) {
      greeting = 'Bonjour';
    } else if (hour < 18) {
      greeting = 'Bon après-midi';
    } else {
      greeting = 'Bonsoir';
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor,
              theme.primaryColorDark,
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bienvenue sur GBC CoachIA',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Discuter avec l\'IA',
                    icon: Icons.smart_toy,
                    onPressed: () {
                      GoRouter.of(context).go('/chatbot');
                    },
                    isPrimary: false,
                  ),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.psychology,
                size: 40,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget d'aperçu financier
class _FinanceOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Aperçu financier',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/finance');
              },
              child: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        BlocBuilder<FinanceBloc, FinanceState>(
          builder: (context, state) {
            if (state is TransactionsLoaded) {
              final transactions = state.transactions;
              final currentBalance = state.currentBalance;
              
              // Calculer les revenus et dépenses des 30 derniers jours
              final now = DateTime.now();
              final monthAgo = now.subtract(const Duration(days: 30));
              
              double monthlyIncome = 0;
              double monthlyExpense = 0;
              
              for (final transaction in transactions) {
                if (transaction.date.isAfter(monthAgo)) {
                  if (transaction.type == TransactionType.income) {
                    monthlyIncome += transaction.amount;
                  } else {
                    monthlyExpense += transaction.amount;
                  }
                }
              }
              
              return Column(
                children: [
                  // Carte du solde
                  _BalanceCard(balance: currentBalance),
                  const SizedBox(height: 16),
                  
                  // Cartes revenus/dépenses du mois
                  Row(
                    children: [
                      Expanded(
                        child: _FinanceSummaryCard(
                          title: 'Revenus (30j)',
                          amount: monthlyIncome,
                          icon: Icons.arrow_upward,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _FinanceSummaryCard(
                          title: 'Dépenses (30j)',
                          amount: monthlyExpense,
                          icon: Icons.arrow_downward,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  
                  // Dernières transactions
                  if (transactions.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Dernières transactions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...transactions.take(3).map((transaction) => _TransactionItem(
                      transaction: transaction,
                    )),
                  ],
                ],
              );
            } else if (state is FinanceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FinanceError) {
              return Center(
                child: Text(
                  'Erreur: ${state.message}',
                  style: TextStyle(color: Colors.red[700]),
                ),
              );
            } else {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ],
    );
  }
}

/// Carte pour afficher le solde
class _BalanceCard extends StatelessWidget {
  final double balance;

  const _BalanceCard({
    Key? key,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Solde actuel',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              formatter.format(balance),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: balance >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte pour afficher un résumé financier
class _FinanceSummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const _FinanceSummaryCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              formatter.format(amount),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Item pour une transaction
class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: color,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    DateFormat.yMMMd().format(transaction.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              formatter.format(transaction.amount),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget d'événements à venir
class _UpcomingEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Événements à venir',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/planner');
              },
              child: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        BlocBuilder<PlannerBloc, PlannerState>(
          builder: (context, state) {
            if (state is PlannerLoaded) {
              final events = state.events;
              
              // Filtrer pour n'avoir que les événements à venir
              final now = DateTime.now();
              final upcomingEvents = events
                  .where((event) => event.startTime.isAfter(now))
                  .toList()
                ..sort((a, b) => a.startTime.compareTo(b.startTime));
              
              if (upcomingEvents.isEmpty) {
                return _EmptyEventsCard();
              }
              
              return Column(
                children: upcomingEvents.take(3).map((event) => _EventItem(
                  event: event,
                )).toList(),
              );
            } else if (state is PlannerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlannerError) {
              return Center(
                child: Text(
                  'Erreur: ${state.message}',
                  style: TextStyle(color: Colors.red[700]),
                ),
              );
            } else {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ],
    );
  }
}

/// Item pour un événement
class _EventItem extends StatelessWidget {
  final PlanEvent event;

  const _EventItem({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(event.colorValue);
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat.yMMMd().format(event.startTime),
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.isAllDay
                            ? 'Toute la journée'
                            : DateFormat.Hm().format(event.startTime),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte pour afficher quand il n'y a pas d'événements
class _EmptyEventsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.event_available,
              color: Colors.grey[400],
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aucun événement à venir',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ajoutez des événements dans le planificateur',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour les liens rapides
class _QuickLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Liens rapides',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.chat,
                title: 'IA Coach',
                description: 'Obtenir des conseils personnalisés',
                onTap: () {
                  GoRouter.of(context).go('/chatbot');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.calendar_today,
                title: 'Planificateur',
                description: 'Gérer votre agenda professionnel',
                onTap: () {
                  GoRouter.of(context).go('/planner');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.account_balance_wallet,
                title: 'Finances',
                description: 'Suivre vos revenus et dépenses',
                onTap: () {
                  GoRouter.of(context).go('/finance');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.person,
                title: 'Profil',
                description: 'Modifier vos paramètres',
                onTap: () {
                  GoRouter.of(context).go('/profile');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Carte pour un lien rapide
class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _QuickLinkCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: theme.primaryColor,
                size: 30,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
