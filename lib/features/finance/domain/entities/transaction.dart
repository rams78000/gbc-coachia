import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Type de transaction (revenu ou dépense)
enum TransactionType {
  income,
  expense,
}

/// Catégorie de transaction
enum TransactionCategory {
  // Catégories de revenus
  freelance,
  sale,
  investment,
  refund,
  other_income,
  
  // Catégories de dépenses
  rent,
  utilities,
  food,
  transportation,
  marketing,
  software,
  supplies,
  fees,
  taxes,
  other_expense,
}

/// Extension pour ajouter des méthodes utilitaires aux catégories
extension TransactionCategoryExtension on TransactionCategory {
  /// Renvoie le nom localisé de la catégorie
  String getLocalizedName() {
    switch (this) {
      // Revenus
      case TransactionCategory.freelance:
        return 'Freelance';
      case TransactionCategory.sale:
        return 'Vente';
      case TransactionCategory.investment:
        return 'Investissement';
      case TransactionCategory.refund:
        return 'Remboursement';
      case TransactionCategory.other_income:
        return 'Autre revenu';
      
      // Dépenses
      case TransactionCategory.rent:
        return 'Loyer';
      case TransactionCategory.utilities:
        return 'Services';
      case TransactionCategory.food:
        return 'Alimentation';
      case TransactionCategory.transportation:
        return 'Transport';
      case TransactionCategory.marketing:
        return 'Marketing';
      case TransactionCategory.software:
        return 'Logiciels';
      case TransactionCategory.supplies:
        return 'Fournitures';
      case TransactionCategory.fees:
        return 'Frais professionnels';
      case TransactionCategory.taxes:
        return 'Taxes';
      case TransactionCategory.other_expense:
        return 'Autre dépense';
    }
  }
  
  /// Renvoie l'icône correspondant à la catégorie
  IconData getIcon() {
    switch (this) {
      // Revenus
      case TransactionCategory.freelance:
        return Icons.work_outline;
      case TransactionCategory.sale:
        return Icons.shopping_cart_outlined;
      case TransactionCategory.investment:
        return Icons.trending_up;
      case TransactionCategory.refund:
        return Icons.replay;
      case TransactionCategory.other_income:
        return Icons.add_circle_outline;
      
      // Dépenses
      case TransactionCategory.rent:
        return Icons.home_outlined;
      case TransactionCategory.utilities:
        return Icons.electrical_services_outlined;
      case TransactionCategory.food:
        return Icons.restaurant_outlined;
      case TransactionCategory.transportation:
        return Icons.commute_outlined;
      case TransactionCategory.marketing:
        return Icons.campaign_outlined;
      case TransactionCategory.software:
        return Icons.computer_outlined;
      case TransactionCategory.supplies:
        return Icons.shopping_bag_outlined;
      case TransactionCategory.fees:
        return Icons.account_balance_outlined;
      case TransactionCategory.taxes:
        return Icons.request_quote_outlined;
      case TransactionCategory.other_expense:
        return Icons.remove_circle_outline;
    }
  }
  
  /// Renvoie la couleur correspondant à la catégorie
  Color getColor() {
    switch (this) {
      // Revenus
      case TransactionCategory.freelance:
        return Colors.blue;
      case TransactionCategory.sale:
        return Colors.green;
      case TransactionCategory.investment:
        return Colors.purple;
      case TransactionCategory.refund:
        return Colors.orange;
      case TransactionCategory.other_income:
        return Colors.teal;
      
      // Dépenses
      case TransactionCategory.rent:
        return Colors.red;
      case TransactionCategory.utilities:
        return Colors.amber;
      case TransactionCategory.food:
        return Colors.pink;
      case TransactionCategory.transportation:
        return Colors.indigo;
      case TransactionCategory.marketing:
        return Colors.deepPurple;
      case TransactionCategory.software:
        return Colors.cyan;
      case TransactionCategory.supplies:
        return Colors.lightBlue;
      case TransactionCategory.fees:
        return Colors.brown;
      case TransactionCategory.taxes:
        return Colors.deepOrange;
      case TransactionCategory.other_expense:
        return Colors.grey;
    }
  }
  
  /// Détermine si la catégorie est liée aux revenus
  bool isIncome() {
    return this == TransactionCategory.freelance ||
           this == TransactionCategory.sale ||
           this == TransactionCategory.investment ||
           this == TransactionCategory.refund ||
           this == TransactionCategory.other_income;
  }
  
  /// Détermine si la catégorie est liée aux dépenses
  bool isExpense() {
    return !isIncome();
  }
}

/// Classe représentant une transaction financière
class Transaction extends Equatable {
  final String id;
  final String title;
  final TransactionType type;
  final TransactionCategory category;
  final double amount;
  final DateTime date;
  final String? description;
  final String? accountId;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  /// Constructeur de base
  const Transaction({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
    this.accountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
  
  /// Constructeur de revenu
  factory Transaction.income({
    required String id,
    required String title,
    required double amount,
    required TransactionCategory category,
    required DateTime date,
    String? description,
    String? accountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    assert(category.isIncome(), 'La catégorie doit être une catégorie de revenu');
    return Transaction(
      id: id,
      title: title,
      type: TransactionType.income,
      category: category,
      amount: amount,
      date: date,
      description: description,
      accountId: accountId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  
  /// Constructeur de dépense
  factory Transaction.expense({
    required String id,
    required String title,
    required double amount,
    required TransactionCategory category,
    required DateTime date,
    String? description,
    String? accountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    assert(category.isExpense(), 'La catégorie doit être une catégorie de dépense');
    return Transaction(
      id: id,
      title: title,
      type: TransactionType.expense,
      category: category,
      amount: amount,
      date: date,
      description: description,
      accountId: accountId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  
  /// Crée une copie de la transaction avec des propriétés modifiées
  Transaction copyWith({
    String? id,
    String? title,
    TransactionType? type,
    TransactionCategory? category,
    double? amount,
    DateTime? date,
    String? description,
    String? accountId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearDescription = false,
    bool clearAccountId = false,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: clearDescription ? null : (description ?? this.description),
      accountId: clearAccountId ? null : (accountId ?? this.accountId),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    title,
    type,
    category,
    amount,
    date,
    description,
    accountId,
    createdAt,
    updatedAt,
  ];
}
