import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/financial_summary.dart';

/// Widget affichant un graphique de flux de trésorerie (revenus - dépenses = flux)
class CashFlowChart extends StatefulWidget {
  final List<FinancialSummary> summaries;
  final FinancialPeriod period;
  final bool showNetBalance;
  final bool interactive;
  final Function(FinancialSummary)? onPeriodSelected;
  
  const CashFlowChart({
    Key? key,
    required this.summaries,
    required this.period,
    this.showNetBalance = true,
    this.interactive = true,
    this.onPeriodSelected,
  }) : super(key: key);
  
  @override
  State<CashFlowChart> createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  int? touchedIndex;
  
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre et icône interactive
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Flux de trésorerie',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.interactive)
                    IconButton(
                      icon: const Icon(Icons.info_outline, size: 20),
                      onPressed: () {
                        _showFlowChartInfo(context);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                    ),
                ],
              ),
              
              // Période
              Text(
                'Par ${widget.period.getLocalizedName().toLowerCase()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              
              const SizedBox(height: 16.0),
              
              // Graphique
              Expanded(
                child: widget.summaries.isEmpty
                    ? _buildEmptyState(context)
                    : _buildChart(context),
              ),
              
              // Légende
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(context, 'Revenus', Colors.green),
                  const SizedBox(width: 16.0),
                  _buildLegendItem(context, 'Dépenses', Colors.red),
                  if (widget.showNetBalance) ...[
                    const SizedBox(width: 16.0),
                    _buildLegendItem(context, 'Flux net', Colors.blue),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Construit le graphique de flux de trésorerie
  Widget _buildChart(BuildContext context) {
    // Inverser l'ordre pour afficher les périodes les plus anciennes à gauche
    final reversedSummaries = widget.summaries.reversed.toList();
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        minY: _getMinY(),
        barTouchData: BarTouchData(
          enabled: widget.interactive,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey.shade800,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final currencyFormat = NumberFormat.currency(
                locale: 'fr_FR',
                symbol: '€',
                decimalDigits: 0,
              );
              
              final summary = reversedSummaries[groupIndex];
              double value;
              
              if (rodIndex == 0) {
                value = summary.totalIncome;
              } else if (rodIndex == 1) {
                value = summary.totalExpenses;
              } else {
                value = summary.netBalance;
              }
              
              String label;
              if (rodIndex == 0) {
                label = 'Revenus';
              } else if (rodIndex == 1) {
                label = 'Dépenses';
              } else {
                label = 'Solde net';
              }
              
              return BarTooltipItem(
                '$label:\n${currencyFormat.format(value)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            if (!widget.interactive || widget.onPeriodSelected == null) return;
            
            setState(() {
              if (barTouchResponse == null || 
                  barTouchResponse.spot == null || 
                  event is! FlTapUpEvent) {
                touchedIndex = -1;
                return;
              }
              
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
              if (touchedIndex != null && touchedIndex! >= 0 && 
                  touchedIndex! < reversedSummaries.length) {
                widget.onPeriodSelected!(reversedSummaries[touchedIndex!]);
              }
            });
          },
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
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final currencyFormat = NumberFormat.compactCurrency(
                  locale: 'fr_FR',
                  symbol: '€',
                );
                
                // N'afficher que quelques valeurs pour éviter l'encombrement
                if (value == 0 || value == _getMaxY() || value == _getMinY()) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      currencyFormat.format(value),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }
                
                return const SizedBox();
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
            left: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _getGridInterval(),
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade100,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        barGroups: List.generate(
          reversedSummaries.length, 
          (index) => _generateBarGroup(index, reversedSummaries[index], touchedIndex == index),
        ),
      ),
    );
  }
  
  /// Génère un groupe de barres pour une période
  BarChartGroupData _generateBarGroup(int x, FinancialSummary summary, bool isTouched) {
    // Liste des BarChartRodData à afficher
    final List<BarChartRodData> barRods = [];
    
    // Barre de revenus (toujours positive)
    barRods.add(BarChartRodData(
      toY: summary.totalIncome,
      color: Colors.green,
      width: isTouched ? 18 : 14,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
    ));
    
    // Barre de dépenses (toujours positive, pour l'affichage)
    barRods.add(BarChartRodData(
      toY: summary.totalExpenses,
      color: Colors.red,
      width: isTouched ? 18 : 14,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
    ));
    
    // Barre de solde net (peut être positive ou négative)
    if (widget.showNetBalance) {
      final netBalance = summary.netBalance;
      barRods.add(BarChartRodData(
        toY: netBalance,
        color: netBalance >= 0 ? Colors.blue : Colors.orange,
        width: isTouched ? 18 : 14,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ));
    }
    
    return BarChartGroupData(
      x: x,
      barRods: barRods,
      showingTooltipIndicators: isTouched ? [0, 1, if (widget.showNetBalance) 2] : [],
    );
  }
  
  /// Détermine la valeur maximale pour l'axe Y
  double _getMaxY() {
    double maxValue = 0;
    
    for (final summary in widget.summaries) {
      maxValue = maxValue.compareTo(summary.totalIncome) < 0 ? summary.totalIncome : maxValue;
      maxValue = maxValue.compareTo(summary.totalExpenses) < 0 ? summary.totalExpenses : maxValue;
      if (widget.showNetBalance && summary.netBalance > 0) {
        maxValue = maxValue.compareTo(summary.netBalance) < 0 ? summary.netBalance : maxValue;
      }
    }
    
    // Ajouter une marge de 20%
    return maxValue * 1.2;
  }
  
  /// Détermine la valeur minimale pour l'axe Y (pour les soldes négatifs)
  double _getMinY() {
    if (!widget.showNetBalance) return 0;
    
    double minValue = 0;
    
    for (final summary in widget.summaries) {
      if (summary.netBalance < 0) {
        minValue = minValue.compareTo(summary.netBalance) > 0 ? summary.netBalance : minValue;
      }
    }
    
    // Ajouter une marge de 20%
    return minValue * 1.2;
  }
  
  /// Calcule l'intervalle pour les lignes de la grille
  double _getGridInterval() {
    final range = _getMaxY() - _getMinY();
    // Essayer de limiter à 5-7 lignes horizontales
    if (range <= 5) return 1;
    if (range <= 10) return 2;
    if (range <= 50) return 10;
    if (range <= 100) return 20;
    if (range <= 500) return 100;
    if (range <= 1000) return 200;
    return (range / 5).roundToDouble();
  }
  
  /// Formate l'étiquette de période en fonction du type de période
  String _formatPeriodLabel(DateTime date) {
    switch (widget.period) {
      case FinancialPeriod.daily:
        return DateFormat('dd/MM').format(date);
      case FinancialPeriod.weekly:
        return 'S${_getWeekNumber(date)}';
      case FinancialPeriod.monthly:
        return DateFormat('MMM', 'fr').format(date);
      case FinancialPeriod.quarterly:
        final quarter = ((date.month - 1) ~/ 3) + 1;
        return 'T$quarter';
      case FinancialPeriod.yearly:
        return date.year.toString();
      default:
        return DateFormat('MMM', 'fr').format(date);
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
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
  
  /// Affiche une boîte de dialogue d'information sur le graphique de flux
  void _showFlowChartInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Flux de trésorerie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ce graphique montre vos revenus et dépenses par période, ainsi que le solde net (flux de trésorerie).',
            ),
            const SizedBox(height: 16),
            _buildLegendExplanation(
              context, 
              'Revenus', 
              'Tous les fonds entrants (paiements reçus, etc.)',
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildLegendExplanation(
              context, 
              'Dépenses', 
              'Tous les fonds sortants (factures, achats, etc.)',
              Colors.red,
            ),
            if (widget.showNetBalance) ...[
              const SizedBox(height: 8),
              _buildLegendExplanation(
                context, 
                'Flux net', 
                'Différence entre revenus et dépenses (positif = bénéfice)',
                Colors.blue,
              ),
            ],
            const SizedBox(height: 16),
            if (widget.interactive && widget.onPeriodSelected != null)
              const Text(
                'Conseil: Touchez une barre pour voir les détails de la période correspondante.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
  
  /// Construit une explication de légende pour la boîte de dialogue d'information
  Widget _buildLegendExplanation(
    BuildContext context, 
    String title, 
    String description, 
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}