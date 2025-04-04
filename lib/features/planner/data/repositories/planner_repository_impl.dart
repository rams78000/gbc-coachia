import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/task.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/optimized_schedule.dart';
import '../../domain/entities/productivity_stats.dart';
import '../../domain/repositories/planner_repository.dart';

/// Implémentation du repository pour le planificateur
class PlannerRepositoryImpl implements PlannerRepository {
  // Données fictives pour le développement
  final List<Task> _tasks = [];
  final List<Event> _events = [];
  final Map<String, OptimizedSchedule> _schedules = {};
  
  // Constructeur
  PlannerRepositoryImpl() {
    _initializeWithMockData();
  }
  
  /// Initialise le repository avec des données fictives
  void _initializeWithMockData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Ajouter quelques tâches
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Appeler le client principal',
        description: 'Discuter des nouvelles fonctionnalités',
        priority: TaskPriority.high,
        dueDate: today.add(const Duration(days: 1)),
        category: TaskCategory.work,
        estimatedDuration: 30,
      ),
      Task(
        id: '2',
        title: 'Préparer la présentation',
        description: 'Slides pour la réunion de jeudi',
        priority: TaskPriority.veryHigh,
        dueDate: today.add(const Duration(days: 2)),
        category: TaskCategory.work,
        estimatedDuration: 120,
      ),
      Task(
        id: '3',
        title: 'Mettre à jour le site web',
        description: 'Ajouter les nouvelles références',
        priority: TaskPriority.medium,
        dueDate: today,
        category: TaskCategory.admin,
        estimatedDuration: 60,
      ),
      Task(
        id: '4',
        title: 'Rendez-vous médical',
        description: 'Contrôle annuel',
        priority: TaskPriority.medium,
        dueDate: today.add(const Duration(days: 5)),
        category: TaskCategory.health,
        estimatedDuration: 90,
      ),
      Task(
        id: '5',
        title: 'Cours en ligne',
        description: 'Module 3 du cours UX',
        priority: TaskPriority.low,
        dueDate: today.add(const Duration(days: 3)),
        category: TaskCategory.learning,
        estimatedDuration: 45,
      ),
    ]);
    
    // Ajouter quelques événements
    _events.addAll([
      Event(
        id: '1',
        title: 'Réunion d\'équipe',
        description: 'Point hebdomadaire',
        start: DateTime(today.year, today.month, today.day, 10, 0),
        end: DateTime(today.year, today.month, today.day, 11, 0),
        type: EventType.meeting,
        color: Colors.blue,
        location: 'Salle de conférence',
      ),
      Event(
        id: '2',
        title: 'Déjeuner avec le client',
        description: 'Restaurant Le Central',
        start: DateTime(today.year, today.month, today.day, 12, 30),
        end: DateTime(today.year, today.month, today.day, 14, 0),
        type: EventType.appointment,
        color: Colors.green,
        location: 'Restaurant Le Central',
      ),
      Event(
        id: '3',
        title: 'Atelier créatif',
        description: 'Brainstorming pour le nouveau projet',
        start: DateTime(today.year, today.month, today.day, 15, 0),
        end: DateTime(today.year, today.month, today.day, 17, 0),
        type: EventType.workBlock,
        color: Colors.purple,
        location: 'Espace créatif',
      ),
      Event(
        id: '4',
        title: 'Sport',
        description: 'Séance de fitness',
        start: DateTime(today.year, today.month, today.day + 1, 18, 0),
        end: DateTime(today.year, today.month, today.day + 1, 19, 30),
        type: EventType.personal,
        color: Colors.orange,
        location: 'Salle de sport',
      ),
    ]);
    
    // Créer un planning optimisé fictif
    final timeBlocks = <TimeBlock>[
      TimeBlock(
        title: 'Focus matinal',
        start: DateTime(today.year, today.month, today.day, 8, 0),
        end: DateTime(today.year, today.month, today.day, 10, 0),
        category: TaskCategory.work,
      ),
      TimeBlock(
        title: 'Réunion d\'équipe',
        start: DateTime(today.year, today.month, today.day, 10, 0),
        end: DateTime(today.year, today.month, today.day, 11, 0),
        category: TaskCategory.meeting,
        event: _events[0],
      ),
      TimeBlock(
        title: 'Mise à jour du site web',
        start: DateTime(today.year, today.month, today.day, 11, 0),
        end: DateTime(today.year, today.month, today.day, 12, 30),
        category: TaskCategory.admin,
        task: _tasks[2],
      ),
      TimeBlock(
        title: 'Déjeuner avec client',
        start: DateTime(today.year, today.month, today.day, 12, 30),
        end: DateTime(today.year, today.month, today.day, 14, 0),
        category: TaskCategory.meeting,
        event: _events[1],
      ),
      TimeBlock(
        title: 'Atelier créatif',
        start: DateTime(today.year, today.month, today.day, 15, 0),
        end: DateTime(today.year, today.month, today.day, 17, 0),
        category: TaskCategory.work,
        event: _events[2],
      ),
    ];
    
    final schedule = OptimizedSchedule(
      id: '1',
      date: today,
      strategy: OptimizationStrategy.basic,
      timeBlocks: timeBlocks,
      efficiencyScore: 85,
      recommendations: [
        'Essayez de regrouper vos réunions pour plus d\'efficacité',
        'Planifiez plus de temps pour les tâches créatives',
        'Prévoyez des pauses entre les blocs de travail intense'
      ],
    );
    
    _schedules[today.toString().split(' ')[0]] = schedule;
  }
  
  @override
  Future<List<Task>> getAllTasks() async {
    return _tasks;
  }
  
  @override
  Future<List<Task>> getTasksForDate(DateTime date) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return _tasks.where((task) {
      final taskDate = DateTime(
        task.dueDate.year,
        task.dueDate.month,
        task.dueDate.day,
      );
      return taskDate.isAtSameMomentAs(dateOnly);
    }).toList();
  }
  
  @override
  Future<List<Task>> getTasksForPeriod(DateTime start, DateTime end) async {
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day, 23, 59, 59);
    
    return _tasks.where((task) {
      final taskDate = task.dueDate;
      return taskDate.isAfter(startDate) && 
             taskDate.isBefore(endDate) || 
             taskDate.isAtSameMomentAs(startDate) || 
             taskDate.isAtSameMomentAs(endDate);
    }).toList();
  }
  
  @override
  Future<Task?> getTaskById(String taskId) async {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Task> saveTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    
    if (index >= 0) {
      // Mise à jour d'une tâche existante
      _tasks[index] = task;
      return task;
    } else {
      // Nouvelle tâche
      _tasks.add(task);
      return task;
    }
  }
  
  @override
  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
  }
  
  @override
  Future<Task> updateTaskStatus(String taskId, TaskStatus status) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    
    if (index >= 0) {
      final task = _tasks[index];
      final updatedTask = task.copyWith(status: status);
      _tasks[index] = updatedTask;
      return updatedTask;
    } else {
      throw Exception('Tâche non trouvée');
    }
  }
  
  @override
  Future<List<Event>> getAllEvents() async {
    return _events;
  }
  
  @override
  Future<List<Event>> getEventsForDate(DateTime date) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final nextDay = dateOnly.add(const Duration(days: 1));
    
    return _events.where((event) {
      final eventStartDate = DateTime(
        event.start.year,
        event.start.month,
        event.start.day,
      );
      
      return eventStartDate.isAtSameMomentAs(dateOnly);
    }).toList();
  }
  
  @override
  Future<List<Event>> getEventsForPeriod(DateTime start, DateTime end) async {
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day, 23, 59, 59);
    
    return _events.where((event) {
      // Un événement est dans la période si sa date de début ou de fin est dans la période
      return (event.start.isAfter(startDate) && event.start.isBefore(endDate)) ||
             (event.end.isAfter(startDate) && event.end.isBefore(endDate)) ||
             // Ou si l'événement englobe toute la période
             (event.start.isBefore(startDate) && event.end.isAfter(endDate));
    }).toList();
  }
  
  @override
  Future<Event?> getEventById(String eventId) async {
    try {
      return _events.firstWhere((event) => event.id == eventId);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Event> saveEvent(Event event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    
    if (index >= 0) {
      // Mise à jour d'un événement existant
      _events[index] = event;
      return event;
    } else {
      // Nouvel événement
      _events.add(event);
      return event;
    }
  }
  
  @override
  Future<void> deleteEvent(String eventId) async {
    _events.removeWhere((event) => event.id == eventId);
  }
  
  @override
  Future<OptimizedSchedule> generateOptimizedSchedule({
    required DateTime date,
    required OptimizationStrategy strategy,
    required List<Task> tasks,
    required List<Event> events,
  }) async {
    // Dans une vraie implémentation, cela appellerait l'API IA pour l'optimisation
    // Pour le développement, nous retournons un planning fictif
    
    final dateKey = date.toString().split(' ')[0];
    if (_schedules.containsKey(dateKey)) {
      return _schedules[dateKey]!;
    }
    
    // Créer un nouveau planning optimisé fictif
    final today = DateTime(date.year, date.month, date.day);
    final tasksDue = await getTasksForDate(date);
    final eventsForDay = await getEventsForDate(date);
    
    // Créer des blocs de temps à partir des tâches et événements
    final timeBlocks = <TimeBlock>[];
    
    // Ajouter les événements comme blocs fixes
    for (final event in eventsForDay) {
      timeBlocks.add(
        TimeBlock(
          title: event.title,
          start: event.start,
          end: event.end,
          category: TaskCategory.meeting, // Par défaut pour les événements
          event: event,
        ),
      );
    }
    
    // Ajouter les tâches dans les créneaux disponibles
    var currentTime = DateTime(today.year, today.month, today.day, 8, 0);
    for (final task in tasksDue) {
      // Vérifier les chevauchements avec les événements
      bool hasOverlap = false;
      final taskEndTime = currentTime.add(Duration(minutes: task.estimatedDuration));
      
      for (final block in timeBlocks) {
        if (!(currentTime.isAfter(block.end) || taskEndTime.isBefore(block.start))) {
          hasOverlap = true;
          // Avancer l'heure actuelle après ce bloc
          currentTime = block.end;
          break;
        }
      }
      
      if (!hasOverlap) {
        timeBlocks.add(
          TimeBlock(
            title: task.title,
            start: currentTime,
            end: taskEndTime,
            category: task.category,
            task: task,
          ),
        );
        currentTime = taskEndTime;
      }
    }
    
    // Trier les blocs par heure de début
    timeBlocks.sort((a, b) => a.start.compareTo(b.start));
    
    // Créer le planning optimisé
    final schedule = OptimizedSchedule(
      date: date,
      strategy: strategy,
      timeBlocks: timeBlocks,
      efficiencyScore: 75, // Score fictif
      recommendations: [
        'Commencez par les tâches importantes en matinée',
        'Prévoyez des pauses de 15 minutes entre les sessions intenses',
        'Regroupez les tâches similaires pour une meilleure efficacité'
      ],
    );
    
    _schedules[dateKey] = schedule;
    return schedule;
  }
  
  @override
  Future<OptimizedSchedule?> getOptimizedScheduleForDate(DateTime date) async {
    final dateKey = date.toString().split(' ')[0];
    return _schedules[dateKey];
  }
  
  @override
  Future<ProductivityStats> getProductivityStats({
    required DateTime start,
    required DateTime end,
  }) async {
    // Dans une vraie implémentation, cela calculerait les statistiques réelles
    // Ici, nous retournons des données fictives pour le développement
    
    final now = DateTime.now();
    final dailyStats = <DateTime, int>{};
    
    // Créer des statistiques quotidiennes fictives
    for (DateTime date = start; date.isBefore(end.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      dailyStats[date] = 2 + (date.day % 5); // Entre 2 et 6 tâches par jour
    }
    
    return ProductivityStats(
      completedTasks: 23,
      overdueTasks: 5,
      totalTimeSpent: 1840, // minutes
      efficiencyRate: 78.5,
      completionRate: 82.0,
      categoryDistribution: {
        'Travail': 950,
        'Administration': 320,
        'Personnel': 280,
        'Apprentissage': 180,
        'Santé': 110,
      },
      startDate: start,
      endDate: end,
      dailyStats: dailyStats,
    );
  }
  
  @override
  Future<void> syncWithExternalServices() async {
    // Simuler une synchronisation
    await Future.delayed(const Duration(seconds: 2));
    // Dans une vraie implémentation, cela synchroniserait avec Google Calendar, etc.
  }
}
