import 'package:equatable/equatable.dart';

/// Task status enum
enum TaskStatus {
  /// Task is pending (not started)
  pending,
  
  /// Task is in progress
  inProgress,
  
  /// Task is completed
  completed,
  
  /// Task is canceled
  canceled,
}

/// Task priority enum
enum TaskPriority {
  /// Low priority
  low,
  
  /// Medium priority
  medium,
  
  /// High priority
  high,
  
  /// Urgent priority
  urgent,
}

/// Task entity
class Task extends Equatable {
  /// Task ID
  final String id;
  
  /// Task title
  final String title;
  
  /// Task description
  final String description;
  
  /// Task status
  final TaskStatus status;
  
  /// Task priority
  final TaskPriority priority;
  
  /// Task due date
  final DateTime? dueDate;
  
  /// Task reminder time
  final DateTime? reminderTime;
  
  /// Is task recurring
  final bool isRecurring;
  
  /// Recurrence pattern (e.g., 'daily', 'weekly', 'monthly')
  final String? recurrencePattern;
  
  /// Task tags
  final List<String> tags;
  
  /// Estimated duration in minutes
  final int? estimatedDuration;
  
  /// Actual duration in minutes
  final int? actualDuration;
  
  /// Task location
  final String? location;
  
  /// Task attachments
  final List<String> attachments;
  
  /// Task completed at
  final DateTime? completedAt;
  
  /// Task created at
  final DateTime createdAt;
  
  /// Task updated at
  final DateTime updatedAt;
  
  /// Task constructor
  const Task({
    required this.id,
    required this.title,
    this.description = '',
    this.status = TaskStatus.pending,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.reminderTime,
    this.isRecurring = false,
    this.recurrencePattern,
    this.tags = const [],
    this.estimatedDuration,
    this.actualDuration,
    this.location,
    this.attachments = const [],
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Empty task
  static const empty = Task(
    id: '',
    title: '',
    createdAt: null,
    updatedAt: null,
  );
  
  /// Copy with method
  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    DateTime? reminderTime,
    bool? isRecurring,
    String? recurrencePattern,
    List<String>? tags,
    int? estimatedDuration,
    int? actualDuration,
    String? location,
    List<String>? attachments,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      reminderTime: reminderTime ?? this.reminderTime,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      tags: tags ?? this.tags,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      location: location ?? this.location,
      attachments: attachments ?? this.attachments,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    priority,
    dueDate,
    reminderTime,
    isRecurring,
    recurrencePattern,
    tags,
    estimatedDuration,
    actualDuration,
    location,
    attachments,
    completedAt,
    createdAt,
    updatedAt,
  ];
}