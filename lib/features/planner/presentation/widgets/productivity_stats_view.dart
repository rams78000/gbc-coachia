import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/productivity_stats.dart';
import '../../domain/entities/task.dart';

/// Widget affichant les statistiques de productivité
class ProductivityStatsView extends StatelessWidget {
  /// Statistiques de productivité à afficher
  final ProductivityStats stats;
  
  /// Date de début de la période
  final DateTime startDate;
  
  /// Date de fin de la période
  final DateTime endDate;
  
  /// Constructeur
  const ProductivityStatsView({
    Key? key,
    required this.stats,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startString = DateFormat.yMMMd('fr_FR').format(startDate);
    final endString = DateFormat.yMMMd('fr_FR').format(endDate);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistiques de productivité',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Période: $startString - $endString',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        
        // Cartes de statistiques principales
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildMainStatCard(
                context,
                'Productivité moyenne',
                '${stats.averageProductivity.toStringAsFixed(0)}%',
                Icons.trending_up,
                theme.colorScheme.primary,
              ),
              const SizedBox(width: 16),
              _buildMainStatCard(
                context,
                'Tâches complétées',
                '${stats.completedTasks} / ${stats.totalTasks}',
                Icons.task_alt,
                Colors.green,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Graphique de productivité quotidienne
        if (stats.dailyProductivity.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Productivité quotidienne',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildProductivityChart(context),
            ),
          ),
          const SizedBox(height: 24),
        ],
        
        // Répartition des tâches par catégorie
        if (stats.tasksByCategory.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Répartition des tâches par catégorie',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: _buildCategoryDistribution(context),
          ),
          const SizedBox(height: 24),
        ],
        
