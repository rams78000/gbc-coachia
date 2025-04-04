/// Événements d'authentification
abstract class AuthEvent {
  /// Constructeur par défaut
  const AuthEvent();
}

/// Événement de chargement initial de l'état d'authentification
class AuthCheckStatusEvent extends AuthEvent {
  /// Constructeur
  const AuthCheckStatusEvent();
}

/// Événement de connexion
class AuthSignInEvent extends AuthEvent {
  /// Email pour la connexion
  final String email;
  
  /// Mot de passe pour la connexion
  final String password;
  
  /// Constructeur
  const AuthSignInEvent({
    required this.email,
    required this.password,
  });
}

/// Événement d'inscription
class AuthSignUpEvent extends AuthEvent {
  /// Email pour l'inscription
  final String email;
  
  /// Mot de passe pour l'inscription
  final String password;
  
  /// Nom d'utilisateur pour l'inscription
  final String username;
  
  /// Nom complet pour l'inscription (optionnel)
  final String? fullName;
  
  /// Constructeur
  const AuthSignUpEvent({
    required this.email,
    required this.password,
    required this.username,
    this.fullName,
  });
}

/// Événement de déconnexion
class AuthSignOutEvent extends AuthEvent {
  /// Constructeur
  const AuthSignOutEvent();
}

/// Événement pour marquer l'onboarding comme vu
class AuthSetOnboardingSeenEvent extends AuthEvent {
  /// Constructeur
  const AuthSetOnboardingSeenEvent();
}

/// Événement pour mettre à jour le profil utilisateur
class AuthUpdateProfileEvent extends AuthEvent {
  /// Nouveau nom d'utilisateur
  final String? username;
  
  /// Nouveau nom complet
  final String? fullName;
  
  /// Nouvel email
  final String? email;
  
  /// Nouvelle photo de profil
  final String? photoUrl;
  
  /// Constructeur
  const AuthUpdateProfileEvent({
    this.username,
    this.fullName,
    this.email,
    this.photoUrl,
  });
}
