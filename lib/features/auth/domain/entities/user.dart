import 'package:equatable/equatable.dart';

/// Entité utilisateur
class User extends Equatable {
  /// Constructeur
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
  });

  /// ID de l'utilisateur
  final String id;
  
  /// Email de l'utilisateur
  final String email;
  
  /// Nom de l'utilisateur
  final String name;
  
  /// URL de la photo de profil
  final String? photoUrl;

  @override
  List<Object?> get props => [id, email, name, photoUrl];
}
