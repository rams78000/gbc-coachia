import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/common/presentation/widgets/navigation_menu.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final goldColor = const Color(0xFFFFD700);

    // Récupérer les infos utilisateur depuis le bloc d'auth
    final authState = context.read<AuthBloc>().state;
    String userName = 'Utilisateur';
    
    if (authState is AuthSuccess && authState.status.isAuthenticated) {
      // Utiliser le mock de données utilisateur pour l'instant
      userName = 'Entrepreneur';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tableau de bord',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec salutation
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor.withOpacity(0.2),
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 35,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bonjour,',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: goldColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: goldColor,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Premium',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Section des cartes rapides
            const Text(
              'Raccourcis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Grille de raccourcis
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                _buildShortcutCard(
                  context,
                  icon: Icons.chat,
                  title: 'Assistant IA',
                  description: 'Posez vos questions',
                  color: Colors.blue,
                  onTap: () => context.push('/chatbot'),
                ),
                _buildShortcutCard(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Planning',
                  description: 'Gérez votre agenda',
                  color: Colors.orange,
                  onTap: () => context.push('/planner'),
                ),
                _buildShortcutCard(
                  context,
                  icon: Icons.assessment,
                  title: 'Finances',
                  description: 'Suivez vos revenus',
                  color: Colors.green,
                  onTap: () => context.push('/finance'),
                ),
                _buildShortcutCard(
                  context,
                  icon: Icons.folder,
                  title: 'Documents',
                  description: 'Accédez à vos fichiers',
                  color: Colors.purple,
                  onTap: () => context.push('/documents'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Section Activité récente
            const Text(
              'Activité récente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Expanded(
              child: ListView(
                children: [
                  _buildActivityItem(
                    icon: Icons.calendar_today,
                    title: 'Réunion client',
                    subtitle: 'Aujourd\'hui, 14:00',
                    color: Colors.orange,
                  ),
                  _buildActivityItem(
                    icon: Icons.assessment,
                    title: 'Facture envoyée',
                    subtitle: 'Hier, 10:25',
                    color: Colors.green,
                  ),
                  _buildActivityItem(
                    icon: Icons.chat,
                    title: 'Question IA',
                    subtitle: 'Comment optimiser ma trésorerie ?',
                    color: Colors.blue,
                  ),
                  _buildActivityItem(
                    icon: Icons.folder,
                    title: 'Document ajouté',
                    subtitle: 'Contrat_Client_A.pdf',
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavigationMenu(currentIndex: 0),
    );
  }

  Widget _buildShortcutCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
