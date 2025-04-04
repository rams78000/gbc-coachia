import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Modèle de donnée pour un événement calendrier
class Event extends Equatable {
  /// Identifiant unique de l'événement
  final String id;
  
  /// Titre de l'événement
  final String title;
  
  /// Description détaillée de l'événement
  final String description;
  
  /// Date et heure de début de l'événement
  final DateTime startTime;
  
  /// Date et heure de fin de l'événement
  final DateTime endTime;
  
  /// Couleur de l'événement pour l'affichage
  final Color color;
  
  /// Indique si l'événement est une journée entière
  final bool isAllDay;
  
  /// Type de l'événement (professionnel, personnel, etc.)
  final String type;
  
  /// Lieu de l'événement
  final String location;
  
  /// Date de création de l'événement
  final DateTime createdAt;
  
  /// Date de dernière mise à jour de l'événement
  final DateTime updatedAt;
  
  /// Constructeur
  const Event({
    required this.id,
    required this.title,
    this.description = '',
    required this.startTime,
    required this.endTime,
    required this.color,
    this.isAllDay = false,
    this.type = 'Professionnel',
    this.location = '',
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Méthode pour créer une copie de l'événement avec des modifications
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    Color? color,
    bool? isAllDay,
    String? type,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      isAllDay: isAllDay ?? this.isAllDay,
      type: type ?? this.type,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  /// Durée de l'événement en minutes
  int get durationInMinutes => endTime.difference(startTime).inMinutes;
  
  @override
  List<Object?> get props => [
    id, 
    title, 
    description, 
    startTime, 
    endTime, 
    color, 
    isAllDay, 
    type, 
    location, 
    createdAt, 
    updatedAt,
  ];
}
