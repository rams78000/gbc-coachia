import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:gbc_coachia/features/planner/domain/entities/optimized_plan.dart';
import 'package:gbc_coachia/features/planner/domain/entities/task.dart';

/// Interface pour le repository du planificateur
abstract class PlannerRepository {
  /// Récupère tous les événements pour une période donnée
  Future<List<Event>> getEvents(DateTime start, DateTime end);
  
  /// Récupère un événement par son ID
  Future<Event?> getEventById(String id);
  
  /// Ajoute ou met à jour un événement
  Future<void> saveEvent(Event event);
  
  /// Supprime un événement
  Future<void> deleteEvent(String id);
  
  /// Récupère toutes les tâches
  Future<List<Task>> getTasks();
  
  /// Récupère une tâche par son ID
  Future<Task?> getTaskById(String id);
  
  /// Ajoute ou met à jour une tâche
  Future<void> saveTask(Task task);
  
  /// Supprime une tâche
  Future<void> deleteTask(String id);
  
  /// Marque une tâche comme terminée
  Future<void> completeTask(String id);
  
  /// Génère un plan optimisé basé sur les tâches et événements
  Future<OptimizedPlan> generateOptimizedPlan(DateTime date);
}
