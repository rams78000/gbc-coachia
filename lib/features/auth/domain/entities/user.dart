/// Entité représentant un utilisateur
class User {
  /// Identifiant de l'utilisateur
  final String id;
  
  /// Email de l'utilisateur
  final String email;
  
  /// Nom d'utilisateur
  final String username;
  
  /// Nom complet (optionnel)
  final String? fullName;
  
  /// URL de la photo de profil (optionnel)
  final String? photoUrl;
  
  /// Date de création du compte
  final DateTime createdAt;
  
  /// Date de dernière mise à jour du compte
  final DateTime updatedAt;
  
  /// Constructeur
  const User({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Créer une copie de l'utilisateur avec des modifications
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? fullName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  /// Obtenir une représentation chaîne de caractères de l'utilisateur
  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username)';
  }
  
  /// Comparer deux utilisateurs
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.username == username &&
        other.fullName == fullName &&
        other.photoUrl == photoUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }
  
  /// Obtenir le code de hachage de l'utilisateur
  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        username.hashCode ^
        fullName.hashCode ^
        photoUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
