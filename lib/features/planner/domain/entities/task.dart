import 'package:equatable/equatable.dart';

/// Énumération des statuts possibles pour une tâche
enum TaskStatus {
  pending,  // En attente
  inProgress,  // En cours
  completed,  // Terminée
  cancelled,  // Annulée
}

/// Modèle de donnée pour une tâche
class Task extends Equatable {
  /// Identifiant unique de la tâche
  final String id;
  
  /// Titre de la tâche
  final String title;
  
  /// Description détaillée de la tâche
  final String description;
  
  /// Date d'échéance de la tâche
  final DateTime? dueDate;
  
  /// Priorité de la tâche (1-5, où 5 est la plus haute)
  final int priority;
  
  /// Catégorie de la tâche
  final String category;
  
  /// Statut actuel de la tâche
  final TaskStatus status;
  
  /// Date de création de la tâche
  final DateTime createdAt;
  
  /// Date de dernière mise à jour de la tâche
  final DateTime updatedAt;
  
  /// Durée estimée en minutes
  final int estimatedDuration;
  
  /// Constructeur
  const Task({
    required this.id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.priority = 3,
    this.category = 'Générale',
    this.status = TaskStatus.pending,
    required this.createdAt,
    required this.updatedAt,
    this.estimatedDuration = 60,
  });
  
  /// Méthode pour créer une copie de la tâche avec des modifications
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    int? priority,
    String? category,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? estimatedDuration,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
    );
  }
  
  @override
  List<Object?> get props => [
    id, 
    title, 
    description, 
    dueDate, 
    priority, 
    category, 
    status, 
    createdAt, 
    updatedAt, 
    estimatedDuration,
  ];
}
