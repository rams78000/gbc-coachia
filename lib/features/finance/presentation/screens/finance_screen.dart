import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/repositories/finance_repository.dart';
import '../bloc/finance_bloc.dart';

/// Écran des finances
class FinanceScreen extends StatefulWidget {
  /// Constructeur
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Period _selectedPeriod = Period.month;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Charger les transactions au démarrage
    BlocProvider.of<FinanceBloc>(context).add(const LoadTransactions());
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Finances',
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showAddTransactionDialog(context),
        ),
      ],
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                text: 'Transactions',
                icon: Icon(Icons.receipt_long),
              ),
              Tab(
                text: 'Statistiques',
                icon: Icon(Icons.analytics),
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                BlocProvider.of<FinanceBloc>(context).add(const LoadTransactions());
              } else {
                BlocProvider.of<FinanceBloc>(context).add(LoadStats(period: _selectedPeriod));
              }
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Onglet des transactions
                _TransactionsTab(),
                
                // Onglet des statistiques
                _StatsTab(
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: (period) {
                    setState(() {
                      _selectedPeriod = period;
                    });
                    BlocProvider.of<FinanceBloc>(context).add(LoadStats(period: period));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _TransactionFormDialog(
        onSave: (transaction) {
          BlocProvider.of<FinanceBloc>(context).add(AddTransaction(transaction: transaction));
        },
      ),
    );
  }
}

/// Widget pour l'onglet des transactions
class _TransactionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is FinanceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionsLoaded) {
          final transactions = state.transactions;
          final currentBalance = state.currentBalance;
          
          return Column(
            children: [
              // Carte de solde
              _BalanceCard(balance: currentBalance),
              
              // Liste des transactions
              Expanded(
                child: transactions.isEmpty
                    ? const _EmptyTransactions()
                    : ListView.builder(
                        itemCount: transactions.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return _TransactionCard(
                            transaction: transaction,
                            onTap: () => _showTransactionDetails(context, transaction),
                          );
                        },
                      ),
              ),
            ],
          );
        } else if (state is FinanceError) {
          return Center(
            child: Text(
              'Erreur: ${state.message}',
              style: TextStyle(color: Colors.red[700]),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _TransactionDetailsBottomSheet(transaction: transaction),
    );
  }
}

/// Widget pour l'onglet des statistiques
class _StatsTab extends StatelessWidget {
  final Period selectedPeriod;
  final Function(Period) onPeriodChanged;