        // Répartition des tâches par priorité
        if (stats.tasksByPriority.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Répartition des tâches par priorité',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: _buildPriorityDistribution(context),
          ),
          const SizedBox(height: 24),
        ],
        
        // Heures productives
        if (stats.productiveHours.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Heures les plus productives',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: _buildProductiveHoursChart(context),
          ),
          const SizedBox(height: 24),
        ],
        
        // Conseils de productivité
        if (stats.productivityTips.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              color: theme.colorScheme.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Conseils pour améliorer votre productivité',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...stats.productivityTips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(child: Text(tip)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
  
  /// Construit une carte de statistique principale
  Widget _buildMainStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Construit le graphique de productivité quotidienne
  Widget _buildProductivityChart(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('E d', 'fr_FR');
    
    // Calculer la valeur maximale pour l'échelle
    final maxValue = stats.dailyProductivity.isEmpty
        ? 100.0
        : stats.dailyProductivity.values
            .reduce((max, value) => max > value ? max : value);
    
    return Column(
      children: [
        // Graphique
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Axe Y
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('100%', style: theme.textTheme.bodySmall),
                  Text('75%', style: theme.textTheme.bodySmall),
                  Text('50%', style: theme.textTheme.bodySmall),
                  Text('25%', style: theme.textTheme.bodySmall),
                  Text('0%', style: theme.textTheme.bodySmall),
                ],
              ),
              
              const SizedBox(width: 8),
              
              // Barres
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: stats.dailyProductivity.entries.map((entry) {
                    final date = entry.key;
                    final value = entry.value;
                    final isToday = date.year == DateTime.now().year &&
                        date.month == DateTime.now().month &&
                        date.day == DateTime.now().day;
                    
                    // Hauteur relative de la barre
                    final heightPercentage = value / maxValue;
                    
                    return Tooltip(
                      message: '${dateFormat.format(date).capitalize()}: ${value.toStringAsFixed(0)}%',
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 160 * heightPercentage,
                            decoration: BoxDecoration(
                              color: isToday
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.primary.withOpacity(0.7),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormat.format(date).substring(0, 1),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: isToday ? FontWeight.bold : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        
        // Légende
        const SizedBox(height: 8),
        Container(
          height: 1,
          color: theme.dividerColor,
        ),
      ],
    );
  }
  
  /// Construit la répartition des tâches par catégorie
  Widget _buildCategoryDistribution(BuildContext context) {
    final theme = Theme.of(context);
    
    // Couleurs pour différentes catégories
    final categoryColors = {
      TaskCategory.work: Colors.blue,
      TaskCategory.personal: Colors.green,
      TaskCategory.admin: Colors.purple,
      TaskCategory.learning: Colors.orange,
      TaskCategory.health: Colors.red,
      TaskCategory.meeting: Colors.teal,
      TaskCategory.other: Colors.grey,
    };
    
    // Etiquettes pour différentes catégories
    final categoryLabels = {
      TaskCategory.work: 'Travail',
      TaskCategory.personal: 'Personnel',
      TaskCategory.admin: 'Admin',
      TaskCategory.learning: 'Apprentissage',
      TaskCategory.health: 'Santé',
      TaskCategory.meeting: 'Réunions',
      TaskCategory.other: 'Autre',
    };
    
    return Row(
      children: [
        // Graphique en anneau
        Expanded(
          flex: 6,
          child: CustomPaint(
            painter: PieChartPainter(
              stats.tasksByCategory.map((category, count) => MapEntry(
                category,
                count / stats.totalTasks,
              )),
              categoryColors,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    stats.totalTasks.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'tâches au total',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Légende
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: stats.tasksByCategory.entries.map((entry) {
              final category = entry.key;
              final count = entry.value;
              final percentage = count / stats.totalTasks * 100;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: categoryColors[category] ?? Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        categoryLabels[category] ?? 'Autre',
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  /// Construit la répartition des tâches par priorité
  Widget _buildPriorityDistribution(BuildContext context) {
    final theme = Theme.of(context);
    
    // Couleurs pour différentes priorités
    final priorityColors = {
      TaskPriority.veryLow: Colors.grey,
      TaskPriority.low: Colors.blue,
      TaskPriority.medium: Colors.green,
      TaskPriority.high: Colors.orange,
      TaskPriority.veryHigh: Colors.red,
    };
    
    // Etiquettes pour différentes priorités
    final priorityLabels = {
      TaskPriority.veryLow: 'Très basse (P1)',
      TaskPriority.low: 'Basse (P2)',
      TaskPriority.medium: 'Moyenne (P3)',
      TaskPriority.high: 'Haute (P4)',
      TaskPriority.veryHigh: 'Très haute (P5)',
    };
    
    return Row(
      children: [
        // Graphique en anneau
        Expanded(
          flex: 6,
          child: CustomPaint(
            painter: PieChartPainter(
              stats.tasksByPriority.map((priority, count) => MapEntry(
                priority,
                count / stats.totalTasks,
              )),
              priorityColors,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    stats.totalTasks.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'tâches au total',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Légende
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: stats.tasksByPriority.entries.map((entry) {
              final priority = entry.key;
              final count = entry.value;
              final percentage = count / stats.totalTasks * 100;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: priorityColors[priority] ?? Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        priorityLabels[priority] ?? 'Autre',
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  /// Construit le graphique des heures productives
  Widget _buildProductiveHoursChart(BuildContext context) {
    final theme = Theme.of(context);
    
    // Calculer la valeur maximale pour l'échelle
    final maxValue = stats.productiveHours.isEmpty
        ? 100.0
        : stats.productiveHours.values
            .reduce((max, value) => max > value ? max : value);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Axe Y
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('100%', style: theme.textTheme.bodySmall),
            Text('50%', style: theme.textTheme.bodySmall),
            Text('0%', style: theme.textTheme.bodySmall),
          ],
        ),
        
        const SizedBox(width: 8),
        
        // Barres
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: stats.productiveHours.entries.map((entry) {
              final hour = entry.key;
              final value = entry.value;
              
              // Formatter l'heure
              final hourString = hour < 10 ? '0$hour:00' : '$hour:00';
              
              // Hauteur relative de la barre
              final heightPercentage = value / maxValue;
              
              return Tooltip(
                message: '$hourString: ${value.toStringAsFixed(0)}%',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 100 * heightPercentage,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.5),
                            theme.colorScheme.primary,
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hourString,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Peintre pour graphique en camembert
class PieChartPainter extends CustomPainter {
  /// Données du graphique (clé -> pourcentage)
  final Map<dynamic, double> data;
  
  /// Couleurs correspondantes aux clés
  final Map<dynamic, Color> colors;
  
  /// Constructeur
  PieChartPainter(this.data, this.colors);
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width < size.height
        ? size.width * 0.35
        : size.height * 0.35;
    final innerRadius = radius * 0.6;
    
    final rect = Rect.fromCircle(
      center: Offset(centerX, centerY),
      radius: radius,
    );
    
    var startAngle = -90.0 * (3.14159 / 180); // Commencer à -90 degrés (en haut)
    
    // Dessiner les segments
    data.forEach((key, value) {
      final sweepAngle = value * 2 * 3.14159;
      final color = colors[key] ?? Colors.grey;
      
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    });
    
    // Dessiner le trou central pour faire un donut
    canvas.drawCircle(
      Offset(centerX, centerY),
      innerRadius,
      Paint()..color = Colors.white,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// Extension pour capitaliser une chaîne
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
