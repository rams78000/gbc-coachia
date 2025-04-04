import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigation vers les paramètres
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte d'accueil
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 24,
                          child: const Text('JD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bonjour, Jean Dupont',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'Bienvenue sur GBC CoachIA',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Discuter avec l\'IA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Navigation vers le chat IA
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Accès rapides
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildFeatureCard(
                  context,
                  'Chat IA',
                  'Posez vos questions',
                  Icons.chat_bubble_outline,
                  Colors.brown[100]!,
                  primaryColor,
                ),
                _buildFeatureCard(
                  context,
                  'Planning',
                  'Gérez votre agenda',
                  Icons.calendar_today,
                  Colors.blue[100]!,
                  Colors.blue[700]!,
                ),
                _buildFeatureCard(
                  context,
                  'Finances',
                  'Suivez vos revenus',
                  Icons.attach_money,
                  Colors.green[100]!,
                  Colors.green[700]!,
                ),
                _buildFeatureCard(
                  context,
                  'Documents',
                  'Générez des docs',
                  Icons.description,
                  Colors.purple[100]!,
                  Colors.purple[700]!,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Activité récente
            const Text(
              'Activité récente',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                title: const Text('Discussion IA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text('Comment optimiser ma TVA ?', style: TextStyle(fontSize: 12)),
                trailing: const Text('Il y a 2h', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: Icon(
                    Icons.attach_money,
                    color: Colors.green[700],
                    size: 20,
                  ),
                ),
                title: const Text('Facture enregistrée', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text('Facture #2023-042', style: TextStyle(fontSize: 12)),
                trailing: const Text('Hier', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat IA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Planning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Finances',
          ),
        ],
        onTap: (index) {
          // Navigation vers les écrans correspondants
        },
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData iconData,
    Color backgroundColor,
    Color iconColor,
  ) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () {
          // Navigation vers la fonctionnalité
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: backgroundColor,
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
