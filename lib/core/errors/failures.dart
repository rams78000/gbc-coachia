/// Échec de base
abstract class Failure {
  /// Message d'erreur
  final String message;

  /// Constructeur
  const Failure(this.message);
}

/// Échec serveur
class ServerFailure extends Failure {
  /// Constructeur
  const ServerFailure(String message) : super(message);
}

/// Échec de cache
class CacheFailure extends Failure {
  /// Constructeur
  const CacheFailure(String message) : super(message);
}

/// Échec d'authentification
class AuthFailure extends Failure {
  /// Constructeur
  const AuthFailure(String message) : super(message);
}

/// Échec de validation
class ValidationFailure extends Failure {
  /// Champs en erreur avec messages
  final Map<String, String> fieldErrors;

  /// Constructeur
  const ValidationFailure(String message, this.fieldErrors) : super(message);
}

/// Échec de connexion
class NetworkFailure extends Failure {
  /// Constructeur
  const NetworkFailure(String message) : super(message);
}
