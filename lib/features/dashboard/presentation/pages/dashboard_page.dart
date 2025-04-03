import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../finance/presentation/bloc/finance_bloc.dart';
import '../../../documents/presentation/bloc/documents_bloc.dart';
import '../../../planner/presentation/bloc/planner_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final currencyFormatter = NumberFormat.currency(symbol: '\$');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh all bloc data
          context.read<FinanceBloc>().add(FetchTransactions());
          context.read<DocumentsBloc>().add(FetchDocuments());
          context.read<PlannerBloc>().add(FetchTasks());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppTheme.spacing(2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Financial Summary Card
              _buildFinancialSummaryCard(context),
              
              SizedBox(height: AppTheme.spacing(3)),
              
              // Tasks Summary Card
              _buildTasksSummaryCard(context),
              
              SizedBox(height: AppTheme.spacing(3)),
              
              // Documents Summary Card
              _buildDocumentsSummaryCard(context),
              
              SizedBox(height: AppTheme.spacing(3)),
              
              // Financial Charts Card
              _buildFinancialChartsCard(context),
              
              SizedBox(height: AppTheme.spacing(3)),
              
              // Time Utilization Card
              _buildTimeUtilizationCard(context),
              
              SizedBox(height: AppTheme.spacing(4)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialSummaryCard(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is FinanceLoaded) {
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Financial Overview',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'This Month',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFinancialMetric(
                          context,
                          'Income',
                          currencyFormatter.format(state.totalIncome),
                          Icons.arrow_upward,
                          Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildFinancialMetric(
                          context,
                          'Expenses',
                          currencyFormatter.format(state.totalExpense),
                          Icons.arrow_downward,
                          Colors.red,
                        ),
                      ),
                      Expanded(
                        child: _buildFinancialMetric(
                          context,
                          'Balance',
                          currencyFormatter.format(state.balance),
                          state.balance >= 0 ? Icons.account_balance : Icons.warning,
                          state.balance >= 0 ? AppColors.primary : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is FinanceLoading) {
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Financial Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                ],
              ),
            ),
          );
        } else {
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Financial Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  const Center(
                    child: Text('Financial data not available'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildFinancialMetric(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        SizedBox(height: AppTheme.spacing(1)),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: AppTheme.spacing(1)),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTasksSummaryCard(BuildContext context) {
    return BlocBuilder<PlannerBloc, PlannerState>(
      builder: (context, state) {
        if (state is PlannerLoaded) {
          // Calculate task metrics
          final totalTasks = state.tasks.length;
          final completedTasks = state.tasks.where((task) => task.isCompleted).length;
          final pendingTasks = totalTasks - completedTasks;
          final upcomingTasks = state.tasks.where((task) {
            final now = DateTime.now();
            return task.dueDate != null && 
                   task.dueDate!.isAfter(now) && 
                   !task.isCompleted;
          }).length;
          
          // Calculate completion percentage
          final completionPercentage = totalTasks > 0 
              ? (completedTasks / totalTasks) * 100 
              : 0.0;
          
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Management',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTaskMetric(
                              context,
                              'Total Tasks',
                              totalTasks.toString(),
                              Icons.assignment,
                              AppColors.primary,
                            ),
                            SizedBox(height: AppTheme.spacing(2)),
                            _buildTaskMetric(
                              context,
                              'Completed',
                              completedTasks.toString(),
                              Icons.check_circle_outline,
                              Colors.green,
                            ),
                            SizedBox(height: AppTheme.spacing(2)),
                            _buildTaskMetric(
                              context,
                              'Pending',
                              pendingTasks.toString(),
                              Icons.pending_actions,
                              Colors.orange,
                            ),
                            SizedBox(height: AppTheme.spacing(2)),
                            _buildTaskMetric(
                              context,
                              'Upcoming',
                              upcomingTasks.toString(),
                              Icons.upcoming,
                              Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 150,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              PieChart(
                                PieChartData(
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: [
                                    PieChartSectionData(
                                      value: completedTasks.toDouble(),
                                      color: Colors.green,
                                      radius: 40,
                                      title: '',
                                    ),
                                    PieChartSectionData(
                                      value: pendingTasks.toDouble(),
                                      color: Colors.orange,
                                      radius: 40,
                                      title: '',
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${completionPercentage.toStringAsFixed(0)}%',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Completed',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is PlannerLoading) {
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Management',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                ],
              ),
            ),
          );
        } else {
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Management',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  const Center(
                    child: Text('Task data not available'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildTaskMetric(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 18,
        ),
        SizedBox(width: AppTheme.spacing(1)),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSummaryCard(BuildContext context) {
    return BlocBuilder<DocumentsBloc, DocumentsState>(
      builder: (context, state) {
        if (state is DocumentsLoaded) {
          // Count documents by type
          final invoices = state.documents.where((doc) => doc.type == DocumentType.invoice).length;
          final contracts = state.documents.where((doc) => doc.type == DocumentType.contract).length;
          final quotes = state.documents.where((doc) => doc.type == DocumentType.quote).length;
          final reports = state.documents.where((doc) => doc.type == DocumentType.report).length;
          
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Documents Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDocumentTypeCount(
                        context,
                        'Invoices',
                        invoices.toString(),
                        Icons.receipt_outlined,
                        AppColors.primary,
                      ),
                      _buildDocumentTypeCount(
                        context,
                        'Contracts',
                        contracts.toString(),
                        Icons.description_outlined,
                        Colors.blue,
                      ),
                      _buildDocumentTypeCount(
                        context,
                        'Quotes',
                        quotes.toString(),
                        Icons.request_quote_outlined,
                        Colors.orange,
                      ),
                      _buildDocumentTypeCount(
                        context,
                        'Reports',
                        reports.toString(),
                        Icons.summarize_outlined,
                        Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is DocumentsLoading) {
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Documents Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                ],
              ),
            ),
          );
        } else {
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Documents Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  const Center(
                    child: Text('Document data not available'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildDocumentTypeCount(
    BuildContext context,
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          radius: 24,
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(height: AppTheme.spacing(1)),
        Text(
          count,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppTheme.spacing(1)),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildFinancialChartsCard(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is FinanceLoaded) {
          // Group transactions by category
          final expensesByCategory = <String, double>{};
          
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
            return AppCard(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.spacing(2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expense Analysis',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: AppTheme.spacing(2)),
                    const Center(
                      child: Text('No expense data available for this period'),
                    ),
                  ],
                ),
              ),
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
                title: category.key,
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
          
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense Analysis',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  // Legend
                  Wrap(
                    spacing: AppTheme.spacing(2),
                    runSpacing: AppTheme.spacing(1),
                    children: List.generate(
                      sortedCategories.length > 5 ? 5 : sortedCategories.length,
                      (index) {
                        final category = sortedCategories[index];
                        final color = colors[index % colors.length];
                        
                        return Chip(
                          backgroundColor: color.withOpacity(0.1),
                          label: Text(
                            '${category.key}: ${currencyFormatter.format(category.value)}',
                            style: TextStyle(color: color),
                          ),
                          avatar: CircleAvatar(
                            backgroundColor: color,
                            radius: 8,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense Analysis',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  const Center(
                    child: Text('Financial data not available'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildTimeUtilizationCard(BuildContext context) {
    return BlocBuilder<PlannerBloc, PlannerState>(
      builder: (context, state) {
        if (state is PlannerLoaded) {
          // Group tasks by priority
          final highPriorityTasks = state.tasks.where((task) => task.priority == TaskPriority.high).length;
          final mediumPriorityTasks = state.tasks.where((task) => task.priority == TaskPriority.medium).length;
          final lowPriorityTasks = state.tasks.where((task) => task.priority == TaskPriority.low).length;
          
          final totalTasks = state.tasks.length;
          
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Priority Distribution',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                  if (totalTasks > 0) ...[
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 120,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.center,
                                maxY: totalTasks.toDouble(),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        String text = '';
                                        switch (value.toInt()) {
                                          case 0:
                                            text = 'Low';
                                            break;
                                          case 1:
                                            text = 'Medium';
                                            break;
                                          case 2:
                                            text = 'High';
                                            break;
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            text,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        );
                                      },
                                      reservedSize: 30,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      getTitlesWidget: (value, meta) {
                                        if (value % 1 == 0) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: AppColors.textSecondary,
                                            ),
                                          );
                                        }
                                        return const SizedBox();
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
                                  show: false,
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: [
                                  BarChartGroupData(
                                    x: 0,
                                    barRods: [
                                      BarChartRodData(
                                        toY: lowPriorityTasks.toDouble(),
                                        color: Colors.green,
                                        width: 20,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                        ),
                                      ),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 1,
                                    barRods: [
                                      BarChartRodData(
                                        toY: mediumPriorityTasks.toDouble(),
                                        color: AppColors.primary,
                                        width: 20,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                        ),
                                      ),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 2,
                                    barRods: [
                                      BarChartRodData(
                                        toY: highPriorityTasks.toDouble(),
                                        color: Colors.red,
                                        width: 20,
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
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPriorityLegend(
                                context,
                                'High Priority',
                                highPriorityTasks,
                                totalTasks,
                                Colors.red,
                              ),
                              SizedBox(height: AppTheme.spacing(2)),
                              _buildPriorityLegend(
                                context,
                                'Medium Priority',
                                mediumPriorityTasks,
                                totalTasks,
                                AppColors.primary,
                              ),
                              SizedBox(height: AppTheme.spacing(2)),
                              _buildPriorityLegend(
                                context,
                                'Low Priority',
                                lowPriorityTasks,
                                totalTasks,
                                Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const Center(
                      child: Text('No tasks available'),
                    ),
                  ],
                ],
              ),
            ),
          );
        } else {
          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Priority Distribution',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  const Center(
                    child: Text('Task data not available'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildPriorityLegend(
    BuildContext context,
    String title,
    int count,
    int total,
    Color color,
  ) {
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(0) : '0';
    
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: AppTheme.spacing(1)),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Text(
          '$count ($percentage%)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
