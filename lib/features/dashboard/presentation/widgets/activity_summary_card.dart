import 'package:flutter/material.dart';
import 'package:gbc_coachai/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:fl_chart/fl_chart.dart';

class ActivitySummaryCard extends StatelessWidget {
  final ActivitySummary activitySummary;

  const ActivitySummaryCard({
    Key? key,
    required this.activitySummary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.analytics,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 8),
                Text(
                  'Résumé d\'activité',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Activity counts
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildActivityMetric(
                      context,
                      'Événements',
                      '${activitySummary.completedEvents}/${activitySummary.totalEvents}',
                      Icons.event,
                      Colors.blue,
                      activitySummary.totalEvents > 0
                          ? (activitySummary.completedEvents / activitySummary.totalEvents)
                          : 0,
                    ),
                    const SizedBox(width: 16),
                    _buildActivityMetric(
                      context,
                      'Documents',
                      '${activitySummary.totalDocuments}',
                      Icons.insert_drive_file,
                      Colors.amber,
                      1,
                      showProgress: false,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildActivityMetric(
                      context,
                      'Transactions',
                      '${activitySummary.totalTransactions}',
                      Icons.receipt_long,
                      Colors.green,
                      1,
                      showProgress: false,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
          
          // Category usage chart
          if (activitySummary.categoryUsage.isNotEmpty)
            Container(
              height: 220,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: _buildCategoryUsageChart(context),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityMetric(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    double progress, {
    bool showProgress = true,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (showProgress) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                borderRadius: BorderRadius.circular(2),
              ),
              const SizedBox(height: 4),
              Text(
                'Complétés',
                style: TextStyle(
                  fontSize: 10,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryUsageChart(BuildContext context) {
    if (activitySummary.categoryUsage.isEmpty) {
      return const Center(
        child: Text('Aucune donnée disponible'),
      );
    }

    final categories = activitySummary.categoryUsage;
    // Sort by percentage (highest first)
    categories.sort((a, b) => b.percentage.compareTo(a.percentage));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Répartition des transactions par catégorie',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              // Pie chart
              Expanded(
                flex: 3,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: _generatePieChartSections(categories),
                  ),
                ),
              ),
              
              // Legend
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categories
                        .take(5) // Show top 5 categories
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _buildLegendItem(
                              context,
                              category.category,
                              category.percentage,
                              _getCategoryColor(categories.indexOf(category)),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generatePieChartSections(
      List<CategoryUsage> categories) {
    final List<PieChartSectionData> sections = [];
    
    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      
      // Only show top 5 categories, group others
      if (i < 5) {
        sections.add(
          PieChartSectionData(
            value: category.percentage,
            title: '',
            radius: 50,
            color: _getCategoryColor(i),
          ),
        );
      } else {
        // If we already have an "Autres" category, update its value
        final otherIndex = sections.indexWhere((section) => section.title == 'Autres');
        if (otherIndex != -1) {
          final otherSection = sections[otherIndex];
          sections[otherIndex] = PieChartSectionData(
            value: otherSection.value + category.percentage,
            title: 'Autres',
            radius: 50,
            color: Colors.grey,
          );
        } else {
          // Otherwise, create a new "Autres" category
          sections.add(
            PieChartSectionData(
              value: category.percentage,
              title: 'Autres',
              radius: 50,
              color: Colors.grey,
            ),
          );
        }
      }
    }
    
    return sections;
  }

  Widget _buildLegendItem(
    BuildContext context,
    String category,
    double percentage,
    Color color,
  ) {
    return Row(
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
        Expanded(
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.brown,
    ];
    
    return index < colors.length ? colors[index] : Colors.grey;
  }
}
