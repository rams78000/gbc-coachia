import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../../domain/entities/planner_entities.dart';

// Events
abstract class PlannerEvent extends Equatable {
  const PlannerEvent();

  @override
  List<Object> get props => [];
}

class PlannerInitialized extends PlannerEvent {
  const PlannerInitialized();
}

class PlannerEventAdded extends PlannerEvent {
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final EventCategory category;
  final String location;
  final bool isAllDay;
  final Color color;

  const PlannerEventAdded({
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
  List<Object> get props => [
    title, 
    startTime, 
    endTime, 
    category, 
    location, 
    isAllDay, 
    color,
  ];
}

class PlannerEventUpdated extends PlannerEvent {
  final PlannerEvent updatedEvent;

  const PlannerEventUpdated({required this.updatedEvent});

  @override
  List<Object> get props => [updatedEvent];
}

class PlannerEventDeleted extends PlannerEvent {
  final String eventId;

  const PlannerEventDeleted({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class PlannerTaskAdded extends PlannerEvent {
  final String title;
  final String? description;
  final DateTime? dueDate;
  final TaskPriority priority;

  const PlannerTaskAdded({
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
  });

  @override
  List<Object> get props => [title, priority];
}

class PlannerTaskStatusToggled extends PlannerEvent {
  final String taskId;

  const PlannerTaskStatusToggled({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

class PlannerTaskDeleted extends PlannerEvent {
  final String taskId;

  const PlannerTaskDeleted({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

class PlannerGoalAdded extends PlannerEvent {
  final String title;
  final String description;
  final DateTime dueDate;

  const PlannerGoalAdded({
    required this.title,
    required this.description,
    required this.dueDate,
  });

  @override
  List<Object> get props => [title, description, dueDate];
}

class PlannerGoalProgressUpdated extends PlannerEvent {
  final String goalId;
  final double progress;

  const PlannerGoalProgressUpdated({
    required this.goalId,
    required this.progress,
  });

  @override
  List<Object> get props => [goalId, progress];
}

// States
abstract class PlannerState extends Equatable {
  const PlannerState();
  
  @override
  List<Object> get props => [];
}

class PlannerInitial extends PlannerState {
  const PlannerInitial();
}

class PlannerLoading extends PlannerState {
  const PlannerLoading();
}

class PlannerLoaded extends PlannerState {
  final List<PlannerEvent> events;
  final List<PlannerTask> tasks;
  final List<PlannerGoal> goals;
  final DateTime selectedDate;

  const PlannerLoaded({
    required this.events,
    required this.tasks,
    required this.goals,
    required this.selectedDate,
  });

  PlannerLoaded copyWith({
    List<PlannerEvent>? events,
    List<PlannerTask>? tasks,
    List<PlannerGoal>? goals,
    DateTime? selectedDate,
  }) {
    return PlannerLoaded(
      events: events ?? this.events,
      tasks: tasks ?? this.tasks,
      goals: goals ?? this.goals,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object> get props => [events, tasks, goals, selectedDate];
}

class PlannerError extends PlannerState {
  final String message;

  const PlannerError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  final SharedPreferences _preferences;
  static const String _eventsKey = 'planner_events';
  static const String _tasksKey = 'planner_tasks';
  static const String _goalsKey = 'planner_goals';
  final Uuid _uuid = const Uuid();

  PlannerBloc({required SharedPreferences preferences}) 
      : _preferences = preferences,
        super(const PlannerInitial()) {
    on<PlannerInitialized>(_onInitialized);
    on<PlannerEventAdded>(_onEventAdded);
    on<PlannerEventUpdated>(_onEventUpdated);
    on<PlannerEventDeleted>(_onEventDeleted);
    on<PlannerTaskAdded>(_onTaskAdded);
    on<PlannerTaskStatusToggled>(_onTaskStatusToggled);
    on<PlannerTaskDeleted>(_onTaskDeleted);
    on<PlannerGoalAdded>(_onGoalAdded);
    on<PlannerGoalProgressUpdated>(_onGoalProgressUpdated);
  }

  Future<void> _onInitialized(
    PlannerInitialized event,
    Emitter<PlannerState> emit,
  ) async {
    emit(const PlannerLoading());

    try {
      final events = _loadEvents();
      final tasks = _loadTasks();
      final goals = _loadGoals();
      
      // Si aucune donnée n'existe, créer des données de démonstration
      if (events.isEmpty && tasks.isEmpty && goals.isEmpty) {
        _createDemoData();
        emit(const PlannerLoading());
        final newEvents = _loadEvents();
        final newTasks = _loadTasks();
        final newGoals = _loadGoals();
        emit(PlannerLoaded(
          events: newEvents,
          tasks: newTasks,
          goals: newGoals,
          selectedDate: DateTime.now(),
        ));
      } else {
        emit(PlannerLoaded(
          events: events,
          tasks: tasks,
          goals: goals,
          selectedDate: DateTime.now(),
        ));
      }
    } catch (e) {
      emit(PlannerError(message: 'Erreur lors du chargement des données du planner: $e'));
    }
  }

  Future<void> _onEventAdded(
    PlannerEventAdded event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      
      // Créer le nouvel événement
      final newEvent = PlannerEvent(
        id: _uuid.v4(),
        title: event.title,
        description: event.description,
        startTime: event.startTime,
        endTime: event.endTime,
        category: event.category,
        location: event.location,
        isAllDay: event.isAllDay,
        color: event.color,
      );
      
      // Ajouter à la liste existante
      final updatedEvents = List<PlannerEvent>.from(currentState.events)..add(newEvent);
      
      // Mettre à jour l'état
      emit(currentState.copyWith(events: updatedEvents));
      
      // Sauvegarder les événements
      _saveEvents(updatedEvents);
    }
  }

  Future<void> _onEventUpdated(
    PlannerEventUpdated event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      
      // Trouver l'index de l'événement à mettre à jour
      final eventIndex = currentState.events.indexWhere((e) => e.id == event.updatedEvent.id);
      
      if (eventIndex >= 0) {
        // Créer la liste mise à jour
        final updatedEvents = List<PlannerEvent>.from(currentState.events);
        updatedEvents[eventIndex] = event.updatedEvent;
        
        // Mettre à jour l'état
        emit(currentState.copyWith(events: updatedEvents));
        
        // Sauvegarder les événements
        _saveEvents(updatedEvents);
      }
    }
  }

  Future<void> _onEventDeleted(
    PlannerEventDeleted event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      
      // Filtrer la liste pour supprimer l'événement
      final updatedEvents = currentState.events.where((e) => e.id != event.eventId).toList();
      
      // Mettre à jour l'état
      emit(currentState.copyWith(events: updatedEvents));
      
      // Sauvegarder les événements
      _saveEvents(updatedEvents);
    }
  }

  Future<void> _onTaskAdded(
    PlannerTaskAdded event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      
      // Créer la nouvelle tâche
      final newTask = PlannerTask(
        id: _uuid.v4(),
        title: event.title,
        description: event.description,
        dueDate: event.dueDate,
        priority: event.priority,
        isCompleted: false,
      );
      
      // Ajouter à la liste existante
      final updatedTasks = List<PlannerTask>.from(currentState.tasks)..add(newTask);
      
      // Mettre à jour l'état
      emit(currentState.copyWith(tasks: updatedTasks));
      
      // Sauvegarder les tâches
      _saveTasks(updatedTasks);
    }
  }

  Future<void> _onTaskStatusToggled(
    PlannerTaskStatusToggled event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      
      // Trouver l'index de la tâche à mettre à jour
      final taskIndex = currentState.tasks.indexWhere((t) => t.id == event.taskId);
      
      if (taskIndex >= 0) {
        // Créer la liste mise à jour
        final updatedTasks = List<PlannerTask>.from(currentState.tasks);
        final task = updatedTasks[taskIndex];
        updatedTasks[taskIndex] = task.copyWith(isCompleted: !task.isCompleted);
        
        // Mettre à jour l'état
        emit(currentState.copyWith(tasks: updatedTasks));
        
        // Sauvegarder les tâches
        _saveTasks(updatedTasks);
      }
    }
  }

  Future<void> _onTaskDeleted(
    PlannerTaskDeleted event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      
      // Filtrer la liste pour supprimer la tâche
      final updatedTasks = currentState.tasks.where((t) => t.id != event.taskId).toList();
      
      // Mettre à jour l'état
      emit(currentState.copyWith(tasks: updatedTasks));
      
      // Sauvegarder les tâches
      _saveTasks(updatedTasks);
    }
  }

  Future<void> _onGoalAdded(
    PlannerGoalAdded event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      
      // Créer le nouvel objectif
      final newGoal = PlannerGoal(
        id: _uuid.v4(),
        title: event.title,
        description: event.description,
        dueDate: event.dueDate,
        progress: 0.0,
      );
      
      // Ajouter à la liste existante
      final updatedGoals = List<PlannerGoal>.from(currentState.goals)..add(newGoal);
      
      // Mettre à jour l'état
      emit(currentState.copyWith(goals: updatedGoals));
      
      // Sauvegarder les objectifs
      _saveGoals(updatedGoals);
    }
  }

  Future<void> _onGoalProgressUpdated(
    PlannerGoalProgressUpdated event,
    Emitter<PlannerState> emit,
  ) async {
    if (state is PlannerLoaded) {
      final currentState = state as PlannerLoaded;
      
      // Trouver l'index de l'objectif à mettre à jour
      final goalIndex = currentState.goals.indexWhere((g) => g.id == event.goalId);
      
      if (goalIndex >= 0) {
        // Créer la liste mise à jour
        final updatedGoals = List<PlannerGoal>.from(currentState.goals);
        final goal = updatedGoals[goalIndex];
        updatedGoals[goalIndex] = goal.copyWith(progress: event.progress);
        
        // Mettre à jour l'état
        emit(currentState.copyWith(goals: updatedGoals));
        
        // Sauvegarder les objectifs
        _saveGoals(updatedGoals);
      }
    }
  }

  List<PlannerEvent> _loadEvents() {
    final eventsJson = _preferences.getStringList(_eventsKey) ?? [];
    
    if (eventsJson.isEmpty) {
      return [];
    }
    
    return eventsJson.map((eventStr) {
      final eventMap = jsonDecode(eventStr) as Map<String, dynamic>;
      return PlannerEvent(
        id: eventMap['id'] as String,
        title: eventMap['title'] as String,
        description: eventMap['description'] as String?,
        startTime: DateTime.parse(eventMap['startTime'] as String),
        endTime: DateTime.parse(eventMap['endTime'] as String),
        category: EventCategory.values[eventMap['category'] as int],
        location: eventMap['location'] as String,
        isAllDay: eventMap['isAllDay'] as bool,
        color: Color(eventMap['color'] as int),
      );
    }).toList();
  }

  void _saveEvents(List<PlannerEvent> events) {
    final eventsJson = events.map((event) {
      return jsonEncode({
        'id': event.id,
        'title': event.title,
        'description': event.description,
        'startTime': event.startTime.toIso8601String(),
        'endTime': event.endTime.toIso8601String(),
        'category': event.category.index,
        'location': event.location,
        'isAllDay': event.isAllDay,
        'color': event.color.value,
      });
    }).toList();
    
    _preferences.setStringList(_eventsKey, eventsJson);
  }

  List<PlannerTask> _loadTasks() {
    final tasksJson = _preferences.getStringList(_tasksKey) ?? [];
    
    if (tasksJson.isEmpty) {
      return [];
    }
    
    return tasksJson.map((taskStr) {
      final taskMap = jsonDecode(taskStr) as Map<String, dynamic>;
      
      final subtasksJson = taskMap['subtasks'] as List<dynamic>?;
      final subtasks = subtasksJson?.map((e) => e as String).toList();
      
      return PlannerTask(
        id: taskMap['id'] as String,
        title: taskMap['title'] as String,
        description: taskMap['description'] as String?,
        dueDate: taskMap['dueDate'] != null 
            ? DateTime.parse(taskMap['dueDate'] as String)
            : null,
        priority: TaskPriority.values[taskMap['priority'] as int],
        isCompleted: taskMap['isCompleted'] as bool,
        subtasks: subtasks,
      );
    }).toList();
  }

  void _saveTasks(List<PlannerTask> tasks) {
    final tasksJson = tasks.map((task) {
      return jsonEncode({
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'dueDate': task.dueDate?.toIso8601String(),
        'priority': task.priority.index,
        'isCompleted': task.isCompleted,
        'subtasks': task.subtasks,
      });
    }).toList();
    
    _preferences.setStringList(_tasksKey, tasksJson);
  }

  List<PlannerGoal> _loadGoals() {
    final goalsJson = _preferences.getStringList(_goalsKey) ?? [];
    
    if (goalsJson.isEmpty) {
      return [];
    }
    
    return goalsJson.map((goalStr) {
      final goalMap = jsonDecode(goalStr) as Map<String, dynamic>;
      
      final relatedTasksJson = goalMap['relatedTasks'] as List<dynamic>?;
      final relatedTasks = relatedTasksJson?.map((e) => e as String).toList();
      
      return PlannerGoal(
        id: goalMap['id'] as String,
        title: goalMap['title'] as String,
        description: goalMap['description'] as String,
        dueDate: DateTime.parse(goalMap['dueDate'] as String),
        progress: goalMap['progress'] as double,
        relatedTasks: relatedTasks,
      );
    }).toList();
  }

  void _saveGoals(List<PlannerGoal> goals) {
    final goalsJson = goals.map((goal) {
      return jsonEncode({
        'id': goal.id,
        'title': goal.title,
        'description': goal.description,
        'dueDate': goal.dueDate.toIso8601String(),
        'progress': goal.progress,
        'relatedTasks': goal.relatedTasks,
      });
    }).toList();
    
    _preferences.setStringList(_goalsKey, goalsJson);
  }

  void _createDemoData() {
    final now = DateTime.now();
    
    // Créer des événements de démonstration
    final events = [
      PlannerEvent(
        id: _uuid.v4(),
        title: 'Réunion client Entreprise ABC',
        description: 'Discussion sur le nouveau projet',
        startTime: DateTime(now.year, now.month, now.day, 14, 0),
        endTime: DateTime(now.year, now.month, now.day, 15, 0),
        category: EventCategory.client,
        location: 'Zoom',
        color: Colors.blue,
      ),
      PlannerEvent(
        id: _uuid.v4(),
        title: 'Appel fournisseur',
        description: 'Négociation des tarifs',
        startTime: DateTime(now.year, now.month, now.day + 1, 10, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 10, 30),
        category: EventCategory.meeting,
        location: 'Téléphone',
        color: Colors.green,
      ),
      PlannerEvent(
        id: _uuid.v4(),
        title: 'Atelier planification stratégique',
        description: 'Définir objectifs du trimestre',
        startTime: DateTime(now.year, now.month, now.day + 1, 14, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 16, 0),
        category: EventCategory.meeting,
        location: 'Salle de conférence',
        color: Colors.purple,
      ),
      PlannerEvent(
        id: _uuid.v4(),
        title: 'Présentation projet',
        description: 'Présentation finale au client',
        startTime: DateTime(now.year, now.month, now.day + 2, 9, 0),
        endTime: DateTime(now.year, now.month, now.day + 2, 10, 30),
        category: EventCategory.client,
        location: 'Bureaux client',
        color: Colors.red,
      ),
    ];
    
    // Créer des tâches de démonstration
    final tasks = [
      PlannerTask(
        id: _uuid.v4(),
        title: 'Finaliser proposition commerciale',
        description: 'À remettre au client Entreprise ABC',
        dueDate: DateTime(now.year, now.month, now.day + 1),
        priority: TaskPriority.high,
        isCompleted: false,
      ),
      PlannerTask(
        id: _uuid.v4(),
        title: 'Préparer présentation projet',
        description: 'Pour la réunion de mercredi',
        dueDate: DateTime(now.year, now.month, now.day - 1),
        priority: TaskPriority.medium,
        isCompleted: false,
      ),
      PlannerTask(
        id: _uuid.v4(),
        title: 'Appeler le fournisseur de matériel',
        description: 'Négocier les tarifs 2025',
        dueDate: DateTime(now.year, now.month, now.day - 5),
        priority: TaskPriority.medium,
        isCompleted: true,
      ),
      PlannerTask(
        id: _uuid.v4(),
        title: 'Mettre à jour site web',
        description: 'Ajouter les nouveaux témoignages clients',
        dueDate: DateTime(now.year, now.month, now.day + 10),
        priority: TaskPriority.low,
        isCompleted: false,
      ),
      PlannerTask(
        id: _uuid.v4(),
        title: 'Réviser plan marketing Q2',
        description: 'Inclure nouvelles cibles et canaux',
        dueDate: DateTime(now.year, now.month, now.day + 15),
        priority: TaskPriority.high,
        isCompleted: false,
      ),
    ];
    
    // Créer des objectifs de démonstration
    final goals = [
      PlannerGoal(
        id: _uuid.v4(),
        title: 'Augmenter chiffre d\'affaires',
        description: 'Objectif: €30,000 ce trimestre',
        dueDate: DateTime(now.year, now.month + 3, 1),
        progress: 0.65,
      ),
      PlannerGoal(
        id: _uuid.v4(),
        title: 'Acquérir 5 nouveaux clients',
        description: 'Objectif: 5 clients dans le secteur technologique',
        dueDate: DateTime(now.year, now.month + 3, 1),
        progress: 0.4,
      ),
      PlannerGoal(
        id: _uuid.v4(),
        title: 'Lancer nouveau service',
        description: 'Développer et commercialiser l\'offre de coaching',
        dueDate: DateTime(now.year, now.month + 1, 15),
        progress: 0.25,
      ),
    ];
    
    // Sauvegarder les données
    _saveEvents(events);
    _saveTasks(tasks);
    _saveGoals(goals);
  }
}