  const _StatsTab({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Charger les statistiques si elles ne sont pas déjà chargées
    if (context.read<FinanceBloc>().state is! StatsLoaded) {
      context.read<FinanceBloc>().add(LoadStats(period: selectedPeriod));
    }
    
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is FinanceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StatsLoaded) {
          final stats = state.stats;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sélecteur de période
                _PeriodSelector(
                  selectedPeriod: selectedPeriod,
                  onPeriodChanged: onPeriodChanged,
                ),
                const SizedBox(height: 16),
                
                // Résumé financier
                _SummaryCards(stats: stats),
                const SizedBox(height: 24),
                
                // Graphique d'évolution
                Text(
                  'Évolution',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 250,
                  child: _TrendsChart(
                    incomeTrend: stats.incomeTrend,
                    expenseTrend: stats.expenseTrend,
                    period: selectedPeriod,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Répartition des dépenses
                if (stats.expensesByCategory.isNotEmpty) ...[
                  Text(
                    'Répartition des dépenses',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 250,
                    child: _ExpensesChart(expensesByCategory: stats.expensesByCategory),
                  ),
                ],
              ],
            ),
          );
        } else if (state is FinanceError) {
          return Center(
            child: Text(
              'Erreur: ${state.message}',
              style: TextStyle(color: Colors.red[700]),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

/// Widget de sélection de période
class _PeriodSelector extends StatelessWidget {
  final Period selectedPeriod;
  final Function(Period) onPeriodChanged;

  const _PeriodSelector({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Period>(
      segments: const [
        ButtonSegment<Period>(
          value: Period.week,
          label: Text('Semaine'),
        ),
        ButtonSegment<Period>(
          value: Period.month,
          label: Text('Mois'),
        ),
        ButtonSegment<Period>(
          value: Period.year,
          label: Text('Année'),
        ),
      ],
      selected: {selectedPeriod},
      onSelectionChanged: (Set<Period> selection) {
        onPeriodChanged(selection.first);
      },
    );
  }
}

/// Widget pour les cartes de résumé
class _SummaryCards extends StatelessWidget {
  final FinanceStats stats;

  const _SummaryCards({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Revenus',
                amount: stats.totalIncome,
                icon: Icons.arrow_upward,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: 'Dépenses',
                amount: stats.totalExpenses,
                icon: Icons.arrow_downward,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SummaryCard(
          title: 'Solde net',
          amount: stats.netBalance,
          icon: Icons.account_balance_wallet,
          color: stats.netBalance >= 0 ? Colors.blue : Colors.red,
          large: true,
        ),
      ],
    );
  }
}

/// Widget pour une carte de résumé
class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final bool large;

  const _SummaryCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(large ? 20 : 16),
        child: Column(
          crossAxisAlignment: large ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: large ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: large ? 24 : 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: large
                      ? theme.textTheme.titleLarge
                      : theme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: large ? 16 : 8),
            Text(
              formatter.format(amount),
              style: large
                  ? theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    )
                  : theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              textAlign: large ? TextAlign.center : TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour le graphique d'évolution
class _TrendsChart extends StatelessWidget {
  final List<DataPoint> incomeTrend;
  final List<DataPoint> expenseTrend;
  final Period period;

  const _TrendsChart({
    Key? key,
    required this.incomeTrend,
    required this.expenseTrend,
    required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= incomeTrend.length) {
                  return const SizedBox();
                }
                
                String text = '';
                switch (period) {
                  case Period.week:
                    text = DateFormat.E().format(incomeTrend[value.toInt()].date);
                    break;
                  case Period.month:
                    text = incomeTrend[value.toInt()].date.day.toString();
                    break;
                  case Period.year:
                    text = DateFormat.MMM().format(incomeTrend[value.toInt()].date);
                    break;
                }
                
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0) {
                  return const SizedBox();
                }
                
                final formatter = NumberFormat.compact();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    formatter.format(value),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          // Ligne des revenus
          LineChartBarData(
            spots: _getSpots(incomeTrend),
            isCurved: true,
            barWidth: 3,
            color: Colors.green,
            dotData: FlDotData(show: false),
          ),
          // Ligne des dépenses
          LineChartBarData(
            spots: _getSpots(expenseTrend),
            isCurved: true,
            barWidth: 3,
            color: Colors.red,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getSpots(List<DataPoint> dataPoints) {
    return List.generate(
      dataPoints.length,
      (index) => FlSpot(index.toDouble(), dataPoints[index].value),
    );
  }
}

/// Widget pour le graphique des dépenses par catégorie
class _ExpensesChart extends StatelessWidget {
  final Map<String, double> expensesByCategory;

  const _ExpensesChart({
    Key? key,
    required this.expensesByCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    
    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: _getSections(),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    // Trier les catégories par montant décroissant
    final sortedCategories = expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Calculer le total des dépenses
    final totalExpenses = expensesByCategory.values.fold(0.0, (sum, value) => sum + value);
    
    // Générer une couleur pour chaque catégorie
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
    ];
    
    return List.generate(
      sortedCategories.length,
      (index) {
        final category = sortedCategories[index];
        final percent = (category.value / totalExpenses) * 100;
        final formatter = NumberFormat.compact();
        
        return PieChartSectionData(
          color: colors[index % colors.length],
          value: category.value,
          title: '${category.key}\n${percent.toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

/// Widget pour la carte de solde
class _BalanceCard extends StatelessWidget {
  final double balance;

  const _BalanceCard({
    Key? key,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor,
              theme.primaryColorDark,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'Solde actuel',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              formatter.format(balance),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour afficher une transaction
class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const _TransactionCard({
    Key? key,
    required this.transaction,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          transaction.category,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat.yMMMd().format(transaction.date),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Montant
              Text(
                formatter.format(transaction.amount),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Feuille de détails de transaction
class _TransactionDetailsBottomSheet extends StatelessWidget {
  final Transaction transaction;

  const _TransactionDetailsBottomSheet({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barre de poignée
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // En-tête
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isIncome ? 'Revenu' : 'Dépense',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMMd().format(transaction.date),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Boutons d'action
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pop(context);
                  _showEditTransactionDialog(context, transaction);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  _showDeleteConfirmation(context, transaction);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Montant
          Center(
            child: Text(
              formatter.format(transaction.amount),
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          // Détails
          _DetailItem(
            label: 'Description',
            value: transaction.description,
          ),
          const SizedBox(height: 16),
          _DetailItem(
            label: 'Catégorie',
            value: transaction.category,
          ),
          const SizedBox(height: 16),
          _DetailItem(
            label: 'Date',
            value: DateFormat.yMMMMd().format(transaction.date),
          ),
          const SizedBox(height: 24),
          
          // Bouton fermer
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Fermer',
              onPressed: () => Navigator.pop(context),
              isPrimary: false,
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showEditTransactionDialog(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => _TransactionFormDialog(
        transaction: transaction,
        onSave: (updatedTransaction) {
          context.read<FinanceBloc>().add(UpdateTransaction(transaction: updatedTransaction));
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la transaction'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer cette transaction de ${transaction.description} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer la boîte de dialogue
              Navigator.pop(context); // Fermer la feuille de détails
              context.read<FinanceBloc>().add(DeleteTransaction(id: transaction.id));
            },
            child: const Text('Supprimer'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}

/// Widget pour un élément de détail
class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Dialogue de formulaire de transaction
class _TransactionFormDialog extends StatefulWidget {
  final Transaction? transaction;
  final Function(Transaction) onSave;

  const _TransactionFormDialog({
    Key? key,
    this.transaction,
    required this.onSave,
  }) : super(key: key);

  @override
  State<_TransactionFormDialog> createState() => _TransactionFormDialogState();
}

class _TransactionFormDialogState extends State<_TransactionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late DateTime _selectedDate;
  late TransactionType _selectedType;
  String _selectedCategory = 'Autre';

  final List<String> _incomeCategories = [
    'Salaire',
    'Freelance',
    'Investissement',
    'Remboursement',
    'Vente',
    'Autre',
  ];

  final List<String> _expenseCategories = [
    'Nourriture',
    'Transport',
    'Logement',
    'Loisirs',
    'Santé',
    'Éducation',
    'Vêtements',
    'Voyage',
    'Équipement',
    'Services',
    'Taxes',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialiser les valeurs à partir de la transaction existante ou par défaut
    if (widget.transaction != null) {
      _descriptionController = TextEditingController(text: widget.transaction!.description);
      _amountController = TextEditingController(text: widget.transaction!.amount.toString());
      _selectedDate = widget.transaction!.date;
      _selectedType = widget.transaction!.type;
      _selectedCategory = widget.transaction!.category;
    } else {
      _descriptionController = TextEditingController();
      _amountController = TextEditingController();
      _selectedDate = DateTime.now();
      _selectedType = TransactionType.expense;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    
    return AlertDialog(
      title: Text(isEditing ? 'Modifier la transaction' : 'Ajouter une transaction'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type de transaction
              Text(
                'Type de transaction',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment<TransactionType>(
                    value: TransactionType.expense,
                    label: Text('Dépense'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment<TransactionType>(
                    value: TransactionType.income,
                    label: Text('Revenu'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (Set<TransactionType> newSelection) {
                  setState(() {
                    _selectedType = newSelection.first;
                    // Réinitialiser la catégorie si le type change
                    _selectedCategory = _selectedType == TransactionType.income
                        ? _incomeCategories.first
                        : _expenseCategories.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Ex: Courses alimentaires',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Montant
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  hintText: 'Ex: 42.50',
                  border: OutlineInputBorder(),
                  prefixText: '€ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un montant';
                  }
                  try {
                    final amount = double.parse(value.replaceAll(',', '.'));
                    if (amount <= 0) {
                      return 'Le montant doit être supérieur à 0';
                    }
                  } catch (e) {
                    return 'Veuillez entrer un montant valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),
              
              // Catégorie
              Text(
                'Catégorie',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (_selectedType == TransactionType.income
                        ? _incomeCategories
                        : _expenseCategories)
                    .map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _saveTransaction,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final amountValue = double.parse(_amountController.text.replaceAll(',', '.'));
      
      final transaction = Transaction(
        id: widget.transaction?.id ?? const Uuid().v4(),
        description: _descriptionController.text,
        amount: amountValue,
        date: _selectedDate,
        type: _selectedType,
        category: _selectedCategory,
      );
      
      widget.onSave(transaction);
      Navigator.pop(context);
    }
  }
}

/// Widget pour afficher un état vide
class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune transaction',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 260,
            child: Text(
              'Ajoutez votre première transaction en cliquant sur le bouton +',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Ajouter une transaction',
            icon: Icons.add,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _TransactionFormDialog(
                  onSave: (transaction) {
                    context.read<FinanceBloc>().add(AddTransaction(transaction: transaction));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
