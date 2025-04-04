import 'package:gbc_coachia/features/planner/data/sources/event_local_source.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:gbc_coachia/features/planner/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventLocalSource localSource;

  EventRepositoryImpl({required this.localSource});

  @override
  Future<List<Event>> getEvents() async {
    return await localSource.getEvents();
  }

  @override
  Future<Event?> getEventById(String id) async {
    return await localSource.getEventById(id);
  }

  @override
  Future<void> addEvent(Event event) async {
    await localSource.addEvent(event);
  }

  @override
  Future<void> updateEvent(Event event) async {
    await localSource.updateEvent(event);
  }

  @override
  Future<void> deleteEvent(String id) async {
    await localSource.deleteEvent(id);
  }

  @override
  Future<List<Event>> getEventsByCategory(EventCategory category) async {
    final events = await localSource.getEvents();
    return events.where((event) => event.category == category).toList();
  }

  @override
  Future<List<Event>> getEventsByPriority(EventPriority priority) async {
    final events = await localSource.getEvents();
    return events.where((event) => event.priority == priority).toList();
  }

  @override
  Future<List<Event>> getEventsByDateRange(DateTime start, DateTime end) async {
    final events = await localSource.getEvents();
    return events.where((event) {
      // Vérifier si l'évènement se situe dans la période spécifiée
      if (event.isAllDay) {
        // Pour les événements sur toute la journée, on vérifie si leur date est dans la plage
        final eventDate = DateTime(
          event.startDate.year,
          event.startDate.month,
          event.startDate.day,
        );
        final rangeStart = DateTime(start.year, start.month, start.day);
        final rangeEnd = DateTime(end.year, end.month, end.day);
        
        return !eventDate.isBefore(rangeStart) && !eventDate.isAfter(rangeEnd);
      } else if (event.endDate != null) {
        // Pour les événements avec une heure de début et de fin
        return (event.startDate.isAfter(start) || event.startDate.isAtSameMomentAs(start)) &&
               (event.endDate!.isBefore(end) || event.endDate!.isAtSameMomentAs(end));
      } else {
        // Pour les événements ponctuels (sans heure de fin)
        return event.startDate.isAfter(start.subtract(const Duration(minutes: 1))) &&
               event.startDate.isBefore(end.add(const Duration(minutes: 1)));
      }
    }).toList();
  }

  @override
  Future<List<Event>> getEventsByDate(DateTime date) async {
    // Créer un intervalle pour toute la journée
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    return getEventsByDateRange(startOfDay, endOfDay);
  }

  @override
  Future<void> markEventAsCompleted(String id, bool isCompleted) async {
    final event = await localSource.getEventById(id);
    if (event != null) {
      final updatedEvent = event.copyWith(isCompleted: isCompleted);
      await localSource.updateEvent(updatedEvent);
    } else {
      throw Exception('Event not found');
    }
  }
}
