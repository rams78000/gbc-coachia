import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:gbc_coachia/features/planner/domain/entities/optimized_plan.dart';
import 'package:gbc_coachia/features/planner/domain/entities/task.dart';
import 'package:gbc_coachia/features/planner/domain/repositories/planner_repository.dart';
import 'package:uuid/uuid.dart';

/// Implémentation de repository avec des données mock pour le développement
class MockPlannerRepository implements PlannerRepository {
  // Données mock
  final List<Event> _events = [];
  final List<Task> _tasks = [];
  final _uuid = const Uuid();
  
  // Constructeur pour générer des données mock initiales
  MockPlannerRepository() {
    _generateInitialMockData();
  }
  
  // Génère des données aléatoires pour le développement
  void _generateInitialMockData() {
    // Couleurs pour les événements
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];
    
    // Catégories pour les tâches
    final categories = [
      'Développement',
      'Marketing',
      'Finance',
      'Administratif',
      'Client',
      'Formation',
    ];
    
    // Types d'événements
    final eventTypes = [
      'Réunion',
      'Appel client',
      'Formation',
      'Développement',
      'Planning',
      'Personnel',
    ];
    
    // Date actuelle
    final now = DateTime.now();
    
    // Générer des événements pour les 30 prochains jours
    for (int i = 0; i < 20; i++) {
      // Jour aléatoire dans les 30 prochains jours
      final day = now.add(Duration(days: Random().nextInt(30)));
      
      // Heure de début aléatoire entre 8h et 17h
      final startHour = 8 + Random().nextInt(9);
      final startMinute = Random().nextInt(4) * 15; // 0, 15, 30, 45
      final startTime = DateTime(
        day.year,
        day.month,
        day.day,
        startHour,
        startMinute,
      );
      
      // Durée aléatoire entre 30 minutes et 2 heures
      final durationMinutes = 30 + Random().nextInt(4) * 30; // 30, 60, 90, 120
      final endTime = startTime.add(Duration(minutes: durationMinutes));
      
      // Couleur aléatoire
      final color = colors[Random().nextInt(colors.length)];
      
      // Type aléatoire
      final type = eventTypes[Random().nextInt(eventTypes.length)];
      
      // Créer l'événement
      final event = Event(
        id: _uuid.v4(),
        title: 'Événement ${i + 1}',
        description: 'Description de l\'événement ${i + 1}',
        startTime: startTime,
        endTime: endTime,
        color: color,
        isAllDay: Random().nextBool() && Random().nextBool(), // 25% de chance
        type: type,
        location: Random().nextBool() ? 'Bureau' : 'En ligne',
        createdAt: now,
        updatedAt: now,
      );
      
      _events.add(event);
    }
    
