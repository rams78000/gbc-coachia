import 'package:gbc_coachia/features/auth/domain/entities/user.dart';

/// Modèle d'utilisateur pour la couche de données
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.nom,
    super.prenom,
    super.photoUrl,
    required super.createdAt,
    super.lastLogin,
    super.isActive,
    super.roles,
  });

  /// Création à partir de JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      nom: json['nom'],
      prenom: json['prenom'],
      photoUrl: json['photoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      isActive: json['isActive'] ?? true,
      roles: json['roles'] != null
          ? List<String>.from(json['roles'])
          : const ['user'],
    );
  }

  /// Conversion en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'isActive': isActive,
      'roles': roles,
    };
  }

  /// Création d'un utilisateur par défaut pour les tests
  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      nom: '',
      createdAt: DateTime.now(),
    );
  }
}
