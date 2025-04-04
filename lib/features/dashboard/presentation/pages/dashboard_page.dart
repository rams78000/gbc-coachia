import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../chatbot/presentation/pages/chatbot_page.dart';
import '../../../finance/presentation/pages/finance_overview_page.dart';
import '../../../planner/presentation/pages/planner_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardHomeTab(),
    const ChatbotPage(),
    const PlannerPage(),
    const FinanceOverviewPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFB87333),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBar.Item(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Tableau de bord',
          ),
          BottomNavigationBar.Item(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'CoachIA',
          ),
          BottomNavigationBar.Item(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Planning',
          ),
          BottomNavigationBar.Item(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Finances',
          ),
          BottomNavigationBar.Item(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}

class DashboardHomeTab extends StatelessWidget {
  const DashboardHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          // Action pour se déconnecter
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Afficher une boîte de dialogue pour confirmer la déconnexion
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Se déconnecter'),
                  content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<AuthBloc>().add(const AuthLoggedOut());
                      },
                      child: const Text('Se déconnecter'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Message de bienvenue
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFFB87333),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenue',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Bon retour parmi nous'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'CoachIA est votre assistant business intelligent.',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Section CoachIA
          _buildSectionTitle(context, 'Assistant IA'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = 1; // Aller à l'onglet CoachIA
              });
            },
            child: Card(
              color: const Color(0xFFFFD700).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB87333),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.chat_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discuter avec CoachIA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Obtenez des conseils et des réponses à vos questions business',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Section Planning
          _buildSectionTitle(context, 'Planning'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = 2; // Aller à l'onglet Planning
              });
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.event_note, color: Color(0xFFB87333)),
                        SizedBox(width: 8),
                        Text(
                          'Prochains rendez-vous',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Aucun rendez-vous à venir'),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 2; // Aller à l'onglet Planning
                        });
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Ajouter un rendez-vous'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Section Finances
          _buildSectionTitle(context, 'Finances'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = 3; // Aller à l'onglet Finances
              });
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.euro, color: Color(0xFFB87333)),
                        SizedBox(width: 8),
                        Text(
                          'Aperçu financier',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Revenus du mois'),
                        Text('0 €'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Dépenses du mois'),
                        Text('0 €'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Balance',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '0 €',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void setState(VoidCallback callback) {
    // Cette méthode est nécessaire car nous utilisons un StatelessWidget
    // mais avons besoin de changer l'index dans le StatefulWidget parent
    final state = context.findAncestorStateOfType<_DashboardPageState>();
    if (state != null) {
      state.setState(callback);
    }
  }
}
