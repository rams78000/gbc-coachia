import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const _DashboardContent(),
    const Placeholder(color: Colors.blue),  // Chatbot
    const Placeholder(color: Colors.green), // Planner
    const Placeholder(color: Colors.amber), // Finance
    const Placeholder(color: Colors.purple), // Documents
    const Placeholder(color: Colors.teal),  // Storage
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GBC CoachIA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Navigation vers les routes appropriées
          switch (index) {
            case 0:
              context.go('/');
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
            case 4:
              context.go('/documents');
              break;
            case 5:
              context.go('/storage');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
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
            icon: Icon(Icons.calendar_today),
            label: 'Planning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Finance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Stockage',
          ),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // En-tête
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: Text(
                        'MD',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour, Marie',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Mardi, 4 Avril',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Résumé de la journée',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      context,
                      Icons.task,
                      '5',
                      'Tâches',
                      Colors.blue,
                    ),
                    _buildStatCard(
                      context,
                      Icons.event,
                      '3',
                      'Rendez-vous',
                      Colors.orange,
                    ),
                    _buildStatCard(
                      context,
                      Icons.attach_money,
                      '2',
                      'Factures',
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Prochains rendez-vous
        _buildSectionTitle(context, 'Prochains rendez-vous', () {
          context.go('/planner');
        }),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAppointmentCard(
                context,
                'Réunion client',
                'Antoine Martin',
                '10:30 - 11:30',
                Colors.blue,
              ),
              _buildAppointmentCard(
                context,
                'Appel projet',
                'Équipe de développement',
                '14:00 - 15:00',
                Colors.purple,
              ),
              _buildAppointmentCard(
                context,
                'Planification stratégique',
                'Direction marketing',
                '16:30 - 17:30',
                Colors.orange,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Tâches prioritaires
        _buildSectionTitle(context, 'Tâches prioritaires', () {
          context.go('/planner');
        }),
        const SizedBox(height: 8),
        _buildTaskItem(
          context,
          'Finaliser la présentation client',
          'Échéance: Aujourd\'hui',
          0.8,
        ),
        _buildTaskItem(
          context,
          'Préparer le rapport financier mensuel',
          'Échéance: Demain',
          0.4,
        ),
        _buildTaskItem(
          context,
          'Réviser le contrat de service',
          'Échéance: 6 Avril',
          0.2,
        ),
        
        const SizedBox(height: 24),
        
        // Aperçu financier
        _buildSectionTitle(context, 'Aperçu financier', () {
          context.go('/finance');
        }),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFinancialSummary(
                      context,
                      'Revenus',
                      '9 600 €',
                      Icons.arrow_upward,
                      Colors.green,
                    ),
                    _buildFinancialSummary(
                      context,
                      'Dépenses',
                      '2 400 €',
                      Icons.arrow_downward,
                      Colors.red,
                    ),
                    _buildFinancialSummary(
                      context,
                      'Solde',
                      '7 200 €',
                      Icons.account_balance,
                      Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Factures à traiter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInvoiceItem(
                  context,
                  'Facture #2023-042',
                  'Client: Techno Solutions',
                  '3 600 €',
                  'En attente',
                ),
                _buildInvoiceItem(
                  context,
                  'Facture #2023-043',
                  'Client: Marketing Expert',
                  '1 200 €',
                  'Payée',
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Suggestions IA
        _buildSectionTitle(context, 'Suggestions de votre assistant IA', () {
          context.go('/chatbot');
        }),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(
                        Icons.assistant,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Suggestions personnalisées',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildAiSuggestion(
                  context,
                  Icons.trending_up,
                  'Analyse des revenus',
                  'Vos revenus ont augmenté de 15% ce mois-ci. Consultez l\'analyse détaillée.',
                ),
                _buildAiSuggestion(
                  context,
                  Icons.schedule,
                  'Optimisation du temps',
                  'Regroupez vos réunions de l\'après-midi pour gagner 2 heures de travail focalisé.',
                ),
                _buildAiSuggestion(
                  context,
                  Icons.description,
                  'Création de documents',
                  'Générez une proposition commerciale basée sur vos projets récents.',
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 32),
      ],
    );
  }
  
  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    VoidCallback onSeeAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('Voir tout'),
        ),
      ],
    );
  }
  
  Widget _buildAppointmentCard(
    BuildContext context,
    String title,
    String with_,
    String time,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              with_,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const Spacer(),
            Text(
              time,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTaskItem(
    BuildContext context,
    String title,
    String deadline,
    double progress,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  deadline,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toInt()}% complété',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFinancialSummary(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          icon,
          color: color,
          size: 16,
        ),
      ],
    );
  }
  
  Widget _buildInvoiceItem(
    BuildContext context,
    String title,
    String client,
    String amount,
    String status, {
    bool isLast = false,
  }) {
    final isStatusPaid = status.toLowerCase() == 'payée';
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      client,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isStatusPaid
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: isStatusPaid ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(),
      ],
    );
  }
  
  Widget _buildAiSuggestion(
    BuildContext context,
    IconData icon,
    String title,
    String description, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
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
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
          ),
      ],
    );
  }
}
