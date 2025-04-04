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
  final List<FinancialSummary>? summaries;
  final Map<TransactionCategory, double>? expensesByCategory;
  final Map<TransactionCategory, double>? incomesByCategory;
  final FinancialPeriod selectedPeriod;

  const FinancialSummaryLoaded({
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
    this.startDate,
    this.endDate,
    this.summaries,
    this.expensesByCategory,
    this.incomesByCategory,
    this.selectedPeriod = FinancialPeriod.monthly,
  });

  @override
  List<Object?> get props => [
    totalIncome,
    totalExpenses,
    balance,
    startDate,
    endDate,
    summaries,
    expensesByCategory,
    incomesByCategory,
    selectedPeriod,
  ];
  
  /// Crée une copie de l'état avec des propriétés modifiées
  FinancialSummaryLoaded copyWith({
    double? totalIncome,
    double? totalExpenses,
    double? balance,
    DateTime? startDate,
    DateTime? endDate,
    List<FinancialSummary>? summaries,
    Map<TransactionCategory, double>? expensesByCategory,
    Map<TransactionCategory, double>? incomesByCategory,
    FinancialPeriod? selectedPeriod,
  }) {
    return FinancialSummaryLoaded(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      balance: balance ?? this.balance,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      summaries: summaries ?? this.summaries,
      expensesByCategory: expensesByCategory ?? this.expensesByCategory,
      incomesByCategory: incomesByCategory ?? this.incomesByCategory,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    );
  }
}

class FinancialSummaryError extends FinanceState {
  final String message;

  const FinancialSummaryError({required this.message});

  @override
  List<Object> get props => [message];
}
