/// Task priority enum
enum TaskPriority {
  /// Low priority
  low,

  /// Medium priority
  medium,

  /// High priority
  high,
}

/// Task status enum
enum TaskStatus {
  /// Task is pending
  pending,

  /// Task is in progress
  inProgress,

  /// Task is completed
  completed,
}

/// Task model
class Task {
  /// Constructor
  Task({
    required this.id,
    required this.title,
    required this.dueDate,
    this.description,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.isAllDay = false,
    this.tags = const [],
  });

  /// Task ID
  final String id;

  /// Task title
  final String title;

  /// Task description
  final String? description;

  /// Task due date
  final DateTime dueDate;

  /// Task priority
  final TaskPriority priority;

  /// Task status
  final TaskStatus status;

  /// Is all day event
  final bool isAllDay;

  /// Task tags
  final List<String> tags;

  /// Create a copy of this task with the given fields replaced
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
    bool? isAllDay,
    List<String>? tags,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isAllDay: isAllDay ?? this.isAllDay,
      tags: tags ?? this.tags,
    );
  }
}
