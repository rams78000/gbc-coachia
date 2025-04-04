import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/finance/domain/entities/transaction.dart';
import 'package:gbc_coachia/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class FinanceOverviewPage extends StatefulWidget {
  const FinanceOverviewPage({super.key});

  @override
  State<FinanceOverviewPage> createState() => _FinanceOverviewPageState();
}

class _FinanceOverviewPageState extends State<FinanceOverviewPage> {
  @override
  void initState() {
    super.initState();
    // Charger les transactions au démarrage de la page
    context.read<FinanceBloc>().add(LoadTransactions());
    // Calculer les résumés financiers
    context.read<FinanceBloc>().add(const CalculateFinancialSummary());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finances'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FinanceBloc>().add(LoadTransactions());
          context.read<FinanceBloc>().add(const CalculateFinancialSummary());
        },
        child: BlocBuilder<FinanceBloc, FinanceState>(
          builder: (context, state) {
            if (state is TransactionsLoading || state is FinanceInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TransactionsError) {
              return Center(
                child: Text('Erreur: ${state.message}'),
              );
            } else if (state is TransactionsLoaded) {
              final transactions = state.transactions;
              return transactions.isEmpty
                  ? _buildEmptyState(context)
                  : _buildTransactionsOverview(context, transactions);
            } else {
              return const Center(
                child: Text('État inconnu. Veuillez réessayer.'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransactionDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucune transaction',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ajoutez votre première transaction\nen utilisant le bouton +',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _showAddTransactionDialog(context);
            },
            child: const Text('Ajouter une transaction'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsOverview(
    BuildContext context,
    List<Transaction> transactions,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFinancialSummary(context),
            const SizedBox(height: 24),
            const Text(
              'Revenus vs Dépenses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildChart(context, transactions),
            ),
            const SizedBox(height: 24),
            const Text(
              'Transactions récentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...transactions
                .take(5) // Afficher seulement les 5 dernières transactions
                .map((transaction) =>
                    _buildTransactionItem(context, transaction, screenWidth))
                .toList(),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Naviguer vers la liste complète des transactions
                },
                child: const Text('Voir toutes les transactions'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is FinancialSummaryLoaded) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem(
                      context,
                      'Revenus',
                      state.totalIncome,
                      Colors.green,
                    ),
                    _buildSummaryItem(
                      context,
                      'Dépenses',
                      state.totalExpenses,
                      Colors.red,
                    ),
                  ],
                ),
                const Divider(height: 32),
                _buildSummaryItem(
                  context,
                  'Solde',
                  state.balance,
                  state.balance >= 0 ? Colors.green : Colors.red,
                  isTotal: true,
                ),
              ],
            ),
          );
        } else if (state is FinancialSummaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FinancialSummaryError) {
          return Center(
            child: Text('Erreur: ${state.message}'),
          );
        } else {
          // Fallback data (zero values) when no financial summary is loaded
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem(
                      context,
                      'Revenus',
                      0,
                      Colors.green,
                    ),
                    _buildSummaryItem(
                      context,
                      'Dépenses',
                      0,
                      Colors.red,
                    ),
                  ],
                ),
                const Divider(height: 32),
                _buildSummaryItem(
                  context,
                  'Solde',
                  0,
                  Colors.green,
                  isTotal: true,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    double amount,
    Color color, {
    bool isTotal = false,
  }) {
    final formatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '€',
      decimalDigits: 2,
    );

    return Expanded(
      child: Column(
        crossAxisAlignment:
            isTotal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatter.format(amount),
            style: TextStyle(
              fontSize: isTotal ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<Transaction> transactions) {
    final incomeData = <FlSpot>[];
    final expenseData = <FlSpot>[];

    // Regrouper les transactions par mois pour le graphique
    final monthly = <DateTime, Map<TransactionType, double>>{};

    // Prendre les 6 derniers mois
    final now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      monthly[month] = {
        TransactionType.income: 0,
        TransactionType.expense: 0,
      };
    }

    // Calculer les montants mensuels
    for (final transaction in transactions) {
      final transactionDate = transaction.date;
      final month = DateTime(
        transactionDate.year,
        transactionDate.month,
        1,
      );

      if (monthly.containsKey(month)) {
        monthly[month]![transaction.type] =
            (monthly[month]![transaction.type] ?? 0) + transaction.amount;
      }
    }

    // Créer les données pour le graphique
    int i = 0;
    monthly.forEach((month, data) {
      incomeData.add(FlSpot(i.toDouble(), data[TransactionType.income] ?? 0));
      expenseData
          .add(FlSpot(i.toDouble(), data[TransactionType.expense] ?? 0));
      i++;
    });

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < monthly.length) {
                  final month = monthly.keys.elementAt(value.toInt());
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('MMM').format(month),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          // Ligne des revenus
          LineChartBarData(
            spots: incomeData,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.1),
            ),
          ),
          // Ligne des dépenses
          LineChartBarData(
            spots: expenseData,
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final isIncome = spot.barIndex == 0;
                return LineTooltipItem(
                  '${isIncome ? 'Revenus' : 'Dépenses'}: ${NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(spot.y)}',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    Transaction transaction,
    double screenWidth,
  ) {
    final formatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '€',
      decimalDigits: 2,
    );

    final isIncome = transaction.type == TransactionType.income;
    final amount = isIncome ? transaction.amount : -transaction.amount;

    return Dismissible(
      key: Key(transaction.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text(
                  'Êtes-vous sûr de vouloir supprimer cette transaction ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Supprimer'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<FinanceBloc>().add(DeleteTransaction(transaction.id));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction supprimée'),
          ),
        );
      },
      child: InkWell(
        onTap: () => _showEditTransactionDialog(context, transaction),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icône et catégorie
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getCategoryColor(transaction.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(transaction.category),
                  color: _getCategoryColor(transaction.category),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              // Titre et date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy', 'fr_FR').format(transaction.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Montant
              Text(
                formatter.format(amount),
                style: TextStyle(
                  color: isIncome ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    double amount = 0.0;
    TransactionType type = TransactionType.expense;
    TransactionCategory category = TransactionCategory.miscellaneous;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter une transaction'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Type de transaction (revenus ou dépenses)
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<TransactionType>(
                              title: const Text('Dépense'),
                              value: TransactionType.expense,
                              groupValue: type,
                              onChanged: (value) {
                                setState(() {
                                  type = value!;
                                  // Ajuster la catégorie par défaut selon le type
                                  if (value == TransactionType.expense) {
                                    category = TransactionCategory.miscellaneous;
                                  } else {
                                    category = TransactionCategory.other;
                                  }
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<TransactionType>(
                              title: const Text('Revenu'),
                              value: TransactionType.income,
                              groupValue: type,
                              onChanged: (value) {
                                setState(() {
                                  type = value!;
                                  // Ajuster la catégorie par défaut selon le type
                                  if (value == TransactionType.expense) {
                                    category = TransactionCategory.miscellaneous;
                                  } else {
                                    category = TransactionCategory.other;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      // Titre
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Titre',
                          hintText: 'Entrez un titre',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un titre';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                      
                      // Description
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description (optionnel)',
                          hintText: 'Entrez une description',
                        ),
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                      
                      // Montant
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Montant',
                          hintText: 'Entrez le montant',
                          prefixText: '€ ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un montant';
                          }
                          // Vérifier que le montant est un nombre valide
                          if (double.tryParse(value.replaceAll(',', '.')) == null) {
                            return 'Veuillez entrer un montant valide';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            // Convertir la valeur en remplaçant , par . pour les nombres à virgule
                            amount = double.parse(value.replaceAll(',', '.'));
                          }
                        },
                      ),
                      
                      // Catégorie
                      DropdownButtonFormField<TransactionCategory>(
                        decoration: const InputDecoration(
                          labelText: 'Catégorie',
                        ),
                        value: category,
                        items: _getCategoriesForType(type).map((category) {
                          return DropdownMenuItem<TransactionCategory>(
                            value: category,
                            child: Text(_getCategoryName(category)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            category = value!;
                          });
                        },
                      ),
                      
                      // Date
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          children: [
                            const Text('Date: '),
                            TextButton(
                              onPressed: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });
                                }
                              },
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(selectedDate),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Créer la nouvelle transaction
                      final newTransaction = Transaction.create(
                        title: title,
                        description: description,
                        amount: amount,
                        type: type,
                        category: category,
                        date: selectedDate,
                      );
                      
                      // Ajouter la transaction via le bloc
                      context.read<FinanceBloc>().add(AddTransaction(newTransaction));
                      
                      // Mettre à jour le résumé financier
                      context.read<FinanceBloc>().add(const CalculateFinancialSummary());
                      
                      Navigator.of(context).pop();
                      
                      // Afficher un message de confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transaction ajoutée avec succès'),
                        ),
                      );
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTransactionDialog(BuildContext context, Transaction transaction) {
    final formKey = GlobalKey<FormState>();
    String title = transaction.title;
    String description = transaction.description;
    double amount = transaction.amount;
    TransactionType type = transaction.type;
    TransactionCategory category = transaction.category;
    DateTime selectedDate = transaction.date;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Modifier la transaction'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Type de transaction (revenus ou dépenses)
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<TransactionType>(
                              title: const Text('Dépense'),
                              value: TransactionType.expense,
                              groupValue: type,
                              onChanged: (value) {
                                setState(() {
                                  type = value!;
                                  // Ajuster la catégorie si nécessaire
                                  if (!_getCategoriesForType(type).contains(category)) {
                                    category = type == TransactionType.expense
                                        ? TransactionCategory.miscellaneous
                                        : TransactionCategory.other;
                                  }
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<TransactionType>(
                              title: const Text('Revenu'),
                              value: TransactionType.income,
                              groupValue: type,
                              onChanged: (value) {
                                setState(() {
                                  type = value!;
                                  // Ajuster la catégorie si nécessaire
                                  if (!_getCategoriesForType(type).contains(category)) {
                                    category = type == TransactionType.expense
                                        ? TransactionCategory.miscellaneous
                                        : TransactionCategory.other;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      // Titre
                      TextFormField(
                        initialValue: title,
                        decoration: const InputDecoration(
                          labelText: 'Titre',
                          hintText: 'Entrez un titre',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un titre';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                      
                      // Description
                      TextFormField(
                        initialValue: description,
                        decoration: const InputDecoration(
                          labelText: 'Description (optionnel)',
                          hintText: 'Entrez une description',
                        ),
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                      
                      // Montant
                      TextFormField(
                        initialValue: amount.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Montant',
                          hintText: 'Entrez le montant',
                          prefixText: '€ ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un montant';
                          }
                          if (double.tryParse(value.replaceAll(',', '.')) == null) {
                            return 'Veuillez entrer un montant valide';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            amount = double.parse(value.replaceAll(',', '.'));
                          }
                        },
                      ),
                      
                      // Catégorie
                      DropdownButtonFormField<TransactionCategory>(
                        decoration: const InputDecoration(
                          labelText: 'Catégorie',
                        ),
                        value: category,
                        items: _getCategoriesForType(type).map((cat) {
                          return DropdownMenuItem<TransactionCategory>(
                            value: cat,
                            child: Text(_getCategoryName(cat)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            category = value!;
                          });
                        },
                      ),
                      
                      // Date
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          children: [
                            const Text('Date: '),
                            TextButton(
                              onPressed: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });
                                }
                              },
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(selectedDate),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Créer la transaction mise à jour
                      final updatedTransaction = transaction.copyWith(
                        title: title,
                        description: description,
                        amount: amount,
                        type: type,
                        category: category,
                        date: selectedDate,
                      );
                      
                      // Mettre à jour la transaction via le bloc
                      context.read<FinanceBloc>().add(UpdateTransaction(updatedTransaction));
                      
                      // Mettre à jour le résumé financier
                      context.read<FinanceBloc>().add(const CalculateFinancialSummary());
                      
                      Navigator.of(context).pop();
                      
                      // Afficher un message de confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transaction mise à jour avec succès'),
                        ),
                      );
                    }
                  },
                  child: const Text('Modifier'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<TransactionCategory> _getCategoriesForType(TransactionType type) {
    if (type == TransactionType.income) {
      return [
        TransactionCategory.salary,
        TransactionCategory.clientPayment,
        TransactionCategory.investment,
        TransactionCategory.sale,
        TransactionCategory.other,
      ];
    } else {
      return [
        TransactionCategory.rent,
        TransactionCategory.utilities,
        TransactionCategory.equipment,
        TransactionCategory.software,
        TransactionCategory.marketing,
        TransactionCategory.travel,
        TransactionCategory.food,
        TransactionCategory.tax,
        TransactionCategory.insurance,
        TransactionCategory.subscription,
        TransactionCategory.miscellaneous,
      ];
    }
  }

  String _getCategoryName(TransactionCategory category) {
    switch (category) {
      // Revenus
      case TransactionCategory.salary:
        return 'Salaire';
      case TransactionCategory.clientPayment:
        return 'Paiement client';
      case TransactionCategory.investment:
        return 'Investissement';
      case TransactionCategory.sale:
        return 'Vente';
      case TransactionCategory.other:
        return 'Autre revenu';
      
      // Dépenses
      case TransactionCategory.rent:
        return 'Loyer/Immobilier';
      case TransactionCategory.utilities:
        return 'Services (eau, élec., etc.)';
      case TransactionCategory.equipment:
        return 'Équipement';
      case TransactionCategory.software:
        return 'Logiciels/Abonnements';
      case TransactionCategory.marketing:
        return 'Marketing';
      case TransactionCategory.travel:
        return 'Déplacements';
      case TransactionCategory.food:
        return 'Repas/Alimentation';
      case TransactionCategory.tax:
        return 'Impôts/Taxes';
      case TransactionCategory.insurance:
        return 'Assurances';
      case TransactionCategory.subscription:
        return 'Abonnements';
      case TransactionCategory.miscellaneous:
        return 'Divers';
    }
  }

  Color _getCategoryColor(TransactionCategory category) {
    switch (category) {
      // Revenus
      case TransactionCategory.salary:
        return Colors.green;
      case TransactionCategory.clientPayment:
        return Colors.teal;
      case TransactionCategory.investment:
        return Colors.lightGreen;
      case TransactionCategory.sale:
        return Colors.lime;
      case TransactionCategory.other:
        return Colors.greenAccent;
      
      // Dépenses
      case TransactionCategory.rent:
        return Colors.red;
      case TransactionCategory.utilities:
        return Colors.orange;
      case TransactionCategory.equipment:
        return Colors.blue;
      case TransactionCategory.software:
        return Colors.indigo;
      case TransactionCategory.marketing:
        return Colors.pink;
      case TransactionCategory.travel:
        return Colors.amber;
      case TransactionCategory.food:
        return Colors.deepOrange;
      case TransactionCategory.tax:
        return Colors.purple;
      case TransactionCategory.insurance:
        return Colors.blueGrey;
      case TransactionCategory.subscription:
        return Colors.cyan;
      case TransactionCategory.miscellaneous:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      // Revenus
      case TransactionCategory.salary:
        return Icons.monetization_on;
      case TransactionCategory.clientPayment:
        return Icons.handshake;
      case TransactionCategory.investment:
        return Icons.trending_up;
      case TransactionCategory.sale:
        return Icons.shopping_bag;
      case TransactionCategory.other:
        return Icons.attach_money;
      
      // Dépenses
      case TransactionCategory.rent:
        return Icons.home;
      case TransactionCategory.utilities:
        return Icons.power;
      case TransactionCategory.equipment:
        return Icons.computer;
      case TransactionCategory.software:
        return Icons.code;
      case TransactionCategory.marketing:
        return Icons.campaign;
      case TransactionCategory.travel:
        return Icons.flight;
      case TransactionCategory.food:
        return Icons.restaurant;
      case TransactionCategory.tax:
        return Icons.receipt_long;
      case TransactionCategory.insurance:
        return Icons.security;
      case TransactionCategory.subscription:
        return Icons.subscriptions;
      case TransactionCategory.miscellaneous:
        return Icons.category;
    }
  }
}
