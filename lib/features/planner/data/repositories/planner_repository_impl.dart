import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/planner_repository.dart';

/// Implémentation du repository du planificateur
class PlannerRepositoryImpl implements PlannerRepository {
  /// Clé pour stocker les événements dans SharedPreferences
  static const _eventsKey = 'planner_events';

  @override
  Future<List<PlanEvent>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getStringList(_eventsKey) ?? [];
    
    return eventsJson
        .map((json) => _eventFromJson(json))
        .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  @override
  Future<void> addEvent(PlanEvent event) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getStringList(_eventsKey) ?? [];
    
    // Utiliser l'ID existant ou en générer un nouveau
    final eventWithId = event.id.isEmpty 
        ? event.copyWith(id: const Uuid().v4()) 
        : event;
    
    eventsJson.add(_eventToJson(eventWithId));
    await prefs.setStringList(_eventsKey, eventsJson);
  }

  @override
  Future<void> updateEvent(PlanEvent event) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getStringList(_eventsKey) ?? [];
    
    final events = eventsJson.map((json) => _eventFromJson(json)).toList();
    
    final index = events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      events[index] = event;
      
      final updatedEventsJson = events.map((e) => _eventToJson(e)).toList();
      await prefs.setStringList(_eventsKey, updatedEventsJson);
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getStringList(_eventsKey) ?? [];
    
    final events = eventsJson.map((json) => _eventFromJson(json)).toList();
    
    events.removeWhere((event) => event.id == id);
    
    final updatedEventsJson = events.map((e) => _eventToJson(e)).toList();
    await prefs.setStringList(_eventsKey, updatedEventsJson);
  }

  /// Convertit un PlanEvent en JSON
  String _eventToJson(PlanEvent event) {
    return jsonEncode(event.toMap());
  }

  /// Crée un PlanEvent à partir d'un JSON
  PlanEvent _eventFromJson(String json) {
    return PlanEvent.fromMap(jsonDecode(json));
  }
}
