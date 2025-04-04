import 'package:flutter/material.dart';

class FinanceOverviewPage extends StatelessWidget {
  const FinanceOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Finances'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Aperçu'),
              Tab(text: 'Revenus'),
              Tab(text: 'Dépenses'),
            ],
            indicatorColor: Color(0xFFB87333),
            labelColor: Color(0xFFB87333),
          ),
        ),
        body: TabBarView(
          children: [
            _OverviewTab(),
            _IncomeTab(),
            _ExpensesTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Afficher un dialogue pour ajouter une transaction
            _showAddTransactionDialog(context);
          },
          backgroundColor: const Color(0xFFB87333),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    TransactionType selectedType = TransactionType.income;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Type de transaction
            Row(
              children: [
                const Text('Type: '),
                const SizedBox(width: 16),
                DropdownButton<TransactionType>(
                  value: selectedType,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      selectedType = newValue;
                    }
                  },
                  items: TransactionType.values.map((type) {
                    return DropdownMenuItem<TransactionType>(
                      value: type,
                      child: Text(type == TransactionType.income ? 'Revenu' : 'Dépense'),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Titre de la transaction
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Montant
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Montant (€)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                try {
                  final amount = double.parse(amountController.text);
                  // Ajouter la transaction
                  // (à implémenter avec un bloc/repository)
                  Navigator.pop(context);
                  
                  // Afficher un message de confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Transaction ajoutée avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  // Afficher une erreur si le montant n'est pas un nombre valide
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Veuillez entrer un montant valide'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Solde actuel
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Solde actuel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '€ 15,000.00',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB87333),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem('Revenus', '€ 20,000.00', Icons.arrow_upward, Colors.green),
                      _buildSummaryItem('Dépenses', '€ 5,000.00', Icons.arrow_downward, Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Graphique (simulé)
          const Text(
            'Tendance financière',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: const Center(
                child: Text(
                  'Graphique de tendance financière',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Dernières transactions
          const Text(
            'Dernières transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildTransactionItem(
            'Paiement client XYZ',
            DateTime.now().subtract(const Duration(days: 2)),
            1500.0,
            TransactionType.income,
          ),
          _buildTransactionItem(
            'Achat matériel informatique',
            DateTime.now().subtract(const Duration(days: 5)),
            800.0,
            TransactionType.expense,
          ),
          _buildTransactionItem(
            'Service de consultant',
            DateTime.now().subtract(const Duration(days: 8)),
            1200.0,
            TransactionType.income,
          ),
          _buildTransactionItem(
            'Abonnement logiciel',
            DateTime.now().subtract(const Duration(days: 10)),
            50.0,
            TransactionType.expense,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String amount, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(String title, DateTime date, double amount, TransactionType type) {
    final isIncome = type == TransactionType.income;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green : Colors.red,
          child: Icon(
            isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        title: Text(title),
        subtitle: Text(
          '${date.day}/${date.month}/${date.year}',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'} €${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _IncomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text('Tableau des revenus à implémenter'),
    );
  }
}

class _ExpensesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text('Tableau des dépenses à implémenter'),
    );
  }
}

enum TransactionType {
  income,
  expense,
}
