import 'package:equatable/equatable.dart';

import 'task.dart';

/// Entité représentant des statistiques de productivité
class ProductivityStats extends Equatable {
  /// Nombre total de tâches
  final int totalTasks;
  
  /// Nombre de tâches complétées
  final int completedTasks;
  
  /// Productivité moyenne (0-100)
  final double averageProductivity;
  
  /// Productivité par jour (clé: date, valeur: score)
  final Map<DateTime, double> dailyProductivity;
  
  /// Répartition des tâches par catégorie
  final Map<TaskCategory, int> tasksByCategory;
  
  /// Répartition des tâches par priorité
  final Map<TaskPriority, int> tasksByPriority;
  
  /// Répartition des heures productives
  final Map<int, double> productiveHours;
  
  /// Conseils pour améliorer la productivité
  final List<String> productivityTips;
  
  /// Constructeur
  const ProductivityStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.averageProductivity,
    required this.dailyProductivity,
    required this.tasksByCategory,
    required this.tasksByPriority,
    required this.productiveHours,
    this.productivityTips = const [],
  });
  
  /// Calcule le taux de complétion des tâches
  double get completionRate {
    if (totalTasks == 0) return 0.0;
    return completedTasks / totalTasks;
  }
  
  @override
  List<Object?> get props => [
    totalTasks,
    completedTasks,
    averageProductivity,
    dailyProductivity,
    tasksByCategory,
    tasksByPriority,
    productiveHours,
    productivityTips,
  ];
}
