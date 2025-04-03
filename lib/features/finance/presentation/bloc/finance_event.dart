import 'package:equatable/equatable.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/transaction.dart';

/// Abstract class for Finance events
abstract class FinanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Transaction events

/// Event to load all transactions
class LoadTransactionsEvent extends FinanceEvent {}

/// Event to load transactions by date range
class LoadTransactionsByDateRangeEvent extends FinanceEvent {
  /// Start date
  final DateTime startDate;
  
  /// End date
  final DateTime endDate;

  /// Constructor
  LoadTransactionsByDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

/// Event to load transactions by type
class LoadTransactionsByTypeEvent extends FinanceEvent {
  /// Transaction type
  final TransactionType type;

  /// Constructor
  LoadTransactionsByTypeEvent({required this.type});

  @override
  List<Object> get props => [type];
}

/// Event to load transactions by category
class LoadTransactionsByCategoryEvent extends FinanceEvent {
  /// Category ID
  final String categoryId;

  /// Constructor
  LoadTransactionsByCategoryEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

/// Event to load transactions by account
class LoadTransactionsByAccountEvent extends FinanceEvent {
  /// Account ID
  final String accountId;

  /// Constructor
  LoadTransactionsByAccountEvent({required this.accountId});

  @override
  List<Object> get props => [accountId];
}

/// Event to add a transaction
class AddTransactionEvent extends FinanceEvent {
  /// Transaction to add
  final Transaction transaction;

  /// Constructor
  AddTransactionEvent({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

/// Event to update a transaction
class UpdateTransactionEvent extends FinanceEvent {
  /// Transaction to update
  final Transaction transaction;

  /// Constructor
  UpdateTransactionEvent({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

/// Event to delete a transaction
class DeleteTransactionEvent extends FinanceEvent {
  /// Transaction ID to delete
  final String transactionId;

  /// Constructor
  DeleteTransactionEvent({required this.transactionId});

  @override
  List<Object> get props => [transactionId];
}

// Account events

/// Event to load all accounts
class LoadAccountsEvent extends FinanceEvent {}

/// Event to add an account
class AddAccountEvent extends FinanceEvent {
  /// Account to add
  final Account account;

  /// Constructor
  AddAccountEvent({required this.account});

  @override
  List<Object> get props => [account];
}

/// Event to update an account
class UpdateAccountEvent extends FinanceEvent {
  /// Account to update
  final Account account;

  /// Constructor
  UpdateAccountEvent({required this.account});

  @override
  List<Object> get props => [account];
}

/// Event to delete an account
class DeleteAccountEvent extends FinanceEvent {
  /// Account ID to delete
  final String accountId;

  /// Constructor
  DeleteAccountEvent({required this.accountId});

  @override
  List<Object> get props => [accountId];
}

// Category events

/// Event to load all categories
class LoadCategoriesEvent extends FinanceEvent {}

/// Event to add a category
class AddCategoryEvent extends FinanceEvent {
  /// Category to add
  final TransactionCategory category;

  /// Constructor
  AddCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

/// Event to update a category
class UpdateCategoryEvent extends FinanceEvent {
  /// Category to update
  final TransactionCategory category;

  /// Constructor
  UpdateCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

/// Event to delete a category
class DeleteCategoryEvent extends FinanceEvent {
  /// Category ID to delete
  final String categoryId;

  /// Constructor
  DeleteCategoryEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

// Summary events

/// Event to load financial summary
class LoadFinancialSummaryEvent extends FinanceEvent {
  /// Start date
  final DateTime startDate;
  
  /// End date
  final DateTime endDate;

  /// Constructor
  LoadFinancialSummaryEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}
