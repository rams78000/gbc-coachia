import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';

abstract class EventLocalSource {
  Future<List<Event>> getEvents();
  Future<Event?> getEventById(String id);
  Future<void> addEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(String id);
}

class EventLocalSourceImpl implements EventLocalSource {
  final SharedPreferences sharedPreferences;
  static const String _eventsKey = 'events';

  EventLocalSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Event>> getEvents() async {
    final eventsJson = sharedPreferences.getStringList(_eventsKey) ?? [];
    return eventsJson
        .map((json) => Event.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<Event?> getEventById(String id) async {
    final events = await getEvents();
    try {
      return events.firstWhere(
        (event) => event.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addEvent(Event event) async {
    final events = await getEvents();
    events.add(event);
    await _saveEvents(events);
  }

  @override
  Future<void> updateEvent(Event event) async {
    final events = await getEvents();
    final index = events.indexWhere((e) => e.id == event.id);
    
    if (index != -1) {
      events[index] = event;
      await _saveEvents(events);
    } else {
      throw Exception('Event not found');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    final events = await getEvents();
    events.removeWhere((event) => event.id == id);
    await _saveEvents(events);
  }

  Future<void> _saveEvents(List<Event> events) async {
    final eventsJson = events
        .map((event) => jsonEncode(event.toJson()))
        .toList();
    
    await sharedPreferences.setStringList(_eventsKey, eventsJson);
  }
}
