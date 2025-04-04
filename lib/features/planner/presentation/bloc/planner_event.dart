import 'package:equatable/equatable.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:gbc_coachia/features/planner/domain/entities/task.dart';

/// Événements du BLoC Planner
abstract class PlannerEvent extends Equatable {
  const PlannerEvent();

  @override
  List<Object?> get props => [];
}

/// Événement pour charger les événements d'une période
class LoadEvents extends PlannerEvent {
  final DateTime start;
  final DateTime end;

  const LoadEvents({required this.start, required this.end});

  @override
  List<Object?> get props => [start, end];
}

/// Événement pour ajouter ou mettre à jour un événement
class SaveEvent extends PlannerEvent {
  final Event event;

  const SaveEvent({required this.event});

  @override
  List<Object?> get props => [event];
}

/// Événement pour supprimer un événement
class DeleteEvent extends PlannerEvent {
  final String id;

  const DeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Événement pour charger toutes les tâches
class LoadTasks extends PlannerEvent {
  const LoadTasks();
}

/// Événement pour ajouter ou mettre à jour une tâche
class SaveTask extends PlannerEvent {
  final Task task;

  const SaveTask({required this.task});

  @override
  List<Object?> get props => [task];
}

/// Événement pour supprimer une tâche
class DeleteTask extends PlannerEvent {
  final String id;

  const DeleteTask({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Événement pour marquer une tâche comme terminée
class CompleteTask extends PlannerEvent {
  final String id;

  const CompleteTask({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Événement pour générer un plan optimisé
class GenerateOptimizedPlan extends PlannerEvent {
  final DateTime date;

  const GenerateOptimizedPlan({required this.date});

  @override
  List<Object?> get props => [date];
}

/// Événement pour passer à un onglet spécifique
class ChangeTab extends PlannerEvent {
  final int index;

  const ChangeTab({required this.index});

  @override
  List<Object?> get props => [index];
}

/// Événement pour changer de mois dans le calendrier
class ChangeMonth extends PlannerEvent {
  final DateTime month;

  const ChangeMonth({required this.month});

  @override
  List<Object?> get props => [month];
}

/// Événement pour changer de vue dans le calendrier
class ChangeView extends PlannerEvent {
  final String view; // 'day', 'week', 'month'

  const ChangeView({required this.view});

  @override
  List<Object?> get props => [view];
}
