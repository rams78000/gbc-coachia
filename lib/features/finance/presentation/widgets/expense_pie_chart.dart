import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../domain/entities/transaction.dart';

/// Widget affichant un graphique en camembert pour les dépenses par catégorie
class ExpensePieChart extends StatefulWidget {
  final Map<TransactionCategory, double> expensesByCategory;
  final Function(TransactionCategory)? onCategorySelected;
  
  const ExpensePieChart({
    Key? key,
    required this.expensesByCategory,
    this.onCategorySelected,
  }) : super(key: key);
  
  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int? touchedIndex;
  
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              Text(
                'Répartition des dépenses',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              
              const SizedBox(height: 8.0),
              
              // Graphique
              Expanded(
                child: widget.expensesByCategory.isEmpty
                    ? _buildEmptyState()
                    : Row(
                        children: [
                          // Graphique en camembert
                          Expanded(child: _buildPieChart()),
                          
                          // Légende
                          _buildLegend(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Construit le graphique en camembert
  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              
              if (touchedIndex != null && touchedIndex! >= 0 && event is FlTapUpEvent) {
                final categories = widget.expensesByCategory.keys.toList();
                if (touchedIndex! < categories.length && widget.onCategorySelected != null) {
                  widget.onCategorySelected!(categories[touchedIndex!]);
                }
              }
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: _buildPieSections(),
      ),
    );
  }
  
  /// Construit les sections du graphique en camembert
  List<PieChartSectionData> _buildPieSections() {
    final categories = widget.expensesByCategory.keys.toList();
    final percentages = widget.expensesByCategory.entries
        .map((e) => (e.value / widget.expensesByCategory.values.fold(0, (sum, value) => sum + value)) * 100)
        .toList();
    
    return List.generate(categories.length, (i) {
      final isTouched = touchedIndex == i;
      final radius = isTouched ? 60.0 : 50.0;
      
      return PieChartSectionData(
        color: categories[i].getColor(),
        value: percentages[i],
        title: '${percentages[i].toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 16 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: isTouched
            ? Icon(
                categories[i].getIcon(),
                color: categories[i].getColor(),
                size: 24,
              )
            : null,
        badgePositionPercentageOffset: 1.1,
      );
    });
  }
  
  /// Construit la légende du graphique
  Widget _buildLegend() {
    final categories = widget.expensesByCategory.keys.toList();
    categories.sort((a, b) => widget.expensesByCategory[b]!.compareTo(widget.expensesByCategory[a]!));
    
    // Limiter à 6 catégories + "Autres" si nécessaire
    List<TransactionCategory> displayCategories;
    if (categories.length > 6) {
      displayCategories = categories.sublist(0, 5);
      // Calculer le reste
      final otherAmount = categories.sublist(5).fold(
        0.0,
        (sum, category) => sum + widget.expensesByCategory[category]!,
      );
      // Ajouter une indication "Autres" 
      // (on utilise une catégorie existante comme placeholder)
      widget.expensesByCategory[TransactionCategory.other_expense] = otherAmount;
      displayCategories.add(TransactionCategory.other_expense);
    } else {
      displayCategories = categories;
    }
    
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: displayCategories.map((category) {
          final isOther = category == TransactionCategory.other_expense && 
                          !categories.sublist(0, 5).contains(TransactionCategory.other_expense);
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: category.getColor(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isOther ? 'Autres' : category.getLocalizedName(),
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  
  /// Affiche un état vide lorsqu'il n'y a pas de données
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart_outline,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'Aucune dépense à afficher',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
