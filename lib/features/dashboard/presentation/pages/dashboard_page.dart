import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gbc_coachia/config/router/app_router.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';

/// Page du tableau de bord
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Vérifier l'état d'authentification
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      context.read<AuthBloc>().add(CheckAuthStatus());
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation basée sur l'index sélectionné
    switch (index) {
      case 0:
        // Déjà sur le dashboard
        break;
      case 1:
        context.push(AppRoutes.chatbot);
        break;
      case 2:
        context.push(AppRoutes.planner);
        break;
      case 3:
        context.push(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tableau de bord'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // TODO: Implémenter les notifications
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Text(
                            user.initials,
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.smallSpacing),
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard_outlined),
                    title: const Text('Tableau de bord'),
                    selected: _selectedIndex == 0,
                    onTap: () {
                      _onItemTapped(0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.psychology_alt_outlined),
                    title: const Text('Coach IA'),
                    selected: _selectedIndex == 1,
                    onTap: () {
                      _onItemTapped(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Planificateur'),
                    selected: _selectedIndex == 2,
                    onTap: () {
                      _onItemTapped(2);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined),
                    title: const Text('Finances'),
                    onTap: () {
                      context.push(AppRoutes.finance);
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Paramètres'),
                    onTap: () {
                      // TODO: Implémenter les paramètres
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Déconnexion'),
                    onTap: () {
                      context.read<AuthBloc>().add(LogoutUser());
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            body: const _DashboardContent(),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  label: 'Accueil',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.psychology_alt_outlined),
                  label: 'Coach IA',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  label: 'Planner',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profil',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        }
        
        // État de chargement ou non authentifié
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

/// Contenu principal du tableau de bord
class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bannière de bienvenue
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundColor: AppTheme.primaryColor,
                              child: Icon(
                                Icons.psychology_alt,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacing),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bonjour, ${state.user.prenom ?? state.user.nom}',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'Bienvenue dans votre espace personnel',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacing),
                        const Text(
                          'Que souhaitez-vous faire aujourd\'hui ?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing),
                
                // Statistiques rapides
                Text(
                  'Aperçu rapide',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.smallSpacing),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppTheme.spacing,
                  mainAxisSpacing: AppTheme.spacing,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _StatCard(
                      icon: Icons.task_alt,
                      title: 'Tâches',
                      value: '3',
                      subtitle: 'à faire aujourd\'hui',
                      color: AppTheme.primaryColor,
                      onTap: () => context.push(AppRoutes.planner),
                    ),
                    _StatCard(
                      icon: Icons.account_balance_wallet,
                      title: 'Finances',
                      value: '2 500 €',
                      subtitle: 'revenus ce mois',
                      color: AppTheme.successColor,
                      onTap: () => context.push(AppRoutes.finance),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing),
                
                // Accès rapide
                Text(
                  'Accès rapide',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.smallSpacing),
                Card(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.psychology_alt,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        title: const Text('Consulter mon coach IA'),
                        subtitle: const Text('Conseils personnalisés et assistance'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(AppRoutes.chatbot),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_calendar,
                            color: AppTheme.accentColor,
                          ),
                        ),
                        title: const Text('Planifier ma semaine'),
                        subtitle: const Text('Organisez votre temps efficacement'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(AppRoutes.planner),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.article,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                        title: const Text('Générer un document'),
                        subtitle: const Text('Factures, devis, et plus'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Implémenter la génération de documents
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacing),
                
                // Conseils du jour
                Text(
                  'Conseil du jour',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.smallSpacing),
                Card(
                  color: AppTheme.infoColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.lightbulb,
                              color: AppTheme.infoColor,
                            ),
                            const SizedBox(width: AppTheme.smallSpacing),
                            Text(
                              'Astuce pour entrepreneurs',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.smallSpacing),
                        const Text(
                          'Planifiez 30 minutes chaque matin pour définir vos priorités du jour. Cette habitude peut augmenter votre productivité de 25%.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

/// Carte de statistique pour le tableau de bord
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.more_vert,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.smallSpacing),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
