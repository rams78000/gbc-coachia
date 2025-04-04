import 'package:equatable/equatable.dart';

/// Type de compte financier
enum AccountType {
  checking,  // Compte courant
  savings,   // Compte d'épargne
  creditCard, // Carte de crédit
  investment, // Compte d'investissement
  loan,      // Prêt
  cash,      // Espèces
}

/// Extension pour ajouter des méthodes utilitaires aux types de compte
extension AccountTypeExtension on AccountType {
  /// Renvoie le nom localisé du type de compte
  String getLocalizedName() {
    switch (this) {
      case AccountType.checking:
        return 'Compte courant';
      case AccountType.savings:
        return 'Compte d\'épargne';
      case AccountType.creditCard:
        return 'Carte de crédit';
      case AccountType.investment:
        return 'Compte d\'investissement';
      case AccountType.loan:
        return 'Prêt';
      case AccountType.cash:
        return 'Espèces';
    }
  }
}

/// Classe représentant un compte financier
class Account extends Equatable {
  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final double initialBalance;
  final String currency;
  final String institution;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  /// Constructeur privé
  const Account._({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.initialBalance,
    required this.currency,
    required this.institution,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
  
  /// Constructeur de création
  factory Account.create({
    required String id,
    required String name,
    required AccountType type,
    required double initialBalance,
    required String currency,
    required String institution,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account._(
      id: id,
      name: name,
      type: type,
      balance: initialBalance,
      initialBalance: initialBalance,
      currency: currency,
      institution: institution,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  
  /// Crée une copie du compte avec des propriétés modifiées
  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    double? balance,
    double? initialBalance,
    String? currency,
    String? institution,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearDescription = false,
  }) {
    return Account._(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      initialBalance: initialBalance ?? this.initialBalance,
      currency: currency ?? this.currency,
      institution: institution ?? this.institution,
      description: clearDescription ? null : (description ?? this.description),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    type,
    balance,
    initialBalance,
    currency,
    institution,
    description,
    createdAt,
    updatedAt,
  ];
}
