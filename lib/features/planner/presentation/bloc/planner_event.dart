import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';

/// Abstract class for Planner events
abstract class PlannerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to load all tasks
class LoadTasksEvent extends PlannerEvent {}

/// Event to load tasks by status
class LoadTasksByStatusEvent extends PlannerEvent {
  /// Task status
  final TaskStatus status;

  /// Constructor
  LoadTasksByStatusEvent({required this.status});

  @override
  List<Object> get props => [status];
}

/// Event to load tasks by date range
class LoadTasksByDateRangeEvent extends PlannerEvent {
  /// Start date
  final DateTime startDate;
  
  /// End date
  final DateTime endDate;

  /// Constructor
  LoadTasksByDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

/// Event to add a task
class AddTaskEvent extends PlannerEvent {
  /// Task to add
  final Task task;

  /// Constructor
  AddTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

/// Event to update a task
class UpdateTaskEvent extends PlannerEvent {
  /// Task to update
  final Task task;

  /// Constructor
  UpdateTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

/// Event to delete a task
class DeleteTaskEvent extends PlannerEvent {
  /// Task ID to delete
  final String taskId;

  /// Constructor
  DeleteTaskEvent({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

/// Event to update task status
class UpdateTaskStatusEvent extends PlannerEvent {
  /// Task ID to update
  final String taskId;
  
  /// New status
  final TaskStatus status;

  /// Constructor
  UpdateTaskStatusEvent({
    required this.taskId,
    required this.status,
  });

  @override
  List<Object> get props => [taskId, status];
}

/// Event to load all tags
class LoadTagsEvent extends PlannerEvent {}
