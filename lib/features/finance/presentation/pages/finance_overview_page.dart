import 'package:flutter/material.dart';

/// Page de gestion financière
class FinanceOverviewPage extends StatelessWidget {
  const FinanceOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finances'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(context),
            const SizedBox(height: 20),
            Text(
              'Résumé des dépenses',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            _buildExpensesSummary(),
            const SizedBox(height: 20),
            Text(
              'Transactions récentes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            _buildRecentTransactionsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Solde actuel',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '€12,458.50',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBalanceInfoItem(
                  context,
                  Icons.arrow_downward,
                  'Revenus',
                  '€8,245.00',
                  Colors.green,
                ),
                _buildBalanceInfoItem(
                  context,
                  Icons.arrow_upward,
                  'Dépenses',
                  '€3,125.75',
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceInfoItem(BuildContext context, IconData icon,
      String title, String amount, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        Text(
          amount,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildExpensesSummary() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: Center(
            child: Text('Graphique des dépenses ici'),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsList() {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.shopping_bag, color: Colors.blue),
            ),
            title: Text('Transaction ${index + 1}'),
            subtitle: Text('Il y a ${index + 1} jours'),
            trailing: Text(
              '-€${(index + 1) * 15}.00',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
