/// Classe représentant soit une erreur (gauche), soit une valeur (droite)
class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isLeft;

  /// Constructeur privé
  const Either._(this._left, this._right, this._isLeft);

  /// Constructeur pour une erreur (gauche)
  factory Either.left(L value) => Either._(value, null, true);

  /// Constructeur pour une valeur (droite)
  factory Either.right(R value) => Either._(null, value, false);

  /// Exécute l'une des fonctions en fonction du contenu
  T fold<T>(
    T Function(L) onLeft,
    T Function(R) onRight,
  ) {
    if (_isLeft) {
      return onLeft(_left as L);
    } else {
      return onRight(_right as R);
    }
  }

  /// Vérifie si c'est une erreur
  bool get isLeft => _isLeft;

  /// Vérifie si c'est une valeur
  bool get isRight => !_isLeft;

  /// Récupère l'erreur (gauche)
  L get left => _left as L;

  /// Récupère la valeur (droite)
  R get right => _right as R;

  /// Transforme la valeur (droite)
  Either<L, T> map<T>(T Function(R) f) {
    return _isLeft ? Either.left(_left as L) : Either.right(f(_right as R));
  }

  /// Transforme l'erreur (gauche)
  Either<T, R> mapLeft<T>(T Function(L) f) {
    return _isLeft ? Either.left(f(_left as L)) : Either.right(_right as R);
  }
}
