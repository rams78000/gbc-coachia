import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Dashboard screen
class DashboardScreen extends StatefulWidget {
  /// Constructor
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Demo data for UI
  final List<Map<String, dynamic>> _upcomingTasks = [
    {
      'title': 'Réunion client',
      'time': DateTime.now().add(const Duration(hours: 2)),
      'isCompleted': false,
    },
    {
      'title': 'Finaliser proposition commerciale',
      'time': DateTime.now().add(const Duration(hours: 5)),
      'isCompleted': false,
    },
    {
      'title': 'Appel avec fournisseur',
      'time': DateTime.now().add(const Duration(hours: 1)),
      'isCompleted': false,
    },
  ];

  final List<Map<String, dynamic>> _financialStats = [
    {
      'title': 'Revenus du mois',
      'value': '4,250 €',
      'change': '+12%',
      'isPositive': true,
      'icon': Icons.trending_up,
    },
    {
      'title': 'Dépenses du mois',
      'value': '1,820 €',
      'change': '-5%',
      'isPositive': true,
      'icon': Icons.trending_down,
    },
    {
      'title': 'Trésorerie',
      'value': '8,430 €',
      'change': '+3%',
      'isPositive': true,
      'icon': Icons.account_balance_wallet,
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      'title': 'Nouveau Rendez-vous',
      'icon': Icons.event,
      'color': Colors.blue,
      'route': '/planner',
    },
    {
      'title': 'Poser une Question',
      'icon': Icons.chat,
      'color': Colors.purple,
      'route': '/chatbot',
    },
    {
      'title': 'Ajouter une Dépense',
      'icon': Icons.receipt_long,
      'color': Colors.green,
      'route': '/finance',
    },
    {
      'title': 'Créer une Facture',
      'icon': Icons.description,
      'color': Colors.orange,
      'route': '/finance',
    },
  ];

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bonjour';
    } else if (hour < 18) {
      return 'Bon après-midi';
    } else {
      return 'Bonsoir';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! Authenticated) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = state.user;
          final displayName = user.displayName?.split(' ').first ?? 'Entrepreneur';

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                // Simulate refresh
                await Future.delayed(const Duration(seconds: 1));
                // In a real app, fetch latest data here
              },
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: true,
                    pinned: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_greeting()}, $displayName!',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('EEEE d MMMM y', 'fr_FR').format(DateTime.now()),
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Show notifications
                              },
                              icon: const Badge(
                                label: Text('3'),
                                child: Icon(Icons.notifications, size: 28),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Main content
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // AI Insight Card
                        AppCard(
                          color: AppColors.primary,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.tips_and_updates,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Conseil du jour',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Analysez vos données clients pour identifier vos meilleurs segments. Cela vous permettra de concentrer vos efforts marketing sur les clients les plus rentables.',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () {
                                  context.push('/chatbot');
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                ),
                                child: const Text('Demander plus de conseils'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppTheme.spacing(3)),

                        // Quick Actions
                        Text(
                          'Actions Rapides',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppTheme.spacing(2)),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: _quickActions.length,
                          itemBuilder: (context, index) {
                            final action = _quickActions[index];
                            return _buildQuickActionCard(
                              title: action['title'],
                              icon: action['icon'],
                              color: action['color'],
                              onTap: () => context.push(action['route']),
                            );
                          },
                        ),
                        SizedBox(height: AppTheme.spacing(3)),

                        // Upcoming Tasks
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tâches Planifiées',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/planner');
                              },
                              child: const Text('Voir tout'),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.spacing(1)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _upcomingTasks.length,
                          itemBuilder: (context, index) {
                            final task = _upcomingTasks[index];
                            return _buildTaskCard(
                              title: task['title'],
                              time: task['time'],
                              isCompleted: task['isCompleted'],
                            );
                          },
                        ),
                        SizedBox(height: AppTheme.spacing(3)),

                        // Financial Overview
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Aperçu Financier',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/finance');
                              },
                              child: const Text('Détails'),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.spacing(1)),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: _financialStats.length,
                          itemBuilder: (context, index) {
                            final stat = _financialStats[index];
                            return _buildFinancialCard(
                              title: stat['title'],
                              value: stat['value'],
                              change: stat['change'],
                              isPositive: stat['isPositive'],
                              icon: stat['icon'],
                            );
                          },
                        ),
                        SizedBox(height: AppTheme.spacing(3)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required DateTime time,
    required bool isCompleted,
  }) {
    final timeString = DateFormat('HH:mm').format(time);
    final timeFromNow = time.difference(DateTime.now());
    String timeFromNowString;

    if (timeFromNow.inHours > 0) {
      timeFromNowString = 'Dans ${timeFromNow.inHours}h';
    } else if (timeFromNow.inMinutes > 0) {
      timeFromNowString = 'Dans ${timeFromNow.inMinutes}min';
    } else {
      timeFromNowString = 'Maintenant';
    }

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: timeFromNow.inHours < 1 ? Colors.red : AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeString,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: timeFromNow.inHours < 1
                            ? Colors.red.withOpacity(0.1)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        timeFromNowString,
                        style: TextStyle(
                          color: timeFromNow.inHours < 1
                              ? Colors.red
                              : AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Checkbox(
            value: isCompleted,
            onChanged: (value) {
              // In a real app, update the task status
              setState(() {
                _upcomingTasks[_upcomingTasks.indexWhere((task) => task['title'] == title)]['isCompleted'] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required IconData icon,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                icon,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
