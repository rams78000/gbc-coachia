import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/planner_repository.dart';

/// Implementation of PlannerRepository
class PlannerRepositoryImpl implements PlannerRepository {
  /// In-memory tasks for testing, will be replaced with API or local storage
  final List<Task> _tasks = [];
  
  /// In-memory tags for testing, will be replaced with API or local storage
  final List<String> _tags = [];
  
  /// Uuid generator
  final Uuid _uuid = const Uuid();

  @override
  Future<List<Task>> getTasks() async {
    // TODO: Implement with API or local storage
    return _tasks;
  }

  @override
  Future<Task?> getTaskById(String id) async {
    // TODO: Implement with API or local storage
    return _tasks.firstWhere(
      (task) => task.id == id,
      orElse: () => throw Exception('Task not found'),
    );
  }

  @override
  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    // TODO: Implement with API or local storage
    return _tasks.where((task) => task.status == status).toList();
  }

  @override
  Future<List<Task>> getTasksByDateRange(DateTime start, DateTime end) async {
    // TODO: Implement with API or local storage
    return _tasks.where((task) {
      if (task.dueDate == null) {
        return false;
      }
      return task.dueDate!.isAfter(start) && task.dueDate!.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Future<List<Task>> getTasksByTag(String tag) async {
    // TODO: Implement with API or local storage
    return _tasks.where((task) => task.tags.contains(tag)).toList();
  }

  @override
  Future<List<Task>> getTasksByPriority(TaskPriority priority) async {
    // TODO: Implement with API or local storage
    return _tasks.where((task) => task.priority == priority).toList();
  }

  @override
  Future<Task> addTask(Task task) async {
    // TODO: Implement with API or local storage
    final newTask = task.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _tasks.add(newTask);
    
    // Add tags if they don't exist
    for (final tag in newTask.tags) {
      if (!_tags.contains(tag)) {
        _tags.add(tag);
      }
    }
    
    return newTask;
  }

  @override
  Future<Task> updateTask(Task task) async {
    // TODO: Implement with API or local storage
    final index = _tasks.indexWhere((t) => t.id == task.id);
    
    if (index != -1) {
      final updatedTask = task.copyWith(
        updatedAt: DateTime.now(),
      );
      
      _tasks[index] = updatedTask;
      
      // Add tags if they don't exist
      for (final tag in updatedTask.tags) {
        if (!_tags.contains(tag)) {
          _tags.add(tag);
        }
      }
      
      return updatedTask;
    } else {
      throw Exception('Task not found');
    }
  }

  @override
  Future<bool> deleteTask(String id) async {
    // TODO: Implement with API or local storage
    final index = _tasks.indexWhere((task) => task.id == id);
    
    if (index != -1) {
      _tasks.removeAt(index);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Task> completeTask(String id) async {
    // TODO: Implement with API or local storage
    final task = await getTaskById(id);
    
    if (task != null) {
      final completedTask = task.copyWith(
        status: TaskStatus.completed,
        completedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final index = _tasks.indexWhere((t) => t.id == id);
      _tasks[index] = completedTask;
      
      return completedTask;
    } else {
      throw Exception('Task not found');
    }
  }

  @override
  Future<Task> updateTaskStatus(String id, TaskStatus status) async {
    // TODO: Implement with API or local storage
    final task = await getTaskById(id);
    
    if (task != null) {
      DateTime? completedAt;
      if (status == TaskStatus.completed) {
        completedAt = DateTime.now();
      }
      
      final updatedTask = task.copyWith(
        status: status,
        completedAt: completedAt,
        updatedAt: DateTime.now(),
      );
      
      final index = _tasks.indexWhere((t) => t.id == id);
      _tasks[index] = updatedTask;
      
      return updatedTask;
    } else {
      throw Exception('Task not found');
    }
  }

  @override
  Future<List<String>> getTags() async {
    // TODO: Implement with API or local storage
    return _tags;
  }

  @override
  Future<bool> addTag(String tag) async {
    // TODO: Implement with API or local storage
    if (!_tags.contains(tag)) {
      _tags.add(tag);
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteTag(String tag) async {
    // TODO: Implement with API or local storage
    if (_tags.contains(tag)) {
      _tags.remove(tag);
      
      // Remove tag from all tasks
      for (var i = 0; i < _tasks.length; i++) {
        final task = _tasks[i];
        if (task.tags.contains(tag)) {
          final updatedTags = List.of(task.tags)..remove(tag);
          _tasks[i] = task.copyWith(
            tags: updatedTags,
            updatedAt: DateTime.now(),
          );
        }
      }
      
      return true;
    }
    return false;
  }
}