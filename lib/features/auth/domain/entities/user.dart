import 'dart:convert';

/// Entité représentant un utilisateur
class User {
  final String id;
  final String email;
  final String? nom;
  final String? prenom;
  final String? avatarUrl;
  final DateTime? dateCreation;
  final Map<String, dynamic>? metadata;

  User({
    required this.id,
    required this.email,
    this.nom,
    this.prenom,
    this.avatarUrl,
    this.dateCreation,
    this.metadata,
  });

  /// Obtient le nom complet de l'utilisateur
  String get fullName {
    if (prenom != null && nom != null) {
      return '$prenom $nom';
    } else if (prenom != null) {
      return prenom!;
    } else if (nom != null) {
      return nom!;
    } else {
      return email.split('@').first;
    }
  }

  /// Obtient les initiales de l'utilisateur
  String get initials {
    if (prenom != null && nom != null) {
      return '${prenom![0]}${nom![0]}'.toUpperCase();
    } else if (prenom != null) {
      return prenom![0].toUpperCase();
    } else if (nom != null) {
      return nom![0].toUpperCase();
    } else {
      return email[0].toUpperCase();
    }
  }

  /// Copie l'utilisateur avec des valeurs modifiées
  User copyWith({
    String? id,
    String? email,
    String? nom,
    String? prenom,
    String? avatarUrl,
    DateTime? dateCreation,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateCreation: dateCreation ?? this.dateCreation,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convertit l'utilisateur en map
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

  /// Crée un utilisateur à partir d'une map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      nom: map['nom'],
      prenom: map['prenom'],
      avatarUrl: map['avatarUrl'],
      dateCreation: map['dateCreation'] != null
          ? DateTime.parse(map['dateCreation'])
          : null,
      metadata: map['metadata'],
    );
  }

  /// Convertit l'utilisateur en JSON
  String toJson() => json.encode(toMap());

  /// Crée un utilisateur à partir d'un JSON
  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, email: $email, nom: $nom, prenom: $prenom)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
