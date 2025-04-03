import 'package:equatable/equatable.dart';

/// Transaction type enum
enum TransactionType {
  /// Income transaction
  income,
  
  /// Expense transaction
  expense,
  
  /// Transfer transaction
  transfer,
}

/// Transaction category entity
class TransactionCategory extends Equatable {
  /// Category ID
  final String id;
  
  /// Category name
  final String name;
  
  /// Category icon
  final String icon;
  
  /// Category color
  final int color;
  
  /// Is income category
  final bool isIncome;
  
  /// Category constructor
  const TransactionCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isIncome = false,
  });
  
  /// Copy with method
  TransactionCategory copyWith({
    String? id,
    String? name,
    String? icon,
    int? color,
    bool? isIncome,
  }) {
    return TransactionCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isIncome: isIncome ?? this.isIncome,
    );
  }
  
  @override
  List<Object?> get props => [id, name, icon, color, isIncome];
}

/// Transaction entity
class Transaction extends Equatable {
  /// Transaction ID
  final String id;
  
  /// Transaction amount
  final double amount;
  
  /// Transaction description
  final String description;
  
  /// Transaction date
  final DateTime date;
  
  /// Transaction type
  final TransactionType type;
  
  /// Transaction category
  final TransactionCategory category;
  
  /// Transaction account ID
  final String accountId;
  
  /// Destination account ID (for transfers)
  final String? destinationAccountId;
  
  /// Is transaction recurring
  final bool isRecurring;
  
  /// Recurrence pattern (e.g., 'daily', 'weekly', 'monthly')
  final String? recurrencePattern;
  
  /// Next recurrence date
  final DateTime? nextRecurrenceDate;
  
  /// Transaction location
  final String? location;
  
  /// Transaction attachments
  final List<String> attachments;
  
  /// Transaction created at
  final DateTime createdAt;
  
  /// Transaction updated at
  final DateTime updatedAt;
  
  /// Transaction constructor
  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
    required this.category,
    required this.accountId,
    this.destinationAccountId,
    this.isRecurring = false,
    this.recurrencePattern,
    this.nextRecurrenceDate,
    this.location,
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Copy with method
  Transaction copyWith({
    String? id,
    double? amount,
    String? description,
    DateTime? date,
    TransactionType? type,
    TransactionCategory? category,
    String? accountId,
    String? destinationAccountId,
    bool? isRecurring,
    String? recurrencePattern,
    DateTime? nextRecurrenceDate,
    String? location,
    List<String>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
      accountId: accountId ?? this.accountId,
      destinationAccountId: destinationAccountId ?? this.destinationAccountId,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      nextRecurrenceDate: nextRecurrenceDate ?? this.nextRecurrenceDate,
      location: location ?? this.location,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    amount,
    description,
    date,
    type,
    category,
    accountId,
    destinationAccountId,
    isRecurring,
    recurrencePattern,
    nextRecurrenceDate,
    location,
    attachments,
    createdAt,
    updatedAt,
  ];
}