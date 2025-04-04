import 'package:equatable/equatable.dart';

/// Interface pour le repository du planificateur
abstract class PlannerRepository {
  /// Récupère tous les événements
  Future<List<PlanEvent>> getEvents();

  /// Ajoute un nouvel événement
  Future<void> addEvent(PlanEvent event);

  /// Met à jour un événement existant
  Future<void> updateEvent(PlanEvent event);

  /// Supprime un événement
  Future<void> deleteEvent(String id);
}

/// Modèle pour représenter un événement dans le planificateur
class PlanEvent extends Equatable {
  /// Identifiant unique de l'événement
  final String id;

  /// Titre de l'événement
  final String title;

  /// Description de l'événement (optionnel)
  final String? description;

  /// Date et heure de début
  final DateTime startTime;

  /// Date et heure de fin
  final DateTime endTime;

  /// Couleur associée à l'événement
  final int colorValue;

  /// Indique si l'événement est une journée entière
  final bool isAllDay;

  /// Catégorie de l'événement
  final String? category;

  /// Constructeur
  const PlanEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.colorValue = 0xFF1976D2,
    this.isAllDay = false,
    this.category,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startTime,
        endTime,
        colorValue,
        isAllDay,
        category,
      ];

  /// Crée une copie de cet événement avec les valeurs données
  PlanEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    int? colorValue,
    bool? isAllDay,
    String? category,
  }) {
    return PlanEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      colorValue: colorValue ?? this.colorValue,
      isAllDay: isAllDay ?? this.isAllDay,
      category: category ?? this.category,
    );
  }

  /// Convertit l'objet en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'colorValue': colorValue,
      'isAllDay': isAllDay,
      'category': category,
    };
  }

  /// Crée un objet à partir d'une Map
  factory PlanEvent.fromMap(Map<String, dynamic> map) {
    return PlanEvent(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: DateTime.parse(map['endTime'] as String),
      colorValue: map['colorValue'] as int,
      isAllDay: map['isAllDay'] as bool,
      category: map['category'] as String?,
    );
  }
}
