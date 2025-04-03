import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/finance_bloc.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({Key? key}) : super(key: key);

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final currencyFormatter = NumberFormat.currency(symbol: '\$');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Finance Tracker'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Transactions'),
          ],
        ),
        actions: [
          PopupMenuButton<DatePeriod>(
            icon: const Icon(Icons.calendar_today_outlined),
            tooltip: 'Select Period',
            onSelected: (period) {
              context.read<FinanceBloc>().add(ChangePeriod(period));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: DatePeriod.day,
                child: Text('Today'),
              ),
              const PopupMenuItem(
                value: DatePeriod.week,
                child: Text('This Week'),
              ),
              const PopupMenuItem(
                value: DatePeriod.month,
                child: Text('This Month'),
              ),
              const PopupMenuItem(
                value: DatePeriod.year,
                child: Text('This Year'),
              ),
              const PopupMenuItem(
                value: DatePeriod.all,
                child: Text('All Time'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<FinanceBloc, FinanceState>(
        listener: (context, state) {
          if (state is FinanceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is FinanceInitial || state is FinanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FinanceLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context, state),
                _buildTransactionsTab(context, state),
              ],
            );
          }
          
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Transaction',
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, FinanceLoaded state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacing(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financial summary cards
          _buildSummaryCards(context, state),
          
          SizedBox(height: AppTheme.spacing(3)),
          
          // Income vs Expense chart
          AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Income vs Expense',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                  SizedBox(
                    height: 200,
                    child: _buildIncomeExpenseChart(context, state),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: AppTheme.spacing(3)),
          
          // Recent transactions
          AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          _tabController.animateTo(1);
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  _buildRecentTransactions(context, state),
                ],
              ),
            ),
          ),
          
          SizedBox(height: AppTheme.spacing(3)),
          
          // Category breakdown
          AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense by Category',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                  SizedBox(
                    height: 200,
                    child: _buildExpensePieChart(context, state),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: AppTheme.spacing(4)),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, FinanceLoaded state) {
    final String periodName = _getPeriodName(state.currentPeriod);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppTheme.spacing(1)),
          child: Text(
            periodName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AppCard(
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.spacing(2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: AppTheme.spacing(1)),
                      Text(
                        currencyFormatter.format(state.balance),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: state.balance >= 0 ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppTheme.spacing(2)),
        Row(
          children: [
            Expanded(
              child: AppCard(
                backgroundColor: Colors.green.withOpacity(0.1),
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.spacing(2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.arrow_downward, color: Colors.green, size: 16),
                          SizedBox(width: 4),
                          Text('Income', style: TextStyle(color: Colors.green)),
                        ],
                      ),
                      SizedBox(height: AppTheme.spacing(1)),
                      Text(
                        currencyFormatter.format(state.totalIncome),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: AppTheme.spacing(2)),
            Expanded(
              child: AppCard(
                backgroundColor: Colors.red.withOpacity(0.1),
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.spacing(2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.red, size: 16),
                          SizedBox(width: 4),
                          Text('Expense', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: AppTheme.spacing(1)),
                      Text(
                        currencyFormatter.format(state.totalExpense),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseChart(BuildContext context, FinanceLoaded state) {
    // Group transactions by date
    final Map<String, double> incomeByDate = {};
    final Map<String, double> expenseByDate = {};
    
    // Get transactions for the period
    final periodTransactions = state.transactions.where((t) {
      return t.date.isAfter(state.periodStart) && t.date.isBefore(state.periodEnd);
    }).toList();
    
    // Determine the date format based on the period
    String dateFormat;
    switch (state.currentPeriod) {
      case DatePeriod.day:
        dateFormat = 'HH:00';
        break;
      case DatePeriod.week:
        dateFormat = 'EEE';
        break;
      case DatePeriod.month:
        dateFormat = 'dd';
        break;
      case DatePeriod.year:
        dateFormat = 'MMM';
        break;
      case DatePeriod.all:
        dateFormat = 'yyyy';
        break;
    }
    
    // Group transactions
    for (final transaction in periodTransactions) {
      final dateKey = DateFormat(dateFormat).format(transaction.date);
      
      if (transaction.type == TransactionType.income) {
        incomeByDate[dateKey] = (incomeByDate[dateKey] ?? 0) + transaction.amount;
      } else {
        expenseByDate[dateKey] = (expenseByDate[dateKey] ?? 0) + transaction.amount;
      }
    }
    
    // Get all date keys
    final allDates = {...incomeByDate.keys, ...expenseByDate.keys}.toList()..sort();
    
    if (allDates.isEmpty) {
      return const Center(
        child: Text('No transactions in this period'),
      );
    }
    
    // Create bar groups for chart
    final List<BarChartGroupData> barGroups = [];
    
    for (int i = 0; i < allDates.length; i++) {
      final date = allDates[i];
      final incomeValue = incomeByDate[date] ?? 0;
      final expenseValue = expenseByDate[date] ?? 0;
      
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: incomeValue,
              color: Colors.green,
              width: 12,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            BarChartRodData(
              toY: expenseValue,
              color: Colors.red,
              width: 12,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxValue(incomeByDate, expenseByDate) * 1.2,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < allDates.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      allDates[value.toInt()],
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  currencyFormatter.format(value),
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: _getMaxValue(incomeByDate, expenseByDate) / 5,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.textSecondary.withOpacity(0.2),
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),
      ),
    );
  }

  double _getMaxValue(Map<String, double> incomeByDate, Map<String, double> expenseByDate) {
    double maxIncome = 0;
    double maxExpense = 0;
    
    if (incomeByDate.isNotEmpty) {
      maxIncome = incomeByDate.values.reduce((a, b) => a > b ? a : b);
    }
    
    if (expenseByDate.isNotEmpty) {
      maxExpense = expenseByDate.values.reduce((a, b) => a > b ? a : b);
    }
    
    return maxIncome > maxExpense ? maxIncome : maxExpense;
  }

  Widget _buildExpensePieChart(BuildContext context, FinanceLoaded state) {
    // Group expenses by category
    final Map<String, double> expensesByCategory = {};
    
    // Get transactions for the period
    final periodTransactions = state.transactions.where((t) {
      return t.date.isAfter(state.periodStart) && 
             t.date.isBefore(state.periodEnd) &&
             t.type == TransactionType.expense;
    }).toList();
    
    // Group transactions
    for (final transaction in periodTransactions) {
      expensesByCategory[transaction.category] = 
          (expensesByCategory[transaction.category] ?? 0) + transaction.amount;
    }
    
    if (expensesByCategory.isEmpty) {
      return const Center(
        child: Text('No expenses in this period'),
      );
    }
    
    // Sort categories by amount (descending)
    final sortedCategories = expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Generate colors for pie sections
    final List<Color> colors = [
      AppColors.primary,
      AppColors.secondary,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];
    
    // Create sections for pie chart
    final List<PieChartSectionData> sections = [];
    
    for (int i = 0; i < sortedCategories.length; i++) {
      final category = sortedCategories[i];
      final color = colors[i % colors.length];
      
      sections.add(
        PieChartSectionData(
          value: category.value,
          title: '${category.key}\n${currencyFormatter.format(category.value)}',
          color: color,
          radius: 80,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    
    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 0,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context, FinanceLoaded state) {
    // Get transactions for the period
    final periodTransactions = state.transactions.where((t) {
      return t.date.isAfter(state.periodStart) && t.date.isBefore(state.periodEnd);
    }).toList();
    
    // Sort by date (most recent first)
    periodTransactions.sort((a, b) => b.date.compareTo(a.date));
    
    if (periodTransactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text('No transactions in this period'),
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: periodTransactions.length > 5 ? 5 : periodTransactions.length,
      itemBuilder: (context, index) {
        final transaction = periodTransactions[index];
        return _buildTransactionItem(context, transaction);
      },
    );
  }

  Widget _buildTransactionsTab(BuildContext context, FinanceLoaded state) {
    // Get transactions for the period
    final periodTransactions = state.transactions.where((t) {
      return t.date.isAfter(state.periodStart) && t.date.isBefore(state.periodEnd);
    }).toList();
    
    // Sort by date (most recent first)
    periodTransactions.sort((a, b) => b.date.compareTo(a.date));
    
    if (periodTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppTheme.spacing(2)),
            Text(
              'No transactions in this period',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppTheme.spacing(2)),
            AppButton(
              text: 'Add Transaction',
              onPressed: () => _showAddTransactionDialog(context),
              fullWidth: false,
              icon: Icons.add,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(AppTheme.spacing(2)),
      itemCount: periodTransactions.length,
      itemBuilder: (context, index) {
        final transaction = periodTransactions[index];
        
        // Add date header if this is a new day
        if (index == 0 || !_isSameDay(transaction.date, periodTransactions[index - 1].date)) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) SizedBox(height: AppTheme.spacing(2)),
              _buildDateHeader(context, transaction.date),
              SizedBox(height: AppTheme.spacing(1)),
              _buildTransactionItem(context, transaction),
            ],
          );
        }
        
        return _buildTransactionItem(context, transaction);
      },
    );
  }

  Widget _buildDateHeader(BuildContext context, DateTime date) {
    final now = DateTime.now();
    
    String headerText;
    if (_isSameDay(date, now)) {
      headerText = 'Today';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      headerText = 'Yesterday';
    } else {
      headerText = DateFormat('MMMM d, yyyy').format(date);
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.spacing(1)),
      child: Text(
        headerText,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    final bool isIncome = transaction.type == TransactionType.income;
    final Color amountColor = isIncome ? Colors.green : Colors.red;
    final IconData amountIcon = isIncome ? Icons.arrow_downward : Icons.arrow_upward;
    
    return InkWell(
      onTap: () => _showTransactionDetailsDialog(context, transaction),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppTheme.spacing(1)),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: amountColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                amountIcon,
                color: amountColor,
                size: 20,
              ),
            ),
            SizedBox(width: AppTheme.spacing(2)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        transaction.category,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('HH:mm').format(transaction.date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              (isIncome ? '+ ' : '- ') + currencyFormatter.format(transaction.amount),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: amountColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    
    TransactionType selectedType = TransactionType.expense;
    String? selectedCategory = 'Other';
    DateTime selectedDate = DateTime.now();
    
    // Define categories
    final List<String> incomeCategories = [
      'Salary',
      'Freelance',
      'Investments',
      'Consulting',
      'Other Income',
    ];
    
    final List<String> expenseCategories = [
      'Rent',
      'Utilities',
      'Software',
      'Supplies',
      'Meals',
      'Travel',
      'Taxes',
      'Marketing',
      'Other',
    ];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              selectedType == TransactionType.income
                  ? 'Add Income'
                  : 'Add Expense',
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction type selector
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Expense'),
                          selected: selectedType == TransactionType.expense,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectedType = TransactionType.expense;
                                selectedCategory = 'Other';
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(width: AppTheme.spacing(2)),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Income'),
                          selected: selectedType == TransactionType.income,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectedType = TransactionType.income;
                                selectedCategory = 'Other Income';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  AppTextField(
                    controller: titleController,
                    label: 'Title',
                    hint: 'Enter transaction title',
                    autofocus: true,
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  AppTextField(
                    controller: amountController,
                    label: 'Amount',
                    hint: 'Enter amount',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(1)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.textSecondary.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      underline: const SizedBox(), // Remove the default underline
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      items: (selectedType == TransactionType.income
                              ? incomeCategories
                              : expenseCategories)
                          .map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(1)),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.textSecondary.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 8),
                          Text(DateFormat('MMM dd, yyyy').format(selectedDate)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  AppTextField(
                    controller: noteController,
                    label: 'Note (Optional)',
                    hint: 'Enter additional details',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              AppButton(
                text: 'Save',
                type: AppButtonType.primary,
                fullWidth: false,
                onPressed: () {
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')),
                    );
                    return;
                  }
                  
                  if (amountController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter an amount')),
                    );
                    return;
                  }
                  
                  final double? amount = double.tryParse(amountController.text.trim());
                  if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid amount')),
                    );
                    return;
                  }

                  context.read<FinanceBloc>().add(AddTransaction(
                    title: titleController.text.trim(),
                    amount: amount,
                    type: selectedType,
                    category: selectedCategory,
                    date: selectedDate,
                    note: noteController.text.trim().isNotEmpty
                        ? noteController.text.trim()
                        : null,
                  ));

                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTransactionDetailsDialog(BuildContext context, Transaction transaction) {
    final titleController = TextEditingController(text: transaction.title);
    final amountController = TextEditingController(text: transaction.amount.toString());
    final noteController = TextEditingController(text: transaction.note ?? '');
    
    TransactionType selectedType = transaction.type;
    String selectedCategory = transaction.category;
    DateTime selectedDate = transaction.date;
    
    // Define categories
    final List<String> incomeCategories = [
      'Salary',
      'Freelance',
      'Investments',
      'Consulting',
      'Other Income',
    ];
    
    final List<String> expenseCategories = [
      'Rent',
      'Utilities',
      'Software',
      'Supplies',
      'Meals',
      'Travel',
      'Taxes',
      'Marketing',
      'Other',
    ];
    
    // Add the transaction's category if it's not in the list
    if (transaction.type == TransactionType.income && 
        !incomeCategories.contains(selectedCategory)) {
      incomeCategories.add(selectedCategory);
    } else if (transaction.type == TransactionType.expense && 
               !expenseCategories.contains(selectedCategory)) {
      expenseCategories.add(selectedCategory);
    }
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Transaction Details'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction type selector
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Expense'),
                          selected: selectedType == TransactionType.expense,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectedType = TransactionType.expense;
                                selectedCategory = expenseCategories.contains(selectedCategory)
                                    ? selectedCategory
                                    : 'Other';
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(width: AppTheme.spacing(2)),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Income'),
                          selected: selectedType == TransactionType.income,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectedType = TransactionType.income;
                                selectedCategory = incomeCategories.contains(selectedCategory)
                                    ? selectedCategory
                                    : 'Other Income';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  AppTextField(
                    controller: titleController,
                    label: 'Title',
                    hint: 'Enter transaction title',
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  AppTextField(
                    controller: amountController,
                    label: 'Amount',
                    hint: 'Enter amount',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(1)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.textSecondary.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      underline: const SizedBox(), // Remove the default underline
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      items: (selectedType == TransactionType.income
                              ? incomeCategories
                              : expenseCategories)
                          .map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(1)),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.textSecondary.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 8),
                          Text(DateFormat('MMM dd, yyyy').format(selectedDate)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  AppTextField(
                    controller: noteController,
                    label: 'Note (Optional)',
                    hint: 'Enter additional details',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Transaction'),
                      content: const Text('Are you sure you want to delete this transaction?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<FinanceBloc>().add(DeleteTransaction(transaction.id));
                            Navigator.pop(context); // Close delete dialog
                            Navigator.pop(context); // Close details dialog
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
              AppButton(
                text: 'Save',
                type: AppButtonType.primary,
                fullWidth: false,
                onPressed: () {
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')),
                    );
                    return;
                  }
                  
                  if (amountController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter an amount')),
                    );
                    return;
                  }
                  
                  final double? amount = double.tryParse(amountController.text.trim());
                  if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid amount')),
                    );
                    return;
                  }

                  final updatedTransaction = transaction.copyWith(
                    title: titleController.text.trim(),
                    amount: amount,
                    type: selectedType,
                    category: selectedCategory,
                    date: selectedDate,
                    note: noteController.text.trim().isNotEmpty
                        ? noteController.text.trim()
                        : null,
                  );

                  context.read<FinanceBloc>().add(UpdateTransaction(updatedTransaction));
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  String _getPeriodName(DatePeriod period) {
    switch (period) {
      case DatePeriod.day:
        return 'Today\'s Summary';
      case DatePeriod.week:
        return 'This Week\'s Summary';
      case DatePeriod.month:
        return 'This Month\'s Summary';
      case DatePeriod.year:
        return 'This Year\'s Summary';
      case DatePeriod.all:
        return 'All Time Summary';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }
}
