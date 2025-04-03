import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';

/// Finance page
class FinancePage extends StatefulWidget {
  /// Constructor
  const FinancePage({Key? key}) : super(key: key);

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Demo data for UI
  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Paiement client ABC',
      'amount': 1250.0,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'type': 'income',
      'category': 'Services',
    },
    {
      'title': 'Abonnement logiciel',
      'amount': 49.99,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'type': 'expense',
      'category': 'Logiciels',
    },
    {
      'title': 'Matériel informatique',
      'amount': 799.99,
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'type': 'expense',
      'category': 'Équipement',
    },
    {
      'title': 'Consultation client XYZ',
      'amount': 850.0,
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'type': 'income',
      'category': 'Services',
    },
    {
      'title': 'Facture internet',
      'amount': 59.90,
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'type': 'expense',
      'category': 'Télécommunications',
    },
    {
      'title': 'Fournitures de bureau',
      'amount': 120.50,
      'date': DateTime.now().subtract(const Duration(days: 12)),
      'type': 'expense',
      'category': 'Fournitures',
    },
    {
      'title': 'Paiement client DEF',
      'amount': 1800.0,
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'type': 'income',
      'category': 'Services',
    },
  ];

  final List<Map<String, dynamic>> _invoices = [
    {
      'client': 'ABC Company',
      'amount': 1250.0,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'Payée',
      'invoiceNumber': 'INV-2023-001',
    },
    {
      'client': 'XYZ Corporation',
      'amount': 850.0,
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'status': 'Payée',
      'invoiceNumber': 'INV-2023-002',
    },
    {
      'client': 'DEF Industries',
      'amount': 1800.0,
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'status': 'Payée',
      'invoiceNumber': 'INV-2023-003',
    },
    {
      'client': 'GHI Services',
      'amount': 950.0,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'En attente',
      'invoiceNumber': 'INV-2023-004',
    },
    {
      'client': 'JKL Consulting',
      'amount': 2200.0,
      'date': DateTime.now(),
      'status': 'En attente',
      'invoiceNumber': 'INV-2023-005',
    },
  ];

  final List<Map<String, dynamic>> _budgetCategories = [
    {
      'name': 'Services',
      'budgeted': 5000.0,
      'actual': 3900.0,
      'color': Colors.blue,
    },
    {
      'name': 'Logiciels & Abonnements',
      'budgeted': 300.0,
      'actual': 280.0,
      'color': Colors.purple,
    },
    {
      'name': 'Équipement',
      'budgeted': 1000.0,
      'actual': 799.99,
      'color': Colors.orange,
    },
    {
      'name': 'Marketing',
      'budgeted': 800.0,
      'actual': 650.0,
      'color': Colors.green,
    },
    {
      'name': 'Fournitures',
      'budgeted': 200.0,
      'actual': 120.50,
      'color': Colors.red,
    },
    {
      'name': 'Télécommunications',
      'budgeted': 150.0,
      'actual': 130.0,
      'color': Colors.teal,
    },
  ];

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

  double get _totalIncome {
    return _transactions
        .where((t) => t['type'] == 'income')
        .fold(0.0, (sum, transaction) => sum + transaction['amount']);
  }

  double get _totalExpenses {
    return _transactions
        .where((t) => t['type'] == 'expense')
        .fold(0.0, (sum, transaction) => sum + transaction['amount']);
  }

  double get _balance {
    return _totalIncome - _totalExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finances'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aperçu'),
            Tab(text: 'Transactions'),
            Tab(text: 'Factures'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add transaction/invoice dialog
          final currentTab = _tabController.index;
          if (currentTab == 1) {
            _showAddTransactionDialog();
          } else if (currentTab == 2) {
            _showAddInvoiceDialog();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Overview tab
          _buildOverviewTab(),

          // Transactions tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return _buildTransactionCard(transaction);
            },
          ),

          // Invoices tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _invoices.length,
            itemBuilder: (context, index) {
              final invoice = _invoices[index];
              return _buildInvoiceCard(invoice);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financial summary
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Résumé Financier',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryItem(
                        title: 'Revenus',
                        amount: _totalIncome,
                        color: Colors.green,
                        icon: Icons.arrow_upward,
                      ),
                    ),
                    Expanded(
                      child: _buildSummaryItem(
                        title: 'Dépenses',
                        amount: _totalExpenses,
                        color: Colors.red,
                        icon: Icons.arrow_downward,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Solde',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${_balance.toStringAsFixed(2)} €',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _balance >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Budget overview
          Text(
            'Budget Mensuel',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _budgetCategories.length,
            itemBuilder: (context, index) {
              final category = _budgetCategories[index];
              return _buildBudgetItem(category);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Recent transactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions Récentes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  _tabController.animateTo(1);
                },
                child: const Text('Voir tout'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _transactions.length < 3 ? _transactions.length : 3,
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return _buildTransactionCard(transaction);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Exporter le rapport',
                  icon: Icons.download,
                  variant: AppButtonVariant.outline,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rapport exporté')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  label: 'Analyser les finances',
                  icon: Icons.analytics,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Analyse en cours...')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${amount.toStringAsFixed(2)} €',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetItem(Map<String, dynamic> category) {
    final progress = category['actual'] / category['budgeted'];
    final color = category['color'] as Color;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                '${category['actual'].toStringAsFixed(2)} € / ${category['budgeted'].toStringAsFixed(2)} €',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress > 1.0 ? 1.0 : progress,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 1.0 ? Colors.red : color,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isIncome = transaction['type'] == 'income';
    final dateFormat = DateFormat('dd MMM yyyy');
    final formattedDate = dateFormat.format(transaction['date']);
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isIncome ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome ? Icons.arrow_upward : Icons.arrow_downward,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      transaction['category'],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.circle,
                      size: 4,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'} ${transaction['amount'].toStringAsFixed(2)} €',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> invoice) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final formattedDate = dateFormat.format(invoice['date']);
    final isPaid = invoice['status'] == 'Payée';
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice['client'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    invoice['invoiceNumber'],
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  invoice['status'],
                  style: TextStyle(
                    color: isPaid ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date: $formattedDate',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                '${invoice['amount'].toStringAsFixed(2)} €',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!isPaid)
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Rappel',
                    icon: Icons.send,
                    variant: AppButtonVariant.outline,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rappel envoyé au client')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    label: 'Marquer comme payée',
                    icon: Icons.check_circle,
                    onPressed: () {
                      setState(() {
                        invoice['status'] = 'Payée';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Facture marquée comme payée')),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une transaction'),
        content: const SizedBox(
          height: 300,
          child: Text('Formulaire d\'ajout de transaction (à implémenter)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction ajoutée')),
              );
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddInvoiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une facture'),
        content: const SizedBox(
          height: 300,
          child: Text('Formulaire d\'ajout de facture (à implémenter)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Facture ajoutée')),
              );
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
