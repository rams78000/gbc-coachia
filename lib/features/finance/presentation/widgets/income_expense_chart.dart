import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/financial_summary.dart';

/// Widget affichant un graphique comparatif des revenus et dépenses sur plusieurs périodes
class IncomeExpenseChart extends StatelessWidget {
  final List<FinancialSummary> summaries;
  final FinancialPeriod period;
  
  const IncomeExpenseChart({
    Key? key,
    required this.summaries,
    required this.period,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              Text(
                'Revenus vs Dépenses',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              
              // Période
              Text(
                'Par ${period.getLocalizedName().toLowerCase()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              
              const SizedBox(height: 16.0),
              
              // Graphique
              Expanded(
                child: summaries.isEmpty
                    ? _buildEmptyState(context)
                    : _buildChart(context),
              ),
              
              // Légende
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(context, 'Revenus', Colors.green),
                  const SizedBox(width: 24.0),
                  _buildLegendItem(context, 'Dépenses', Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Construit le graphique de comparaison
  Widget _buildChart(BuildContext context) {
    // Inverser l'ordre pour afficher les périodes les plus anciennes à gauche
    final reversedSummaries = summaries.reversed.toList();
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final currencyFormat = NumberFormat.currency(
                locale: 'fr_FR',
                symbol: '€',
                decimalDigits: 0,
              );
              
              final summary = reversedSummaries[groupIndex];
              final value = rodIndex == 0 ? summary.totalIncome : summary.totalExpenses;
              
              return BarTooltipItem(
                currencyFormat.format(value),
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
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
                if (value < 0 || value >= reversedSummaries.length) {
                  return const SizedBox();
                }
                
                final summary = reversedSummaries[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _formatPeriodLabel(summary.startDate),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          reversedSummaries.length,
          (index) => _generateBarGroup(index, reversedSummaries[index]),
        ),
        gridData: const FlGridData(show: false),
      ),
    );
  }
  
  /// Génère un groupe de barres pour une période
  BarChartGroupData _generateBarGroup(int x, FinancialSummary summary) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: summary.totalIncome,
          color: Colors.green,
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        BarChartRodData(
          toY: summary.totalExpenses,
          color: Colors.red,
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
  
  /// Détermine la valeur maximale pour l'axe Y
  double _getMaxY() {
    double maxValue = 0;
    
    for (final summary in summaries) {
      maxValue = math.max(maxValue, summary.totalIncome);
      maxValue = math.max(maxValue, summary.totalExpenses);
    }
    
    // Ajouter une marge de 20%
    return maxValue * 1.2;
  }
  
  /// Formate l'étiquette de période en fonction du type de période
  String _formatPeriodLabel(DateTime date) {
    switch (period) {
      case FinancialPeriod.daily:
        return DateFormat('dd/MM').format(date);
      case FinancialPeriod.weekly:
        return 'S${_getWeekNumber(date)}';
      case FinancialPeriod.monthly:
        return DateFormat('MMM').format(date);
      case FinancialPeriod.quarterly:
        final quarter = ((date.month - 1) ~/ 3) + 1;
        return 'T$quarter';
      case FinancialPeriod.yearly:
        return date.year.toString();
      default:
        return DateFormat('MMM').format(date);
    }
  }
  
  /// Calcule le numéro de semaine dans l'année
  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(firstDayOfYear).inDays;
    return ((dayOfYear + firstDayOfYear.weekday - 1) / 7).ceil();
  }
  
  /// Construit un élément de légende
  Widget _buildLegendItem(BuildContext context, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
  
  /// Affiche un état vide lorsqu'il n'y a pas de données
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'Aucune donnée à afficher',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// Ajout de 'math' pour éviter l'erreur de compilation
import 'dart:math' as math;
