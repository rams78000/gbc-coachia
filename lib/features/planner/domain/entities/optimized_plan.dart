import 'package:equatable/equatable.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:gbc_coachia/features/planner/domain/entities/task.dart';

/// Modèle pour un créneau horaire dans un plan optimisé
class TimeSlot extends Equatable {
  /// Heure de début du créneau
  final DateTime startTime;
  
  /// Heure de fin du créneau
  final DateTime endTime;
  
  /// Tâche associée au créneau (peut être null)
  final Task? task;
  
  /// Événement associé au créneau (peut être null)
  final Event? event;
  
  /// Type de créneau (tâche, événement, pause, etc.)
  final String type;
  
  /// Constructeur
  const TimeSlot({
    required this.startTime,
    required this.endTime,
    this.task,
    this.event,
    required this.type,
  });
  
  @override
  List<Object?> get props => [startTime, endTime, task, event, type];
}

/// Modèle pour un plan journalier optimisé
class OptimizedPlan extends Equatable {
  /// Date du plan
  final DateTime date;
  
  /// Liste des créneaux horaires
  final List<TimeSlot> timeSlots;
  
  /// Score d'efficacité du plan (0-100)
  final int efficiencyScore;
  
  /// Nombre total de tâches prioritaires incluses
  final int priorityTasksIncluded;
  
  /// Temps total alloué au travail focalisé (en minutes)
  final int focusedWorkTime;
  
  /// Temps total alloué aux pauses (en minutes)
  final int breakTime;
  
  /// Commentaires de l'IA sur le plan
  final String aiComments;
  
  /// Constructeur
  const OptimizedPlan({
    required this.date,
    required this.timeSlots,
    required this.efficiencyScore,
    required this.priorityTasksIncluded,
    required this.focusedWorkTime,
    required this.breakTime,
    required this.aiComments,
  });
  
  @override
  List<Object?> get props => [
    date, 
    timeSlots, 
    efficiencyScore, 
    priorityTasksIncluded, 
    focusedWorkTime, 
    breakTime, 
    aiComments,
  ];
}
