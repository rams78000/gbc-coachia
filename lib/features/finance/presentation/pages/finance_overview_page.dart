import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinanceOverviewPage extends StatefulWidget {
  const FinanceOverviewPage({Key? key}) : super(key: key);

  @override
  State<FinanceOverviewPage> createState() => _FinanceOverviewPageState();
}

class _FinanceOverviewPageState extends State<FinanceOverviewPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _selectedPeriod = 0; // 0: Cette année, 1: Ce mois, 2: Cette semaine
  final List<String> _periods = ['Cette année', 'Ce mois', 'Cette semaine'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finances'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigation retour
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aperçu'),
            Tab(text: 'Transactions'),
            Tab(text: 'Rapports'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(primaryColor),
          _buildTransactionsTab(),
          _buildReportsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
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

  Widget _buildOverviewTab(Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sélecteur de période
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_periods[_selectedPeriod], style: const TextStyle(fontSize: 16)),
                  Icon(Icons.keyboard_arrow_down, color: primaryColor),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Résumé des chiffres
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Revenus',
                  '74.800 €',
                  Colors.green,
                  Icons.arrow_upward,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  'Dépenses',
                  '48.500 €',
                  Colors.red,
                  Icons.arrow_downward,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  'Net',
                  '26.300 €',
                  primaryColor,
                  Icons.account_balance,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Graphique de revenus et dépenses
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Revenus et dépenses',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Évolution mensuelle',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 12000,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const List<String> titles = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    titles[value.toInt()],
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                );
                              },
                              reservedSize: 30,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value == 0) return const SizedBox();
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    '${value ~/ 1000}k€',
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                );
                              },
                              reservedSize: 40,
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 4000,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          ),
                        ),
                        barGroups: [
                          for (int i = 0; i < 12; i++)
                            BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: 5000 + (i * 500),
                                  color: Colors.green,
                                  width: 8,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Revenus', Colors.green),
                      const SizedBox(width: 24),
                      _buildLegendItem('Dépenses', Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Transactions récentes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions récentes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Voir tout',
                style: TextStyle(color: primaryColor, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTransactionItem(
            'Facture #2023-042',
            'Ventes • 02/04/2023',
            '+1.250 €',
            Colors.green,
            Icons.description,
            Colors.green[100]!,
          ),
          const SizedBox(height: 8),
          _buildTransactionItem(
            'Abonnement SaaS',
            'Services • 01/04/2023',
            '-89,99 €',
            Colors.red,
            Icons.business_center,
            Colors.red[100]!,
          ),
          const SizedBox(height: 8),
          _buildTransactionItem(
            'Consultation client',
            'Honoraires • 28/03/2023',
            '+750 €',
            Colors.green,
            Icons.people,
            Colors.green[100]!,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return const Center(
      child: Text('Liste des transactions (en développement)'),
    );
  }

  Widget _buildReportsTab() {
    return const Center(
      child: Text('Rapports financiers (en développement)'),
    );
  }

  Widget _buildSummaryCard(String title, String amount, Color iconColor, IconData iconData) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, size: 16, color: iconColor),
                ),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionItem(
    String title,
    String subtitle,
    String amount,
    Color amountColor,
    IconData iconData,
    Color iconBackgroundColor,
  ) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconBackgroundColor,
              radius: 20,
              child: Icon(iconData, color: amountColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: amountColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
