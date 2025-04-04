import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/finance_bloc.dart';
import '../widgets/account_card.dart';
import '../widgets/expense_pie_chart.dart';
import '../widgets/financial_summary_card.dart';
import '../widgets/income_expense_chart.dart';
import '../widgets/period_selector.dart';
import '../widgets/transaction_list_item.dart';

/// Page principale pour la gestion des finances
class FinanceOverviewPage extends StatefulWidget {
  const FinanceOverviewPage({Key? key}) : super(key: key);
  
  @override
  State<FinanceOverviewPage> createState() => _FinanceOverviewPageState();
}

class _FinanceOverviewPageState extends State<FinanceOverviewPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FinancialPeriod _selectedPeriod = FinancialPeriod.monthly;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Charger les données initiales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Charger les transactions récentes
      context.read<FinanceBloc>().add(const LoadTransactions());
      
      // Charger les comptes
      context.read<FinanceBloc>().add(const LoadAccounts());
      
      // Charger le résumé financier pour le mois en cours
      final dateRange = _selectedPeriod.getDateRange();
      context.read<FinanceBloc>().add(LoadFinancialSummary(
        startDate: dateRange.$1,
        endDate: dateRange.$2,
      ));
      
      // Charger les tendances financières
      context.read<FinanceBloc>().add(LoadFinancialTrends(
        period: _selectedPeriod,
        count: 6, // 6 périodes précédentes
      ));
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aperçu'),
            Tab(text: 'Transactions'),
            Tab(text: 'Comptes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildTransactionsTab(),
          _buildAccountsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Ajouter une transaction',
      ),
    );
  }
  
  /// Construit l'onglet d'aperçu financier
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sélecteur de période
          PeriodSelector(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (period) {
              setState(() {
                _selectedPeriod = period;
              });
              
              context.read<FinanceBloc>().add(ChangePeriod(period));
            },
          ),
          
          // Résumé financier
          BlocBuilder<FinanceBloc, FinanceState>(
            builder: (context, state) {
              if (state is FinancialSummaryLoaded) {
                return FinancialSummaryCard(
                  summary: state.summary,
                  onTap: () {
                    // Naviguer vers une vue détaillée du résumé
                  },
                );
              }
              
              if (state is FinanceLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              return const SizedBox.shrink();
            },
          ),
          
          // Graphique revenus vs dépenses
          BlocBuilder<FinanceBloc, FinanceState>(
            builder: (context, state) {
              if (state is FinancialTrendsLoaded) {
                return IncomeExpenseChart(
                  summaries: state.trends,
                  period: state.period,
                );
              }
              
              return const SizedBox.shrink();
            },
          ),
          
          // Graphique dépenses par catégorie
          BlocBuilder<FinanceBloc, FinanceState>(
            builder: (context, state) {
              if (state is FinancialSummaryLoaded) {
                return ExpensePieChart(
                  expensesByCategory: state.summary.expensesByCategory,
                  onCategorySelected: (category) {
                    // Filtrer les transactions par catégorie
                    context.read<FinanceBloc>().add(FilterTransactions(
                      type: TransactionType.expense,
                      category: category,
                    ));
                    
                    // Passer à l'onglet transactions
                    _tabController.animateTo(1);
                  },
                );
              }
              
              return const SizedBox.shrink();
            },
          ),
          
          // Transactions récentes
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Transactions récentes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          
          BlocBuilder<FinanceBloc, FinanceState>(
            builder: (context, state) {
              if (state is TransactionsLoaded) {
                // Prendre les 5 premières transactions
                final recentTransactions = state.transactions.take(5).toList();
                
                if (recentTransactions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Aucune transaction récente',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = recentTransactions[index];
                    return TransactionListItem(
                      transaction: transaction,
                      onTap: () => _showTransactionDetailsDialog(transaction),
                    );
                  },
                );
              }
              
              if (state is FinanceLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              return const SizedBox.shrink();
            },
          ),
          
          // Bouton "Voir plus"
          Center(
            child: TextButton.icon(
              onPressed: () => _tabController.animateTo(1),
              icon: const Icon(Icons.visibility),
              label: const Text('Voir toutes les transactions'),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Construit l'onglet des transactions
  Widget _buildTransactionsTab() {
    return Column(
      children: [
        // Filtres
        _buildTransactionFilters(),
        
        // Liste des transactions
        Expanded(
          child: BlocBuilder<FinanceBloc, FinanceState>(
            builder: (context, state) {
              if (state is TransactionsLoaded) {
                if (state.transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune transaction trouvée',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => _showAddTransactionDialog(),
                          icon: const Icon(Icons.add),
                          label: const Text('Ajouter une transaction'),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = state.transactions[index];
                    return TransactionListItem(
                      transaction: transaction,
                      onTap: () => _showTransactionDetailsDialog(transaction),
                      onLongPress: () => _showTransactionActions(transaction),
                    );
                  },
                );
              }
              
              if (state is FinanceLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (state is FinanceError) {
                return Center(
                  child: Text(
                    'Erreur: ${state.message}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                );
              }
              
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
  
  /// Construit l'onglet des comptes
  Widget _buildAccountsTab() {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is AccountsLoaded) {
          if (state.accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun compte trouvé',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showAddAccountDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un compte'),
                  ),
                ],
              ),
            );
          }
          
          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 80.0),
                itemCount: state.accounts.length,
                itemBuilder: (context, index) {
                  final account = state.accounts[index];
                  return AccountCard(
                    account: account,
                    onTap: () => _showAccountTransactions(account.id),
                    onEditTap: () => _showEditAccountDialog(account),
                  );
                },
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  heroTag: 'add_account',
                  onPressed: () => _showAddAccountDialog(),
                  child: const Icon(Icons.add),
                  tooltip: 'Ajouter un compte',
                ),
              ),
            ],
          );
        }
        
        if (state is FinanceLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
  
  /// Construit les filtres pour les transactions
  Widget _buildTransactionFilters() {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is TransactionsLoaded) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Filtres de type (revenus/dépenses)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: 'Tous',
                          selected: state.typeFilter == null,
                          onSelected: (selected) {
                            if (selected) {
                              context.read<FinanceBloc>().add(FilterTransactions(
                                type: null,
                                category: state.categoryFilter,
                                startDate: state.startDateFilter,
                                endDate: state.endDateFilter,
                                accountId: state.accountIdFilter,
                                searchQuery: state.searchQueryFilter,
                              ));
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'Revenus',
                          selected: state.typeFilter == TransactionType.income,
                          onSelected: (selected) {
                            context.read<FinanceBloc>().add(FilterTransactions(
                              type: selected ? TransactionType.income : null,
                              category: state.categoryFilter,
                              startDate: state.startDateFilter,
                              endDate: state.endDateFilter,
                              accountId: state.accountIdFilter,
                              searchQuery: state.searchQueryFilter,
                            ));
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'Dépenses',
                          selected: state.typeFilter == TransactionType.expense,
                          onSelected: (selected) {
                            context.read<FinanceBloc>().add(FilterTransactions(
                              type: selected ? TransactionType.expense : null,
                              category: state.categoryFilter,
                              startDate: state.startDateFilter,
                              endDate: state.endDateFilter,
                              accountId: state.accountIdFilter,
                              searchQuery: state.searchQueryFilter,
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // Barre de recherche
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Rechercher...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                      ),
                      onChanged: (value) {
                        context.read<FinanceBloc>().add(FilterTransactions(
                          type: state.typeFilter,
                          category: state.categoryFilter,
                          startDate: state.startDateFilter,
                          endDate: state.endDateFilter,
                          accountId: state.accountIdFilter,
                          searchQuery: value.isEmpty ? null : value,
                        ));
                      },
                    ),
                  ),
                  
                  // Filtres supplémentaires (date, catégorie, compte)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showDateRangeFilter(
                            state.startDateFilter,
                            state.endDateFilter,
                          ),
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Date'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 12.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showCategoryFilter(state.categoryFilter),
                          icon: const Icon(Icons.category),
                          label: const Text('Catégorie'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 12.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showAccountFilter(state.accountIdFilter),
                          icon: const Icon(Icons.account_balance),
                          label: const Text('Compte'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Afficher les filtres actifs
                  if (state.categoryFilter != null ||
                      state.startDateFilter != null ||
                      state.endDateFilter != null ||
                      state.accountIdFilter != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          const Text('Filtres:'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  if (state.categoryFilter != null)
                                    _buildActiveFilter(
                                      label: state.categoryFilter!.getLocalizedName(),
                                      onRemove: () {
                                        context.read<FinanceBloc>().add(FilterTransactions(
                                          type: state.typeFilter,
                                          category: null,
                                          startDate: state.startDateFilter,
                                          endDate: state.endDateFilter,
                                          accountId: state.accountIdFilter,
                                          searchQuery: state.searchQueryFilter,
                                        ));
                                      },
                                    ),
                                  if (state.startDateFilter != null || state.endDateFilter != null)
                                    _buildActiveFilter(
                                      label: _formatDateRange(
                                        state.startDateFilter,
                                        state.endDateFilter,
                                      ),
                                      onRemove: () {
                                        context.read<FinanceBloc>().add(FilterTransactions(
                                          type: state.typeFilter,
                                          category: state.categoryFilter,
                                          startDate: null,
                                          endDate: null,
                                          accountId: state.accountIdFilter,
                                          searchQuery: state.searchQueryFilter,
                                        ));
                                      },
                                    ),
                                  if (state.accountIdFilter != null)
                                    FutureBuilder(
                                      future: _getAccountName(state.accountIdFilter!),
                                      builder: (context, snapshot) {
                                        return _buildActiveFilter(
                                          label: snapshot.data ?? 'Compte',
                                          onRemove: () {
                                            context.read<FinanceBloc>().add(FilterTransactions(
                                              type: state.typeFilter,
                                              category: state.categoryFilter,
                                              startDate: state.startDateFilter,
                                              endDate: state.endDateFilter,
                                              accountId: null,
                                              searchQuery: state.searchQueryFilter,
                                            ));
                                          },
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              context.read<FinanceBloc>().add(const LoadTransactions());
                            },
                            child: const Text('Réinitialiser'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
  
  /// Construit une puce de filtre
  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      labelStyle: TextStyle(
        color: selected ? Colors.white : null,
      ),
      backgroundColor: Theme.of(context).chipTheme.backgroundColor,
      selectedColor: Theme.of(context).primaryColor,
    );
  }
  
  /// Construit un indicateur de filtre actif
  Widget _buildActiveFilter({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
      ),
    );
  }
  
  /// Formate l'affichage d'une plage de dates
  String _formatDateRange(DateTime? startDate, DateTime? endDate) {
    final dateFormat = DateFormat.yMd('fr_FR');
    
    if (startDate != null && endDate != null) {
      return '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}';
    } else if (startDate != null) {
      return 'Après le ${dateFormat.format(startDate)}';
    } else if (endDate != null) {
      return 'Avant le ${dateFormat.format(endDate)}';
    }
    
    return 'Période';
  }
  
  /// Récupère le nom d'un compte à partir de son ID
  Future<String> _getAccountName(String accountId) async {
    final state = context.read<FinanceBloc>().state;
    if (state is AccountsLoaded) {
      final account = state.accounts.firstWhere(
        (a) => a.id == accountId,
        orElse: () => throw Exception('Compte non trouvé'),
      );
      return account.name;
    }
    
    // TODO: Implémenter la récupération du nom du compte via le repository
    return 'Compte';
  }
  
  /// Affiche une boîte de dialogue pour filtrer par plage de dates
  Future<void> _showDateRangeFilter(DateTime? currentStartDate, DateTime? currentEndDate) async {
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime.now(),
      initialDateRange: currentStartDate != null && currentEndDate != null
          ? DateTimeRange(start: currentStartDate, end: currentEndDate)
          : null,
    );
    
    if (result != null) {
      final state = context.read<FinanceBloc>().state;
      if (state is TransactionsLoaded) {
        context.read<FinanceBloc>().add(FilterTransactions(
          type: state.typeFilter,
          category: state.categoryFilter,
          startDate: result.start,
          endDate: result.end,
          accountId: state.accountIdFilter,
          searchQuery: state.searchQueryFilter,
        ));
      }
    }
  }
  
  /// Affiche une boîte de dialogue pour filtrer par catégorie
  Future<void> _showCategoryFilter(TransactionCategory? currentCategory) async {
    final categories = TransactionCategory.values;
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrer par catégorie'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Option "Toutes"
                ListTile(
                  title: const Text('Toutes les catégories'),
                  leading: const Icon(Icons.clear_all),
                  onTap: () {
                    Navigator.of(context).pop();
                    
                    final state = context.read<FinanceBloc>().state;
                    if (state is TransactionsLoaded) {
                      context.read<FinanceBloc>().add(FilterTransactions(
                        type: state.typeFilter,
                        category: null,
                        startDate: state.startDateFilter,
                        endDate: state.endDateFilter,
                        accountId: state.accountIdFilter,
                        searchQuery: state.searchQueryFilter,
                      ));
                    }
                  },
                ),
                
                const Divider(),
                
                // Liste des catégories
                ...categories.map((category) {
                  return ListTile(
                    title: Text(category.getLocalizedName()),
                    leading: Icon(
                      category.getIcon(),
                      color: category.getColor(),
                    ),
                    selected: currentCategory == category,
                    onTap: () {
                      Navigator.of(context).pop();
                      
                      final state = context.read<FinanceBloc>().state;
                      if (state is TransactionsLoaded) {
                        context.read<FinanceBloc>().add(FilterTransactions(
                          type: state.typeFilter,
                          category: category,
                          startDate: state.startDateFilter,
                          endDate: state.endDateFilter,
                          accountId: state.accountIdFilter,
                          searchQuery: state.searchQueryFilter,
                        ));
                      }
                    },
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }
  
  /// Affiche une boîte de dialogue pour filtrer par compte
  Future<void> _showAccountFilter(String? currentAccountId) async {
    final state = context.read<FinanceBloc>().state;
    if (state is! AccountsLoaded) {
      // Charger les comptes si ce n'est pas déjà fait
      context.read<FinanceBloc>().add(const LoadAccounts());
      return;
    }
    
    final accounts = state.accounts;
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrer par compte'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Option "Tous"
                ListTile(
                  title: const Text('Tous les comptes'),
                  leading: const Icon(Icons.account_balance),
                  onTap: () {
                    Navigator.of(context).pop();
                    
                    final blocState = context.read<FinanceBloc>().state;
                    if (blocState is TransactionsLoaded) {
                      context.read<FinanceBloc>().add(FilterTransactions(
                        type: blocState.typeFilter,
                        category: blocState.categoryFilter,
                        startDate: blocState.startDateFilter,
                        endDate: blocState.endDateFilter,
                        accountId: null,
                        searchQuery: blocState.searchQueryFilter,
                      ));
                    }
                  },
                ),
                
                const Divider(),
                
                // Liste des comptes
                ...accounts.map((account) {
                  return ListTile(
                    title: Text(account.name),
                    subtitle: Text(account.type.getLocalizedName()),
                    leading: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: account.balance >= 0 ? Colors.green : Colors.red,
                    ),
                    selected: currentAccountId == account.id,
                    onTap: () {
                      Navigator.of(context).pop();
                      
                      final blocState = context.read<FinanceBloc>().state;
                      if (blocState is TransactionsLoaded) {
                        context.read<FinanceBloc>().add(FilterTransactions(
                          type: blocState.typeFilter,
                          category: blocState.categoryFilter,
                          startDate: blocState.startDateFilter,
                          endDate: blocState.endDateFilter,
                          accountId: account.id,
                          searchQuery: blocState.searchQueryFilter,
                        ));
                      }
                    },
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }
  
  /// Affiche une boîte de dialogue pour ajouter une transaction
  void _showAddTransactionDialog() {
    // TODO: Implémenter l'ajout de transaction
    // Cette fonctionnalité sera implémentée dans une prochaine étape
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à implémenter: Ajouter une transaction'),
      ),
    );
  }
  
  /// Affiche une boîte de dialogue avec les détails d'une transaction
  void _showTransactionDetailsDialog(Transaction transaction) {
    // TODO: Implémenter l'affichage des détails de transaction
    // Cette fonctionnalité sera implémentée dans une prochaine étape
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Détails de la transaction: ${transaction.title}'),
      ),
    );
  }
  
  /// Affiche un menu d'actions pour une transaction
  void _showTransactionActions(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('Voir les détails'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showTransactionDetailsDialog(transaction);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Modifier'),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Implémenter la modification de transaction
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fonctionnalité à implémenter: Modifier une transaction'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.of(context).pop();
                  _confirmDeleteTransaction(transaction);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Demande confirmation pour supprimer une transaction
  void _confirmDeleteTransaction(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la transaction'),
          content: Text('Êtes-vous sûr de vouloir supprimer la transaction "${transaction.title}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<FinanceBloc>().add(DeleteTransaction(transaction.id));
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaction supprimée'),
                  ),
                );
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  
  /// Affiche une boîte de dialogue pour ajouter un compte
  void _showAddAccountDialog() {
    // TODO: Implémenter l'ajout de compte
    // Cette fonctionnalité sera implémentée dans une prochaine étape
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à implémenter: Ajouter un compte'),
      ),
    );
  }
  
  /// Affiche une boîte de dialogue pour modifier un compte
  void _showEditAccountDialog(dynamic account) {
    // TODO: Implémenter la modification de compte
    // Cette fonctionnalité sera implémentée dans une prochaine étape
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fonctionnalité à implémenter: Modifier le compte ${account.name}'),
      ),
    );
  }
  
  /// Affiche les transactions d'un compte spécifique
  void _showAccountTransactions(String accountId) {
    // Filtrer les transactions par compte
    context.read<FinanceBloc>().add(FilterTransactions(
      accountId: accountId,
    ));
    
    // Passer à l'onglet transactions
    _tabController.animateTo(1);
  }
}
