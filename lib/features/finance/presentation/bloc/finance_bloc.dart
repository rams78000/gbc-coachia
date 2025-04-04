import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finance_repository.dart';

// Événements
abstract class FinanceEvent extends Equatable {
  const FinanceEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadTransactions extends FinanceEvent {
  const LoadTransactions();
}

class FilterTransactions extends FinanceEvent {
  final TransactionType? type;
  final TransactionCategory? category;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? accountId;
  final String? searchQuery;
  
  const FilterTransactions({
    this.type,
    this.category,
    this.startDate,
    this.endDate,
    this.accountId,
    this.searchQuery,
  });
  
  @override
  List<Object?> get props => [type, category, startDate, endDate, accountId, searchQuery];
}

class AddTransaction extends FinanceEvent {
  final Transaction transaction;
  
  const AddTransaction(this.transaction);
  
  @override
  List<Object> get props => [transaction];
}

class UpdateTransaction extends FinanceEvent {
  final Transaction transaction;
  
  const UpdateTransaction(this.transaction);
  
  @override
  List<Object> get props => [transaction];
}

class DeleteTransaction extends FinanceEvent {
  final String id;
  
  const DeleteTransaction(this.id);
  
  @override
  List<Object> get props => [id];
}

class LoadAccounts extends FinanceEvent {
  const LoadAccounts();
}

class AddAccount extends FinanceEvent {
  final Account account;
  
  const AddAccount(this.account);
  
  @override
  List<Object> get props => [account];
}

class UpdateAccount extends FinanceEvent {
  final Account account;
  
  const UpdateAccount(this.account);
  
  @override
  List<Object> get props => [account];
}

class DeleteAccount extends FinanceEvent {
  final String id;
  
  const DeleteAccount(this.id);
  
  @override
  List<Object> get props => [id];
}

class LoadFinancialSummary extends FinanceEvent {
  final DateTime startDate;
  final DateTime endDate;
  final double? budgetAmount;
  
  const LoadFinancialSummary({
    required this.startDate,
    required this.endDate,
    this.budgetAmount,
  });
  
  @override
  List<Object?> get props => [startDate, endDate, budgetAmount];
}

class LoadFinancialTrends extends FinanceEvent {
  final FinancialPeriod period;
  final int count;
  final DateTime? endDate;
  
  const LoadFinancialTrends({
    required this.period,
    required this.count,
    this.endDate,
  });
  
  @override
  List<Object?> get props => [period, count, endDate];
}

class ChangePeriod extends FinanceEvent {
  final FinancialPeriod period;
  
  const ChangePeriod(this.period);
  
  @override
  List<Object> get props => [period];
}

// États
abstract class FinanceState extends Equatable {
  const FinanceState();
  
  @override
  List<Object?> get props => [];
}

class FinanceInitial extends FinanceState {
  const FinanceInitial();
}

class FinanceLoading extends FinanceState {
  const FinanceLoading();
}

class TransactionsLoaded extends FinanceState {
  final List<Transaction> transactions;
  final TransactionType? typeFilter;
  final TransactionCategory? categoryFilter;
  final DateTime? startDateFilter;
  final DateTime? endDateFilter;
  final String? accountIdFilter;
  final String? searchQueryFilter;
  
  const TransactionsLoaded({
    required this.transactions,
    this.typeFilter,
    this.categoryFilter,
    this.startDateFilter,
    this.endDateFilter,
    this.accountIdFilter,
    this.searchQueryFilter,
  });
  
  @override
  List<Object?> get props => [
    transactions, 
    typeFilter, 
    categoryFilter, 
    startDateFilter, 
    endDateFilter, 
    accountIdFilter,
    searchQueryFilter,
  ];
  
  TransactionsLoaded copyWith({
    List<Transaction>? transactions,
    TransactionType? typeFilter,
    TransactionCategory? categoryFilter,
    DateTime? startDateFilter,
    DateTime? endDateFilter,
    String? accountIdFilter,
    String? searchQueryFilter,
    bool clearTypeFilter = false,
    bool clearCategoryFilter = false,
    bool clearStartDateFilter = false,
    bool clearEndDateFilter = false,
    bool clearAccountIdFilter = false,
    bool clearSearchQueryFilter = false,
  }) {
    return TransactionsLoaded(
      transactions: transactions ?? this.transactions,
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
      categoryFilter: clearCategoryFilter ? null : (categoryFilter ?? this.categoryFilter),
      startDateFilter: clearStartDateFilter ? null : (startDateFilter ?? this.startDateFilter),
      endDateFilter: clearEndDateFilter ? null : (endDateFilter ?? this.endDateFilter),
      accountIdFilter: clearAccountIdFilter ? null : (accountIdFilter ?? this.accountIdFilter),
      searchQueryFilter: clearSearchQueryFilter ? null : (searchQueryFilter ?? this.searchQueryFilter),
    );
  }
}

class AccountsLoaded extends FinanceState {
  final List<Account> accounts;
  
  const AccountsLoaded(this.accounts);
  
  @override
  List<Object> get props => [accounts];
}

class FinancialSummaryLoaded extends FinanceState {
  final FinancialSummary summary;
  
  const FinancialSummaryLoaded(this.summary);
  