    // Générer des tâches
    for (int i = 0; i < 15; i++) {
      // Date d'échéance aléatoire dans les 14 prochains jours (peut être null)
      final hasDueDate = Random().nextBool();
      final dueDate = hasDueDate 
          ? now.add(Duration(days: Random().nextInt(14)))
          : null;
      
      // Priorité aléatoire entre 1 et 5
      final priority = 1 + Random().nextInt(5);
      
      // Catégorie aléatoire
      final category = categories[Random().nextInt(categories.length)];
      
      // Statut aléatoire
      final statusValues = TaskStatus.values;
      final status = statusValues[Random().nextInt(statusValues.length)];
      
      // Durée estimée aléatoire entre 15 minutes et 4 heures
      final estimatedDuration = 15 + Random().nextInt(16) * 15; // 15 min à 4h
      
      // Créer la tâche
      final task = Task(
        id: _uuid.v4(),
        title: 'Tâche ${i + 1}',
        description: 'Description de la tâche ${i + 1}',
        dueDate: dueDate,
        priority: priority,
        category: category,
        status: status,
        createdAt: now.subtract(Duration(days: Random().nextInt(7))),
        updatedAt: now,
        estimatedDuration: estimatedDuration,
      );
      
      _tasks.add(task);
    }
  }

  @override
  Future<List<Event>> getEvents(DateTime start, DateTime end) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Filtrer les événements qui sont dans la période demandée
    return _events.where((event) {
      return (event.startTime.isAfter(start) || event.startTime.isAtSameMomentAs(start)) &&
             (event.startTime.isBefore(end)) ||
             // Inclure les événements qui commencent avant mais se terminent pendant la période
             (event.startTime.isBefore(start) && event.endTime.isAfter(start));
    }).toList();
  }

  @override
  Future<Event?> getEventById(String id) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveEvent(Event event) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Vérifier si l'événement existe déjà
    final index = _events.indexWhere((e) => e.id == event.id);
    
    if (index != -1) {
      // Mettre à jour l'événement existant
      _events[index] = event;
    } else {
      // Ajouter le nouvel événement
      _events.add(event);
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    
    _events.removeWhere((event) => event.id == id);
  }

  @override
  Future<List<Task>> getTasks() async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    
    return List.from(_tasks);
  }

  @override
  Future<Task?> getTaskById(String id) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveTask(Task task) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Vérifier si la tâche existe déjà
    final index = _tasks.indexWhere((t) => t.id == task.id);
    
    if (index != -1) {
      // Mettre à jour la tâche existante
      _tasks[index] = task;
    } else {
      // Ajouter la nouvelle tâche
      _tasks.add(task);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    
    _tasks.removeWhere((task) => task.id == id);
  }

  @override
  Future<void> completeTask(String id) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _tasks.indexWhere((task) => task.id == id);
    
    if (index != -1) {
      // Mettre à jour le statut de la tâche
      final task = _tasks[index];
      _tasks[index] = task.copyWith(
        status: TaskStatus.completed,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<OptimizedPlan> generateOptimizedPlan(DateTime date) async {
    // Simuler un délai réseau plus long pour l'IA
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Trouver les tâches pour aujourd'hui
    final today = DateTime(date.year, date.month, date.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    // Trouver les événements pour aujourd'hui
    final todayEvents = await getEvents(today, tomorrow);
    
    // Trouver les tâches à faire
    final pendingTasks = _tasks.where((task) => 
      task.status == TaskStatus.pending || 
      task.status == TaskStatus.inProgress
    ).toList();
    
    // Trier les tâches par priorité
    pendingTasks.sort((a, b) => b.priority.compareTo(a.priority));
    
    // Créer des créneaux horaires pour la journée
    final timeSlots = <TimeSlot>[];
    
    // Commencer à 9h
    DateTime currentTime = DateTime(today.year, today.month, today.day, 9, 0);
    
    // Ajouter les événements comme créneaux fixes
    for (final event in todayEvents) {
      // Ajouter un créneau pour le travail avant l'événement si possible
      if (event.startTime.isAfter(currentTime) && 
          event.startTime.difference(currentTime).inMinutes >= 30) {
        
        // Ajouter une tâche si on a encore des tâches à faire
        if (pendingTasks.isNotEmpty) {
          final task = pendingTasks.removeAt(0);
          
          timeSlots.add(
            TimeSlot(
              startTime: currentTime,
              endTime: event.startTime,
              task: task,
              type: 'task',
            ),
          );
        } else {
          // Sinon, ajouter un créneau libre
          timeSlots.add(
            TimeSlot(
              startTime: currentTime,
              endTime: event.startTime,
              type: 'free',
            ),
          );
        }
      }
      
      // Ajouter l'événement
      timeSlots.add(
        TimeSlot(
          startTime: event.startTime,
          endTime: event.endTime,
          event: event,
          type: 'event',
        ),
      );
      
      // Mettre à jour le temps courant
      currentTime = event.endTime;
    }
    
    // Compléter jusqu'à 18h avec des créneaux de travail et des pauses
    final endOfDay = DateTime(today.year, today.month, today.day, 18, 0);
    
    while (currentTime.isBefore(endOfDay) && 
           currentTime.difference(endOfDay).inMinutes.abs() >= 30) {
      
      // Toutes les 2h, ajouter une pause de 15 minutes
      if (timeSlots.isNotEmpty && 
          timeSlots.last.type != 'break' && 
          Random().nextInt(3) == 0) {
        
        final breakEnd = currentTime.add(const Duration(minutes: 15));
        timeSlots.add(
          TimeSlot(
            startTime: currentTime,
            endTime: breakEnd,
            type: 'break',
          ),
        );
        currentTime = breakEnd;
        continue;
      }
      
      // Ajouter un créneau de travail
      if (pendingTasks.isNotEmpty) {
        final task = pendingTasks.removeAt(0);
        
        // Durée basée sur l'estimation de la tâche, maximum 2h
        final duration = min(task.estimatedDuration, 120);
        final endTime = currentTime.add(Duration(minutes: duration));
        
        // S'assurer que le créneau ne dépasse pas la fin de la journée
        final slotEnd = endTime.isBefore(endOfDay) ? endTime : endOfDay;
        
        timeSlots.add(
          TimeSlot(
            startTime: currentTime,
            endTime: slotEnd,
            task: task,
            type: 'task',
          ),
        );
        currentTime = slotEnd;
      } else {
        // S'il n'y a plus de tâches, ajouter un créneau libre jusqu'à la fin
        timeSlots.add(
          TimeSlot(
            startTime: currentTime,
            endTime: endOfDay,
            type: 'free',
          ),
        );
        currentTime = endOfDay;
      }
    }
    
    // Calculer des statistiques pour le plan
    int focusedWorkTime = 0;
    int breakTime = 0;
    int priorityTasksIncluded = 0;
    
    for (final slot in timeSlots) {
      if (slot.type == 'task' && slot.task != null) {
        focusedWorkTime += slot.endTime.difference(slot.startTime).inMinutes;
        if (slot.task!.priority >= 4) {
          priorityTasksIncluded++;
        }
      } else if (slot.type == 'break') {
        breakTime += slot.endTime.difference(slot.startTime).inMinutes;
      }
    }
    
    // Calculer un score d'efficacité
    final efficiencyScore = min(100, 60 + (priorityTasksIncluded * 5) + (focusedWorkTime ~/ 30));
    
    // Créer un plan optimisé
    return OptimizedPlan(
      date: today,
      timeSlots: timeSlots,
      efficiencyScore: efficiencyScore,
      priorityTasksIncluded: priorityTasksIncluded,
      focusedWorkTime: focusedWorkTime,
      breakTime: breakTime,
      aiComments: _generateAIComments(
        focusedWorkTime: focusedWorkTime,
        breakTime: breakTime,
        priorityTasksIncluded: priorityTasksIncluded,
        totalSlots: timeSlots.length,
      ),
    );
  }
  
  /// Génère des commentaires de l'IA basés sur les statistiques du plan
  String _generateAIComments({
    required int focusedWorkTime,
    required int breakTime,
    required int priorityTasksIncluded,
    required int totalSlots,
  }) {
    final comments = <String>[];
    
    // Commentaire sur le temps de travail concentré
    if (focusedWorkTime > 300) {
      comments.add("Vous avez prévu beaucoup de temps de travail concentré. Assurez-vous de prendre des pauses régulières pour maintenir votre productivité.");
    } else if (focusedWorkTime < 120) {
      comments.add("Votre journée semble avoir peu de temps dédié au travail concentré. Envisagez de bloquer davantage de temps pour les tâches importantes.");
    } else {
      comments.add("Votre équilibre de temps de travail concentré semble bon.");
    }
    
    // Commentaire sur les pauses
    if (breakTime < 30) {
      comments.add("Considérez d'ajouter plus de pauses à votre journée pour rester productif.");
    } else if (breakTime > 90) {
      comments.add("Vous avez prévu beaucoup de temps de pause. Cela peut être bénéfique pour votre bien-être, mais assurez-vous de maintenir votre productivité.");
    }
    
    // Commentaire sur les tâches prioritaires
    if (priorityTasksIncluded >= 3) {
      comments.add("Excellent! Vous avez inclus plusieurs tâches de haute priorité dans votre journée.");
    } else if (priorityTasksIncluded == 0) {
      comments.add("Aucune tâche de haute priorité n'est planifiée aujourd'hui. Vérifiez s'il y a des tâches importantes à ajouter.");
    }
    
    // Commentaire sur le nombre de créneaux
    if (totalSlots > 10) {
      comments.add("Votre journée semble très fragmentée. Envisagez de regrouper certaines activités pour réduire les changements de contexte.");
    }
    
    // Commentaire général
    if (comments.length <= 2) {
      comments.add("Ce plan semble bien équilibré entre les tâches, les événements et les pauses.");
    }
    
    return comments.join("\n\n");
  }
}
