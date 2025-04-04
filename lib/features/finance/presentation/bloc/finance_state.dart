part of 'finance_bloc.dart';

abstract class FinanceState extends Equatable {
  const FinanceState();
  
  @override
  List<Object?> get props => [];
}

class FinanceInitial extends FinanceState {}

// États pour la gestion des transactions
class TransactionsLoading extends FinanceState {}

class TransactionsLoaded extends FinanceState {
  final List<Transaction> transactions;
  final TransactionType? filteredType;
  final DateTime? startDate;
  final DateTime? endDate;

  const TransactionsLoaded({
    required this.transactions,
    this.filteredType,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    transactions,
    filteredType,
    startDate,
    endDate,
  ];
}

class TransactionsError extends FinanceState {
  final String message;

  const TransactionsError({required this.message});

  @override
  List<Object> get props => [message];
}

// États pour les calculs financiers
class FinancialSummaryLoading extends FinanceState {}

class FinancialSummaryLoaded extends FinanceState {
  final double totalIncome;
  final double totalExpenses;
  final double balance;
  final DateTime? startDate;
  final DateTime? endDate;

  const FinancialSummaryLoaded({
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    totalIncome,
    totalExpenses,
    balance,
    startDate,
    endDate,
  ];
}

class FinancialSummaryError extends FinanceState {
  final String message;

  const FinancialSummaryError({required this.message});

  @override
  List<Object> get props => [message];
}
