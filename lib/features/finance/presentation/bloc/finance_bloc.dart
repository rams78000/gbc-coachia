import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc_coachai/features/finance/domain/entities/transaction.dart';
import 'package:gbc_coachai/features/finance/domain/repositories/transaction_repository.dart';

part 'finance_event.dart';
part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final TransactionRepository repository;

  FinanceBloc({required this.repository}) : super(FinanceInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<LoadTransactionsByType>(_onLoadTransactionsByType);
    on<LoadTransactionsByDateRange>(_onLoadTransactionsByDateRange);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<CalculateFinancialSummary>(_onCalculateFinancialSummary);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<FinanceState> emit,
  ) async {
    emit(TransactionsLoading());
    try {
      final transactions = await repository.getTransactions();
      emit(TransactionsLoaded(transactions: transactions));
    } catch (e) {
      emit(TransactionsError(message: e.toString()));
    }
  }

  Future<void> _onLoadTransactionsByType(
    LoadTransactionsByType event,
    Emitter<FinanceState> emit,
  ) async {
    emit(TransactionsLoading());
    try {
      final transactions = await repository.getTransactionsByType(event.type);
      emit(TransactionsLoaded(
        transactions: transactions,
        filteredType: event.type,
      ));
    } catch (e) {
      emit(TransactionsError(message: e.toString()));
    }
  }

  Future<void> _onLoadTransactionsByDateRange(
    LoadTransactionsByDateRange event,
    Emitter<FinanceState> emit,
  ) async {
    emit(TransactionsLoading());
    try {
      final transactions = await repository.getTransactionsByDateRange(
        event.startDate,
        event.endDate,
      );
      emit(TransactionsLoaded(
        transactions: transactions,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e) {
      emit(TransactionsError(message: e.toString()));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await repository.addTransaction(event.transaction);
      // Recharger les transactions après l'ajout
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await repository.updateTransaction(event.transaction);
      // Recharger les transactions après la mise à jour
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionsError(message: e.toString()));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await repository.deleteTransaction(event.id);
      // Recharger les transactions après la suppression
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionsError(message: e.toString()));
    }
  }

  Future<void> _onCalculateFinancialSummary(
    CalculateFinancialSummary event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinancialSummaryLoading());
    try {
      final totalIncome = await repository.getTotalIncome(
        event.startDate,
        event.endDate,
      );
      final totalExpenses = await repository.getTotalExpenses(
        event.startDate,
        event.endDate,
      );
      final balance = await repository.getBalance(
        event.startDate,
        event.endDate,
      );
      
      emit(FinancialSummaryLoaded(
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        balance: balance,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e) {
      emit(FinancialSummaryError(message: e.toString()));
    }
  }
}
