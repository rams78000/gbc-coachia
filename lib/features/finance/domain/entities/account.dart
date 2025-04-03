import 'package:equatable/equatable.dart';

/// Account type enum
enum AccountType {
  /// Cash account
  cash,
  
  /// Bank account
  bank,
  
  /// Credit card account
  creditCard,
  
  /// Investment account
  investment,
  
  /// Savings account
  savings,
  
  /// Loan account
  loan,
  
  /// Other account type
  other,
}

/// Account entity
class Account extends Equatable {
  /// Account ID
  final String id;
  
  /// Account name
  final String name;
  
  /// Account type
  final AccountType type;
  
  /// Account balance
  final double balance;
  
  /// Account currency
  final String currency;
  
  /// Account description
  final String description;
  
  /// Account color
  final int color;
  
  /// Account icon
  final String icon;
  
  /// Include in total
  final bool includeInTotal;
  
  /// Is archived
  final bool isArchived;
  
  /// Account created at
  final DateTime createdAt;
  
  /// Account updated at
  final DateTime updatedAt;
  
  /// Account constructor
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.currency = 'EUR',
    this.description = '',
    this.color = 0xFF000000,
    this.icon = 'account_balance',
    this.includeInTotal = true,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Copy with method
  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    double? balance,
    String? currency,
    String? description,
    int? color,
    String? icon,
    bool? includeInTotal,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      includeInTotal: includeInTotal ?? this.includeInTotal,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    type,
    balance,
    currency,
    description,
    color,
    icon,
    includeInTotal,
    isArchived,
    createdAt,
    updatedAt,
  ];
}