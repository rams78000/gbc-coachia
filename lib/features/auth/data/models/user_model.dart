import 'package:gbc_coachia/features/auth/domain/entities/user.dart';

/// Modèle d'utilisateur pour la couche de données
class UserModel extends User {
  UserModel({
    required String id,
    required String email,
    String? nom,
    String? prenom,
    String? avatarUrl,
    DateTime? dateCreation,
    Map<String, dynamic>? metadata,
  }) : super(
          id: id,
          email: email,
          nom: nom,
          prenom: prenom,
          avatarUrl: avatarUrl,
          dateCreation: dateCreation,
          metadata: metadata,
        );

  /// Création à partir de JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nom: json['nom'],
      prenom: json['prenom'],
      avatarUrl: json['avatarUrl'],
      dateCreation: json['dateCreation'] != null 
          ? DateTime.parse(json['dateCreation']) 
          : DateTime.now(),
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }

  /// Conversion en JSON
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'avatarUrl': avatarUrl,
      'dateCreation': dateCreation?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Création d'un utilisateur par défaut pour les tests
  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      nom: '',
      dateCreation: DateTime.now(),
    );
  }

  /// Copie l'objet avec des valeurs modifiées
  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? nom,
    String? prenom,
    String? avatarUrl,
    DateTime? dateCreation,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateCreation: dateCreation ?? this.dateCreation,
      metadata: metadata ?? this.metadata,
    );
  }
}
