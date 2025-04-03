import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';

/// Abstract class for Planner states
abstract class PlannerState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state of planner
class PlannerInitial extends PlannerState {}

/// State for loading planner data
class PlannerLoading extends PlannerState {}

/// State for planner data loaded
class PlannerLoaded extends PlannerState {
  /// List of tasks
  final List<Task> tasks;
  
  /// List of tags
  final List<String> tags;
  
  /// Filter by status
  final TaskStatus? filterStatus;
  
  /// Filter by start date
  final DateTime? startDate;
  
  /// Filter by end date
  final DateTime? endDate;

  /// Constructor
  PlannerLoaded({
    required this.tasks,
    required this.tags,
    this.filterStatus,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    tasks,
    tags,
    filterStatus,
    startDate,
    endDate,
  ];

  /// Create a copy with updated fields
  PlannerLoaded copyWith({
    List<Task>? tasks,
    List<String>? tags,
    TaskStatus? filterStatus,
    DateTime? startDate,
    DateTime? endDate,
    bool clearFilterStatus = false,
    bool clearDateRange = false,
  }) {
    return PlannerLoaded(
      tasks: tasks ?? this.tasks,
      tags: tags ?? this.tags,
      filterStatus: clearFilterStatus ? null : filterStatus ?? this.filterStatus,
      startDate: clearDateRange ? null : startDate ?? this.startDate,
      endDate: clearDateRange ? null : endDate ?? this.endDate,
    );
  }
}

/// State for planner operation in progress
class PlannerOperationInProgress extends PlannerState {}

/// State for tags loaded
class TagsLoaded extends PlannerState {
  /// List of tags
  final List<String> tags;

  /// Constructor
  TagsLoaded({required this.tags});

  @override
  List<Object> get props => [tags];
}

/// State for error in planner functionality
class PlannerError extends PlannerState {
  /// Error message
  final String message;

  /// Constructor
  PlannerError({required this.message});

  @override
  List<Object> get props => [message];
}
