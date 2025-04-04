import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        backgroundColor: const Color(0xFFB87333),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(context),
            const SizedBox(height: 24),
            _buildFeatureGrid(context),
            const SizedBox(height: 24),
            _buildRecentActivitySection(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFFB87333),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat IA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Planning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Finances',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.go('/chatbot');
              break;
            case 2:
              context.go('/planner');
              break;
            case 3:
              context.go('/finance');
              break;
          }
        },
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFB87333),
                  radius: 24,
                  child: Text(
                    'JD',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour, Jean Dupont',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Bienvenue sur GBC CoachIA',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Votre assistant IA est prêt à vous aider dans la gestion de votre entreprise.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.go('/chatbot'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB87333),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.chat),
              label: const Text('Discuter avec l\'IA'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      {
        'icon': Icons.chat_outlined,
        'title': 'Chat IA',
        'description': 'Posez vos questions et obtenez des conseils.',
        'route': '/chatbot',
        'color': const Color(0xFFB87333),
      },
      {
        'icon': Icons.calendar_month_outlined,
        'title': 'Planning',
        'description': 'Gérez votre agenda et vos tâches.',
        'route': '/planner',
        'color': const Color(0xFF336699),
      },
      {
        'icon': Icons.bar_chart_outlined,
        'title': 'Finances',
        'description': 'Suivez vos revenus et dépenses.',
        'route': '/finance',
        'color': const Color(0xFF669933),
      },
      {
        'icon': Icons.description_outlined,
        'title': 'Documents',
        'description': 'Générez des documents professionnels.',
        'route': '/documents',
        'color': const Color(0xFF993366),
      },
      {
        'icon': Icons.folder_outlined,
        'title': 'Stockage',
        'description': 'Organisez vos fichiers importants.',
        'route': '/storage',
        'color': const Color(0xFF996633),
      },
      {
        'icon': Icons.settings_outlined,
        'title': 'Paramètres',
        'description': 'Personnalisez votre expérience.',
        'route': '/settings',
        'color': const Color(0xFF666666),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return InkWell(
          onTap: () => context.go(feature['route'] as String),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    feature['icon'] as IconData,
                    size: 32,
                    color: feature['color'] as Color,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feature['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature['description'] as String,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentActivitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activité récente',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final activities = [
                {
                  'icon': Icons.chat_outlined,
                  'title': 'Discussion IA',
                  'subtitle': 'Comment optimiser ma TVA ?',
                  'time': 'Il y a 2 heures',
                  'color': const Color(0xFFB87333),
                },
                {
                  'icon': Icons.task_outlined,
                  'title': 'Tâche ajoutée',
                  'subtitle': 'Préparer facture pour client X',
                  'time': 'Hier',
                  'color': const Color(0xFF336699),
                },
                {
                  'icon': Icons.receipt_outlined,
                  'title': 'Facture créée',
                  'subtitle': 'Facture n°2023-042',
                  'time': 'Il y a 2 jours',
                  'color': const Color(0xFF669933),
                },
              ];

              final activity = activities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: (activity['color'] as Color).withOpacity(0.2),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: activity['color'] as Color,
                    size: 20,
                  ),
                ),
                title: Text(activity['title'] as String),
                subtitle: Text(activity['subtitle'] as String),
                trailing: Text(
                  activity['time'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
