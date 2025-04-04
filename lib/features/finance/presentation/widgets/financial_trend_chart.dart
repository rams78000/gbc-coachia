import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/financial_summary.dart';

/// Widget affichant un graphique de tendance financière sur plusieurs périodes
class FinancialTrendChart extends StatefulWidget {
  final List<FinancialSummary> summaries;
  final FinancialPeriod period;
  final bool showIncome;
  final bool showExpenses;
  final bool showNetBalance;
  final Function(FinancialSummary)? onPeriodSelected;
  
  const FinancialTrendChart({
    Key? key,
    required this.summaries,
    required this.period,
    this.showIncome = true,
    this.showExpenses = true,
    this.showNetBalance = true,
    this.onPeriodSelected,
  }) : super(key: key);
  
  @override
  State<FinancialTrendChart> createState() => _FinancialTrendChartState();
}

class _FinancialTrendChartState extends State<FinancialTrendChart> {
  final List<bool> _selectedLines = [true, true, true]; // income, expenses, balance
  int _touchedSpotIndex = -1;
  
  @override
  void initState() {
    super.initState();
    _selectedLines[0] = widget.showIncome;
    _selectedLines[1] = widget.showExpenses;
    _selectedLines[2] = widget.showNetBalance;
  }
  
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
              // Titre et période
              Text(
                'Tendances financières',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              Text(
                'Par ${widget.period.getLocalizedName().toLowerCase()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              
              const SizedBox(height: 4.0),
              
              // Sélection des lignes à afficher
              Wrap(
                spacing: 8,
                children: [
                  _buildToggleChip(
                    index: 0, 
                    label: 'Revenus', 
                    color: Colors.green,
                  ),
                  _buildToggleChip(
                    index: 1, 
                    label: 'Dépenses', 
                    color: Colors.red,
                  ),
                  _buildToggleChip(
                    index: 2, 
                    label: 'Solde net', 
                    color: Colors.blue,
                  ),
                ],
              ),
              
              const SizedBox(height: 8.0),
              
              // Graphique
              Expanded(
                child: widget.summaries.isEmpty
                    ? _buildEmptyState(context)
                    : _buildChart(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Construit un toggle chip pour sélectionner/désélectionner une ligne
  Widget _buildToggleChip({
    required int index,
    required String label,
    required Color color,
  }) {
    return FilterChip(
      label: Text(label),
      labelStyle: TextStyle(
        color: _selectedLines[index] ? Colors.white : Colors.black87,
        fontSize: 12,
      ),
      selected: _selectedLines[index],
      onSelected: (selected) {
        setState(() {
          _selectedLines[index] = selected;
        });
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: color,
      checkmarkColor: Colors.white,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }
  
  /// Construit le graphique de tendance
  Widget _buildChart(BuildContext context) {
    // Trier les résumés par date
    final sortedSummaries = List<FinancialSummary>.from(widget.summaries)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    
    return LineChart(
      LineChartData(
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
        titlesData: FlTitlesData(
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
                final int index = value.toInt();
                if (index < 0 || index >= sortedSummaries.length) {
                  return const SizedBox();
                }
                
                // N'afficher qu'un nombre limité d'étiquettes pour éviter l'encombrement
                if (sortedSummaries.length > 6) {
                  if (index % (sortedSummaries.length ~/ 5) != 0 && 
                      index != sortedSummaries.length - 1) {
                    return const SizedBox();
                  }
                }
                
                final summary = sortedSummaries[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _formatPeriodLabel(summary.startDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                    ),
                  ),
                );
              },
              reservedSize: 24,
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
                
                // N'afficher que 3-4 valeurs sur l'axe Y
                final min = _getMinY();
                final max = _getMaxY();
                final range = max - min;
                final step = range / 3;
                
                if ((value - min).abs() < step / 2 || 
                    (value - (min + step)).abs() < step / 2 ||
                    (value - (min + 2 * step)).abs() < step / 2 ||
                    (value - max).abs() < step / 2) {
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
              reservedSize: 35,
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
        minX: 0,
        maxX: sortedSummaries.length - 1.0,
        minY: _getMinY(),
        maxY: _getMaxY(),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.barIndex;
                final summaryIndex = spot.x.toInt();
                
                if (summaryIndex < 0 || summaryIndex >= sortedSummaries.length) {
                  return null;
                }
                
                final summary = sortedSummaries[summaryIndex];
                String label;
                double value;
                Color color;
                
                if (index == 0) {
                  label = 'Revenus';
                  value = summary.totalIncome;
                  color = Colors.green;
                } else if (index == 1) {
                  label = 'Dépenses';
                  value = summary.totalExpenses;
                  color = Colors.red;
                } else {
                  label = 'Solde net';
                  value = summary.netBalance;
                  color = Colors.blue;
                }
                
                return LineTooltipItem(
                  label,
                  TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: '\n${NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(value)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: '\n${_formatPeriodLabel(summary.startDate)}',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (response == null || response.lineBarSpots == null) {
              setState(() {
                _touchedSpotIndex = -1;
              });
              return;
            }
            
            if (event is FlTapUpEvent && widget.onPeriodSelected != null) {
              final spot = response.lineBarSpots!.first;
              final index = spot.x.toInt();
              
              if (index >= 0 && index < sortedSummaries.length) {
                widget.onPeriodSelected!(sortedSummaries[index]);
              }
            }
            
            if (event is FlPanEndEvent || event is FlLongPressEnd) {
              setState(() {
                _touchedSpotIndex = -1;
              });
            } else if (response.lineBarSpots!.isNotEmpty) {
              setState(() {
                _touchedSpotIndex = response.lineBarSpots!.first.x.toInt();
              });
            }
          },
        ),
        lineBarsData: [
          // Ligne des revenus
          if (_selectedLines[0])
            _createLineSeries(
              sortedSummaries,
              (summary) => summary.totalIncome,
              Colors.green,
              0,
            ),
          
          // Ligne des dépenses
          if (_selectedLines[1])
            _createLineSeries(
              sortedSummaries,
              (summary) => summary.totalExpenses,
              Colors.red,
              1,
            ),
          
          // Ligne du solde net
          if (_selectedLines[2])
            _createLineSeries(
              sortedSummaries,
              (summary) => summary.netBalance,
              Colors.blue,
              2,
            ),
        ],
      ),
    );
  }
  
  /// Crée une série de données pour le graphique en ligne
  LineChartBarData _createLineSeries(
    List<FinancialSummary> summaries,
    double Function(FinancialSummary) getValue,
    Color color,
    int barIndex,
  ) {
    return LineChartBarData(
      spots: List.generate(summaries.length, (i) {
        final summary = summaries[i];
        return FlSpot(i.toDouble(), getValue(summary));
      }),
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          final isTouched = index == _touchedSpotIndex;
          
          return FlDotCirclePainter(
            radius: isTouched ? 5 : 3,
            color: color,
            strokeWidth: isTouched ? 2 : 0,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.1),
        cutOffY: 0,
        applyCutOffY: true,
      ),
    );
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
  
  /// Détermine la valeur maximale pour l'axe Y
  double _getMaxY() {
    if (widget.summaries.isEmpty) return 100;
    
    double maxValue = double.negativeInfinity;
    
    for (final summary in widget.summaries) {
      if (_selectedLines[0]) {
        maxValue = math.max(maxValue, summary.totalIncome);
      }
      if (_selectedLines[1]) {
        maxValue = math.max(maxValue, summary.totalExpenses);
      }
      if (_selectedLines[2] && summary.netBalance > 0) {
        maxValue = math.max(maxValue, summary.netBalance);
      }
    }
    
    // Valeur par défaut si aucune ligne n'est sélectionnée
    if (maxValue == double.negativeInfinity) maxValue = 100;
    
    // Ajouter une marge de 15%
    return maxValue * 1.15;
  }
  
  /// Détermine la valeur minimale pour l'axe Y (pour les soldes négatifs)
  double _getMinY() {
    if (widget.summaries.isEmpty || !_selectedLines[2]) return 0;
    
    double minValue = 0;
    
    for (final summary in widget.summaries) {
      if (summary.netBalance < 0) {
        minValue = math.min(minValue, summary.netBalance);
      }
    }
    
    // Ajouter une marge de 15%
    return minValue * 1.15;
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
  
  /// Affiche un état vide lorsqu'il n'y a pas de données
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
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