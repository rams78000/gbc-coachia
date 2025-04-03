import '../entities/task.dart';

/// Planner repository interface
abstract class PlannerRepository {
  /// Get all tasks
  Future<List<Task>> getTasks();
  
  /// Get task by ID
  Future<Task?> getTaskById(String id);
  
  /// Get tasks by status
  Future<List<Task>> getTasksByStatus(TaskStatus status);
  
  /// Get tasks by date range
  Future<List<Task>> getTasksByDateRange(DateTime start, DateTime end);
  
  /// Get tasks by tag
  Future<List<Task>> getTasksByTag(String tag);
  
  /// Get tasks by priority
  Future<List<Task>> getTasksByPriority(TaskPriority priority);
  
  /// Add a new task
  Future<Task> addTask(Task task);
  
  /// Update task
  Future<Task> updateTask(Task task);
  
  /// Delete task
  Future<bool> deleteTask(String id);
  
  /// Mark task as completed
  Future<Task> completeTask(String id);
  
  /// Update task status
  Future<Task> updateTaskStatus(String id, TaskStatus status);
  
  /// Get all tags
  Future<List<String>> getTags();
  
  /// Add a new tag
  Future<bool> addTag(String tag);
  
  /// Delete tag
  Future<bool> deleteTag(String tag);
}