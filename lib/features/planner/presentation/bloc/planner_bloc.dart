import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/planner_repository.dart';
import 'planner_event.dart';
import 'planner_state.dart';

/// BLoC to handle planner functionality
class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  /// Planner repository
  final PlannerRepository? plannerRepository;

  /// Constructor
  PlannerBloc({this.plannerRepository}) : super(PlannerInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadTasksByStatusEvent>(_onLoadTasksByStatus);
    on<LoadTasksByDateRangeEvent>(_onLoadTasksByDateRange);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
    on<LoadTagsEvent>(_onLoadTags);
  }

  /// Handle loading all tasks
  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<PlannerState> emit,
  ) async {
    emit(PlannerLoading());
    
    try {
      // TODO: Replace with actual repository implementation
      final tasks = await Future.delayed(
        const Duration(milliseconds: 500),
        () => <Task>[],
      );
      
      final tags = await Future.delayed(
        const Duration(milliseconds: 500),
        () => <String>[],
      );
      
      emit(PlannerLoaded(tasks: tasks, tags: tags));
    } catch (e) {
      emit(PlannerError(message: 'Failed to load tasks'));
    }
  }

  /// Handle loading tasks by status
  Future<void> _onLoadTasksByStatus(
    LoadTasksByStatusEvent event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      emit(PlannerLoading());
      
      try {
        // TODO: Replace with actual repository implementation
        final tasks = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <Task>[],
        );
        
        emit(currentState.copyWith(
          tasks: tasks,
          filterStatus: event.status,
          clearDateRange: true,
        ));
      } catch (e) {
        emit(PlannerError(message: 'Failed to load tasks by status'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle loading tasks by date range
  Future<void> _onLoadTasksByDateRange(
    LoadTasksByDateRangeEvent event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      emit(PlannerLoading());
      
      try {
        // TODO: Replace with actual repository implementation
        final tasks = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <Task>[],
        );
        
        emit(currentState.copyWith(
          tasks: tasks,
          startDate: event.startDate,
          endDate: event.endDate,
          clearFilterStatus: true,
        ));
      } catch (e) {
        emit(PlannerError(message: 'Failed to load tasks by date range'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle adding a task
  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      emit(PlannerOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final newTask = await Future.delayed(
          const Duration(milliseconds: 500),
          () => event.task,
        );
        
        final updatedTasks = List.of(currentState.tasks)..add(newTask);
        emit(currentState.copyWith(tasks: updatedTasks));
      } catch (e) {
        emit(PlannerError(message: 'Failed to add task'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle updating a task
  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      emit(PlannerOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final updatedTask = await Future.delayed(
          const Duration(milliseconds: 500),
          () => event.task,
        );
        
        final taskIndex = currentState.tasks.indexWhere(
          (task) => task.id == updatedTask.id,
        );
        
        if (taskIndex != -1) {
          final updatedTasks = List.of(currentState.tasks);
          updatedTasks[taskIndex] = updatedTask;
          emit(currentState.copyWith(tasks: updatedTasks));
        } else {
          emit(PlannerError(message: 'Task not found'));
          emit(currentState); // Revert to previous state
        }
      } catch (e) {
        emit(PlannerError(message: 'Failed to update task'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle deleting a task
  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      emit(PlannerOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final success = await Future.delayed(
          const Duration(milliseconds: 500),
          () => true,
        );
        
        if (success) {
          final updatedTasks = currentState.tasks
              .where((task) => task.id != event.taskId)
              .toList();
          emit(currentState.copyWith(tasks: updatedTasks));
        } else {
          emit(PlannerError(message: 'Failed to delete task'));
          emit(currentState); // Revert to previous state
        }
      } catch (e) {
        emit(PlannerError(message: 'Failed to delete task'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle updating task status
  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatusEvent event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      emit(PlannerOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final updatedTask = await Future.delayed(
          const Duration(milliseconds: 500),
          () {
            final taskIndex = currentState.tasks.indexWhere(
              (task) => task.id == event.taskId,
            );
            
            if (taskIndex != -1) {
              return currentState.tasks[taskIndex].copyWith(
                status: event.status,
                updatedAt: DateTime.now(),
              );
            } else {
              return null;
            }
          },
        );
        
        if (updatedTask != null) {
          final taskIndex = currentState.tasks.indexWhere(
            (task) => task.id == event.taskId,
          );
          
          final updatedTasks = List.of(currentState.tasks);
          updatedTasks[taskIndex] = updatedTask;
          emit(currentState.copyWith(tasks: updatedTasks));
        } else {
          emit(PlannerError(message: 'Task not found'));
          emit(currentState); // Revert to previous state
        }
      } catch (e) {
        emit(PlannerError(message: 'Failed to update task status'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle loading all tags
  Future<void> _onLoadTags(
    LoadTagsEvent event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      
      try {
        // TODO: Replace with actual repository implementation
        final tags = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <String>[],
        );
        
        emit(currentState.copyWith(tags: tags));
      } catch (e) {
        emit(PlannerError(message: 'Failed to load tags'));
        emit(currentState); // Revert to previous state
      }
    } else {
      emit(TagsLoaded(tags: []));
    }
  }
}
