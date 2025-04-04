import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:table_calendar/table_calendar.dart';

/// Modèle d'événement adapté pour l'affichage dans un calendrier
/// Implémente l'interface CalendarEventData pour l'affichage dans table_calendar
class CalendarEvent extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final DateTime? endDate;
  final bool isAllDay;
  final String description;
  final EventPriority priority;
  final EventCategory category;
  final String? location;
  final bool isCompleted;
  final Color color;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    this.endDate,
    required this.isAllDay,
    this.description = '',
    this.priority = EventPriority.medium,
    this.category = EventCategory.other,
    this.location,
    this.isCompleted = false,
    required this.color,
  });

  /// Convertit un Event en CalendarEvent
  factory CalendarEvent.fromEvent(Event event, {Color? color}) {
    // Détermine la couleur en fonction de la catégorie si non spécifiée
    final eventColor = color ?? _getCategoryColor(event.category);
    
    return CalendarEvent(
      id: event.id,
      title: event.title,
      date: event.startDate,
      endDate: event.endDate,
      isAllDay: event.isAllDay,
      description: event.description,
      priority: event.priority,
      category: event.category,
      location: event.location,
      isCompleted: event.isCompleted,
      color: eventColor,
    );
  }

  /// Convertit ce CalendarEvent en Event
  Event toEvent() {
    return Event(
      id: id,
      title: title,
      description: description,
      startDate: date,
      endDate: endDate,
      isAllDay: isAllDay,
      priority: priority,
      category: category,
      location: location,
      isCompleted: isCompleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    date,
    endDate,
    isAllDay,
    description,
    priority,
    category,
    location,
    isCompleted,
    color,
  ];

  /// Crée une copie de cet objet avec les valeurs spécifiées
  CalendarEvent copyWith({
    String? id,
    String? title,
    DateTime? date,
    DateTime? endDate,
    bool? isAllDay,
    String? description,
    EventPriority? priority,
    EventCategory? category,
    String? location,
    bool? isCompleted,
    Color? color,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      endDate: endDate ?? this.endDate,
      isAllDay: isAllDay ?? this.isAllDay,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      location: location ?? this.location,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
    );
  }

  /// Détermine si l'événement a lieu à la date spécifiée
  bool isOnDate(DateTime day) {
    final dayOnly = DateTime(day.year, day.month, day.day);
    final startDateOnly = DateTime(date.year, date.month, date.day);
    
    if (endDate == null) {
      return dayOnly.isAtSameMomentAs(startDateOnly);
    }
    
    final endDateOnly = DateTime(endDate!.year, endDate!.month, endDate!.day);
    return dayOnly.isAtSameMomentAs(startDateOnly) || 
           dayOnly.isAtSameMomentAs(endDateOnly) ||
           (dayOnly.isAfter(startDateOnly) && dayOnly.isBefore(endDateOnly));
  }
}

/// Détermine la couleur en fonction de la catégorie d'événement
Color _getCategoryColor(EventCategory category) {
  switch (category) {
    case EventCategory.meeting:
      return Colors.blue;
    case EventCategory.task:
      return Colors.orange;
    case EventCategory.deadline:
      return Colors.red;
    case EventCategory.appointment:
      return Colors.purple;
    case EventCategory.reminder:
      return Colors.amber;
    case EventCategory.personal:
      return Colors.green;
    case EventCategory.other:
    default:
      return Colors.grey;
  }
}

/// Extension sur DateTime pour faciliter la comparaison de dates
extension DateTimeComparison on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
