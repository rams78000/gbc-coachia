import 'package:equatable/equatable.dart';

import 'event.dart';
import 'task.dart';

/// Entité représentant un planning optimisé
class OptimizedSchedule extends Equatable {
  /// Blocs de temps du planning
  final List<TimeBlock> timeBlocks;
  
  /// Tâches associées au planning
  final List<Task> tasks;
  
  /// Événements associés au planning
  final List<Event> events;
  
  /// Date du planning
  final DateTime date;
  
  /// Stratégie d'optimisation utilisée
  final OptimizationStrategy strategy;
  
  /// Productivité estimée (0-100)
  final double estimatedProductivity;
  
  /// Temps total de pause en minutes
  final int totalBreakTime;
  
  /// Score d'équilibre (1-10)
  final double balanceScore;
  
  /// Conseils pour la journée
  final List<String> tips;
  
  /// Constructeur
  const OptimizedSchedule({
    required this.timeBlocks,
    required this.tasks,
    required this.events,
    required this.date,
    required this.strategy,
    required this.estimatedProductivity,
    required this.totalBreakTime,
    required this.balanceScore,
    this.tips = const [],
  });
  
  @override
  List<Object?> get props => [
    timeBlocks,
    tasks,
    events,
    date,
    strategy,
    estimatedProductivity,
    totalBreakTime,
    balanceScore,
    tips,
  ];
}

/// Bloc de temps dans un planning optimisé
class TimeBlock extends Equatable {
  /// Heure de début
  final DateTime start;
  
  /// Heure de fin
  final DateTime end;
  
  /// Type de bloc
  final TimeBlockType type;
  
  /// Titre du bloc
  final String title;
  
  /// Description du bloc
  final String description;
  
  /// ID de la tâche associée (si applicable)
  final String? relatedTaskId;
  
  /// ID de l'événement associé (si applicable)
  final String? relatedEventId;
  
  /// Constructeur
  const TimeBlock({
    required this.start,
    required this.end,
    required this.type,
    required this.title,
    this.description = '',
    this.relatedTaskId,
    this.relatedEventId,
  });
  
  /// Durée en minutes
  int get durationMinutes {
    return end.difference(start).inMinutes;
  }
  
  @override
  List<Object?> get props => [
    start,
    end,
    type,
    title,
    description,
    relatedTaskId,
    relatedEventId,
  ];
}

/// Types de blocs de temps
enum TimeBlockType {
  /// Tâche
  task,
  
  /// Événement
  event,
  
  /// Pause
  break,
  
  /// Temps de concentration
  focusTime,
}

/// Stratégies d'optimisation
enum OptimizationStrategy {
  /// Optimisation pour la productivité maximale
  productivity,
  
  /// Optimisation pour l'équilibre travail-vie
  balance,
  
  /// Optimisation pour la gestion d'énergie
  energy,
}