  @override
  List<Object> get props => [summary];
}

class FinancialTrendsLoaded extends FinanceState {
  final List<FinancialSummary> trends;
  final FinancialPeriod period;
  
  const FinancialTrendsLoaded({
    required this.trends,
    required this.period,
  });
  
  @override
  List<Object> get props => [trends, period];
}

class FinanceError extends FinanceState {
  final String message;
  
  const FinanceError(this.message);
  
  @override
  List<Object> get props => [message];
}

// Bloc
class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final FinanceRepository repository;
  
  FinanceBloc({required this.repository}) : super(const FinanceInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<FilterTransactions>(_onFilterTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<LoadAccounts>(_onLoadAccounts);
    on<AddAccount>(_onAddAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<LoadFinancialSummary>(_onLoadFinancialSummary);
    on<LoadFinancialTrends>(_onLoadFinancialTrends);
    on<ChangePeriod>(_onChangePeriod);
  }
  
  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<FinanceState> emit,
  ) async {
    emit(const FinanceLoading());
    
    try {
      final transactions = await repository.getTransactions();
      emit(TransactionsLoaded(transactions: transactions));
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
  
  Future<void> _onFilterTransactions(
    FilterTransactions event,
    Emitter<FinanceState> emit,
  ) async {
    emit(const FinanceLoading());
    
    try {
      final transactions = await repository.getFilteredTransactions(
        type: event.type,
        category: event.category,
        startDate: event.startDate,
        endDate: event.endDate,
        accountId: event.accountId,
        searchQuery: event.searchQuery,
      );
      
      emit(TransactionsLoaded(
        transactions: transactions,
        typeFilter: event.type,
        categoryFilter: event.category,
        startDateFilter: event.startDate,
        endDateFilter: event.endDate,
        accountIdFilter: event.accountId,
        searchQueryFilter: event.searchQuery,
      ));
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
  
  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await repository.addTransaction(event.transaction);
      
      // Recharger les transactions
      final currentState = state;
      if (currentState is TransactionsLoaded) {
        add(FilterTransactions(
          type: currentState.typeFilter,
          category: currentState.categoryFilter,
          startDate: currentState.startDateFilter,
          endDate: currentState.endDateFilter,
          accountId: currentState.accountIdFilter,
          searchQuery: currentState.searchQueryFilter,
        ));
      } else {
        add(const LoadTransactions());
      }
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
  
  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await repository.updateTransaction(event.transaction);
      
      // Recharger les transactions
      final currentState = state;
      if (currentState is TransactionsLoaded) {
        add(FilterTransactions(
          type: currentState.typeFilter,
          category: currentState.categoryFilter,
          startDate: currentState.startDateFilter,
          endDate: currentState.endDateFilter,
          accountId: currentState.accountIdFilter,
          searchQuery: currentState.searchQueryFilter,
        ));
      } else {
        add(const LoadTransactions());
      }
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
  
  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await repository.deleteTransaction(event.id);
      
      // Recharger les transactions
      final currentState = state;
      if (currentState is TransactionsLoaded) {
        add(FilterTransactions(
          type: currentState.typeFilter,
          category: currentState.categoryFilter,
          startDate: currentState.startDateFilter,
          endDate: currentState.endDateFilter,
          accountId: currentState.accountIdFilter,
          searchQuery: currentState.searchQueryFilter,
        ));
      } else {
        add(const LoadTransactions());
      }
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
  
  Future<void> _onLoadAccounts(
    LoadAccounts event,
    Emitter<FinanceState> emit,
  ) async {
    emit(const FinanceLoading());
    
    try {
      final accounts = await repository.getAccounts();
      emit(AccountsLoaded(accounts));
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
  
  Future<void> _onAddAccount(
    AddAccount event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await repository.addAccount(event.account);
      add(const LoadAccounts());
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
  
  Future<void> _onUpdateAccount(
    UpdateAccount event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await repository.updateAccount(event.account);
      add(const LoadAccounts());
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
  
  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await repository.deleteAccount(event.id);
      add(const LoadAccounts());
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
  
  Future<void> _onLoadFinancialSummary(
    LoadFinancialSummary event,
    Emitter<FinanceState> emit,
  ) async {
    emit(const FinanceLoading());
    
    try {
      final summary = await repository.getFinancialSummary(
        startDate: event.startDate,
        endDate: event.endDate,
        budgetAmount: event.budgetAmount,
      );
      
      emit(FinancialSummaryLoaded(summary));
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
  
  Future<void> _onLoadFinancialTrends(
    LoadFinancialTrends event,
    Emitter<FinanceState> emit,
  ) async {
    emit(const FinanceLoading());
    
    try {
      final trends = await repository.getFinancialTrends(
        period: event.period,
        count: event.count,
        endDate: event.endDate,
      );
      
      emit(FinancialTrendsLoaded(
        trends: trends,
        period: event.period,
      ));
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
  
  Future<void> _onChangePeriod(
    ChangePeriod event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      final dateRange = event.period.getDateRange();
      
      add(LoadFinancialSummary(
        startDate: dateRange.$1,
        endDate: dateRange.$2,
      ));
      
      add(LoadFinancialTrends(
        period: event.period,
        count: 6, // 6 périodes précédentes
      ));
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }
}
