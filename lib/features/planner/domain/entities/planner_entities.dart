import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PlannerEvent extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final EventCategory category;
  final String location;
  final bool isAllDay;
  final Color color;

  const PlannerEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.location,
    this.isAllDay = false,
    required this.color,
  });

  @override
  List<Object?> get props => [
    id, 
    title, 
    description, 
    startTime, 
    endTime, 
    category, 
    location, 
    isAllDay, 
    color,
  ];

  PlannerEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    EventCategory? category,
    String? location,
    bool? isAllDay,
    Color? color,
  }) {
    return PlannerEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      location: location ?? this.location,
      isAllDay: isAllDay ?? this.isAllDay,
      color: color ?? this.color,
    );
  }
}

enum EventCategory {
  meeting,
  task,
  personal,
  client,
  other,
}

class PlannerTask extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final TaskPriority priority;
  final bool isCompleted;
  final List<String>? subtasks;

  const PlannerTask({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    required this.isCompleted,
    this.subtasks,
  });

  @override
  List<Object?> get props => [
    id, 
    title, 
    description, 
    dueDate, 
    priority, 
    isCompleted, 
    subtasks,
  ];

  PlannerTask copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
    List<String>? subtasks,
  }) {
    return PlannerTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      subtasks: subtasks ?? this.subtasks,
    );
  }

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }
}

enum TaskPriority {
  high,
  medium,
  low,
}

class PlannerGoal extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final double progress;
  final List<String>? relatedTasks;

  const PlannerGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.progress,
    this.relatedTasks,
  });

  @override
  List<Object?> get props => [
    id, 
    title, 
    description, 
    dueDate, 
    progress, 
    relatedTasks,
  ];

  PlannerGoal copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    double? progress,
    List<String>? relatedTasks,
  }) {
    return PlannerGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      progress: progress ?? this.progress,
      relatedTasks: relatedTasks ?? this.relatedTasks,
    );
  }
}
