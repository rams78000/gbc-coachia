import 'package:equatable/equatable.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/transaction.dart';

/// Abstract class for Finance states
abstract class FinanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state of finance
class FinanceInitial extends FinanceState {}

/// State for loading finance data
class FinanceLoading extends FinanceState {}

/// State for finance data loaded
class FinanceLoaded extends FinanceState {
  /// List of transactions
  final List<Transaction> transactions;
  
  /// List of accounts
  final List<Account> accounts;
  
  /// List of categories
  final List<TransactionCategory> categories;
  
  /// Filter by type
  final TransactionType? transactionType;
  
  /// Filter by category
  final String? categoryId;
  
  /// Filter by account
  final String? accountId;
  
  /// Filter by start date
  final DateTime? startDate;
  
  /// Filter by end date
  final DateTime? endDate;
  
  /// Total income (for summary)
  final double? totalIncome;
  
  /// Total expenses (for summary)
  final double? totalExpenses;
  
  /// Expenses by category (for summary)
  final Map<String, double>? expensesByCategory;

  /// Constructor
  FinanceLoaded({
    required this.transactions,
    required this.accounts,
    required this.categories,
    this.transactionType,
    this.categoryId,
    this.accountId,
    this.startDate,
    this.endDate,
    this.totalIncome,
    this.totalExpenses,
    this.expensesByCategory,
  });

  @override
  List<Object?> get props => [
    transactions,
    accounts,
    categories,
    transactionType,
    categoryId,
    accountId,
    startDate,
    endDate,
    totalIncome,
    totalExpenses,
    expensesByCategory,
  ];

  /// Create a copy with updated fields
  FinanceLoaded copyWith({
    List<Transaction>? transactions,
    List<Account>? accounts,
    List<TransactionCategory>? categories,
    TransactionType? transactionType,
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    double? totalIncome,
    double? totalExpenses,
    Map<String, double>? expensesByCategory,
    bool clearTransactionType = false,
    bool clearCategoryId = false,
    bool clearAccountId = false,
    bool clearDateRange = false,
  }) {
    return FinanceLoaded(
      transactions: transactions ?? this.transactions,
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
      transactionType: clearTransactionType ? null : transactionType ?? this.transactionType,
      categoryId: clearCategoryId ? null : categoryId ?? this.categoryId,
      accountId: clearAccountId ? null : accountId ?? this.accountId,
      startDate: clearDateRange ? null : startDate ?? this.startDate,
      endDate: clearDateRange ? null : endDate ?? this.endDate,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      expensesByCategory: expensesByCategory ?? this.expensesByCategory,
    );
  }
}

/// State for finance operation in progress
class FinanceOperationInProgress extends FinanceState {}

/// State for error in finance functionality
class FinanceError extends FinanceState {
  /// Error message
  final String message;

  /// Constructor
  FinanceError({required this.message});

  @override
  List<Object> get props => [message];
}
