import 'package:gbc_coachia/features/planner/domain/entities/event.dart';

abstract class EventRepository {
  /// Récupère tous les événements
  Future<List<Event>> getEvents();
  
  /// Récupère un événement par son ID
  Future<Event?> getEventById(String id);
  
  /// Ajoute un nouvel événement
  Future<void> addEvent(Event event);
  
  /// Met à jour un événement existant
  Future<void> updateEvent(Event event);
  
  /// Supprime un événement
  Future<void> deleteEvent(String id);
  
  /// Récupère les événements par catégorie
  Future<List<Event>> getEventsByCategory(EventCategory category);
  
  /// Récupère les événements par priorité
  Future<List<Event>> getEventsByPriority(EventPriority priority);
  
  /// Récupère les événements pour une période donnée
  Future<List<Event>> getEventsByDateRange(DateTime start, DateTime end);
  
  /// Récupère les événements pour une date spécifique
  Future<List<Event>> getEventsByDate(DateTime date);
  
  /// Marque un événement comme complété
  Future<void> markEventAsCompleted(String id, bool isCompleted);
}
