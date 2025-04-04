import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum EventPriority {
  low,
  medium,
  high,
}

enum EventCategory {
  meeting,
  task,
  deadline,
  appointment,
  reminder,
  personal,
  other,
}

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isAllDay;
  final EventPriority priority;
  final EventCategory category;
  final bool isRecurring;
  final RecurrencePattern? recurrencePattern;
  final List<String> notes;
  final String? location;
  final String? url;
  final List<String>? attendees;
  final bool isCompleted;

  const Event({
    required this.id,
    required this.title,
    this.description = '',
    required this.startDate,
    this.endDate,
    this.isAllDay = false,
    this.priority = EventPriority.medium,
    this.category = EventCategory.other,
    this.isRecurring = false,
    this.recurrencePattern,
    this.notes = const [],
    this.location,
    this.url,
    this.attendees,
    this.isCompleted = false,
  });

  /// Crée un nouvel événement avec un ID généré automatiquement
  factory Event.create({
    required String title,
    String description = '',
    required DateTime startDate,
    DateTime? endDate,
    bool isAllDay = false,
    EventPriority priority = EventPriority.medium,
    EventCategory category = EventCategory.other,
    bool isRecurring = false,
    RecurrencePattern? recurrencePattern,
    List<String> notes = const [],
    String? location,
    String? url,
    List<String>? attendees,
    bool isCompleted = false,
  }) {
    final uuid = const Uuid().v4();
    return Event(
      id: uuid,
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isAllDay: isAllDay,
      priority: priority,
      category: category,
      isRecurring: isRecurring,
      recurrencePattern: recurrencePattern,
      notes: notes,
      location: location,
      url: url,
      attendees: attendees,
      isCompleted: isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startDate,
        endDate,
        isAllDay,
        priority,
        category,
        isRecurring,
        recurrencePattern,
        notes,
        location,
        url,
        attendees,
        isCompleted,
      ];

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAllDay,
    EventPriority? priority,
    EventCategory? category,
    bool? isRecurring,
    RecurrencePattern? recurrencePattern,
    List<String>? notes,
    String? location,
    String? url,
    List<String>? attendees,
    bool? isCompleted,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isAllDay: isAllDay ?? this.isAllDay,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      notes: notes ?? this.notes,
      location: location ?? this.location,
      url: url ?? this.url,
      attendees: attendees ?? this.attendees,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Conversion depuis/vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isAllDay': isAllDay,
      'priority': priority.index,
      'category': category.index,
      'isRecurring': isRecurring,
      'recurrencePattern': recurrencePattern?.toJson(),
      'notes': notes,
      'location': location,
      'url': url,
      'attendees': attendees,
      'isCompleted': isCompleted,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      isAllDay: json['isAllDay'] as bool? ?? false,
      priority: EventPriority.values[json['priority'] as int? ?? 1],
      category: EventCategory.values[json['category'] as int? ?? 6],
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurrencePattern: json['recurrencePattern'] != null
          ? RecurrencePattern.fromJson(
              json['recurrencePattern'] as Map<String, dynamic>)
          : null,
      notes: (json['notes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      location: json['location'] as String?,
      url: json['url'] as String?,
      attendees: (json['attendees'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

enum RecurrenceFrequency {
  daily,
  weekly,
  monthly,
  yearly,
}

class RecurrencePattern extends Equatable {
  final RecurrenceFrequency frequency;
  final int interval; // Ex: tous les 2 jours pour daily et interval=2
  final DateTime startDate;
  final DateTime? endDate;
  final int? occurrences; // Nombre d'occurrences si pas de end date
  final List<int>? daysOfWeek; // 1-7 pour lun-dim
  final int? dayOfMonth; // 1-31 pour un jour spécifique du mois
  final int? monthOfYear; // 1-12 pour un mois spécifique de l'année

  const RecurrencePattern({
    required this.frequency,
    this.interval = 1,
    required this.startDate,
    this.endDate,
    this.occurrences,
    this.daysOfWeek,
    this.dayOfMonth,
    this.monthOfYear,
  });

  @override
  List<Object?> get props => [
        frequency,
        interval,
        startDate,
        endDate,
        occurrences,
        daysOfWeek,
        dayOfMonth,
        monthOfYear,
      ];

  RecurrencePattern copyWith({
    RecurrenceFrequency? frequency,
    int? interval,
    DateTime? startDate,
    DateTime? endDate,
    int? occurrences,
    List<int>? daysOfWeek,
    int? dayOfMonth,
    int? monthOfYear,
  }) {
    return RecurrencePattern(
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      occurrences: occurrences ?? this.occurrences,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      monthOfYear: monthOfYear ?? this.monthOfYear,
    );
  }

  // Conversion depuis/vers JSON
  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency.index,
      'interval': interval,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'occurrences': occurrences,
      'daysOfWeek': daysOfWeek,
      'dayOfMonth': dayOfMonth,
      'monthOfYear': monthOfYear,
    };
  }

  factory RecurrencePattern.fromJson(Map<String, dynamic> json) {
    return RecurrencePattern(
      frequency: RecurrenceFrequency.values[json['frequency'] as int],
      interval: json['interval'] as int? ?? 1,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      occurrences: json['occurrences'] as int?,
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      dayOfMonth: json['dayOfMonth'] as int?,
      monthOfYear: json['monthOfYear'] as int?,
    );
  }
}
