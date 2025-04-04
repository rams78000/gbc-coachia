import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/finance_repository.dart';

/// Événements pour le bloc finance
abstract class FinanceEvent extends Equatable {
  /// Constructeur
  const FinanceEvent();

  @override
  List<Object> get props => [];
}

/// Événement pour charger les transactions
class LoadTransactions extends FinanceEvent {
  /// Constructeur
  const LoadTransactions();
}

/// Événement pour charger les statistiques
class LoadStats extends FinanceEvent {
  /// Période pour les statistiques
  final Period period;

  /// Constructeur
  const LoadStats({required this.period});

  @override
  List<Object> get props => [period];
}

/// Événement pour ajouter une transaction
class AddTransaction extends FinanceEvent {
  /// Transaction à ajouter
  final Transaction transaction;

  /// Constructeur
  const AddTransaction({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

/// Événement pour mettre à jour une transaction
class UpdateTransaction extends FinanceEvent {
  /// Transaction à mettre à jour
  final Transaction transaction;

  /// Constructeur
  const UpdateTransaction({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

/// Événement pour supprimer une transaction
class DeleteTransaction extends FinanceEvent {
  /// ID de la transaction à supprimer
  final String id;

  /// Constructeur
  const DeleteTransaction({required this.id});

  @override
  List<Object> get props => [id];
}

/// États pour le bloc finance
abstract class FinanceState extends Equatable {
  /// Constructeur
  const FinanceState();

  @override
  List<Object> get props => [];
}

/// État initial
class FinanceInitial extends FinanceState {}

/// État de chargement
class FinanceLoading extends FinanceState {}

/// État lorsque les transactions sont chargées
class TransactionsLoaded extends FinanceState {
  /// Liste des transactions
  final List<Transaction> transactions;

  /// Solde actuel
  final double currentBalance;

  /// Constructeur
  const TransactionsLoaded({
    required this.transactions,
    required this.currentBalance,
  });

  @override
  List<Object> get props => [transactions, currentBalance];
}

/// État lorsque les statistiques sont chargées
class StatsLoaded extends FinanceState {
  /// Statistiques financières
  final FinanceStats stats;

  /// Période des statistiques
  final Period period;

  /// Constructeur
  const StatsLoaded({
    required this.stats,
    required this.period,
  });

  @override
  List<Object> get props => [stats, period];
}

/// État d'erreur
class FinanceError extends FinanceState {
  /// Message d'erreur
  final String message;

  /// Constructeur
  const FinanceError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Bloc pour la gestion des finances
class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final FinanceRepository _financeRepository;

  /// Constructeur
  FinanceBloc({required FinanceRepository financeRepository})
      : _financeRepository = financeRepository,
        super(FinanceInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<LoadStats>(_onLoadStats);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    try {
      final transactions = await _financeRepository.getTransactions();
      final currentBalance = await _financeRepository.getCurrentBalance();
      emit(TransactionsLoaded(
        transactions: transactions,
        currentBalance: currentBalance,
      ));
    } catch (e) {
      emit(FinanceError(message: e.toString()));
    }
  }

  Future<void> _onLoadStats(
    LoadStats event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    try {
      final stats = await _financeRepository.getStats(event.period);
      emit(StatsLoaded(stats: stats, period: event.period));
    } catch (e) {
      emit(FinanceError(message: e.toString()));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    try {
      await _financeRepository.addTransaction(event.transaction);
      final transactions = await _financeRepository.getTransactions();
      final currentBalance = await _financeRepository.getCurrentBalance();
      emit(TransactionsLoaded(
        transactions: transactions,
        currentBalance: currentBalance,
      ));
    } catch (e) {
      emit(FinanceError(message: e.toString()));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    try {
      await _financeRepository.updateTransaction(event.transaction);
      final transactions = await _financeRepository.getTransactions();
      final currentBalance = await _financeRepository.getCurrentBalance();
      emit(TransactionsLoaded(
        transactions: transactions,
        currentBalance: currentBalance,
      ));
    } catch (e) {
      emit(FinanceError(message: e.toString()));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    try {
      await _financeRepository.deleteTransaction(event.id);
      final transactions = await _financeRepository.getTransactions();
      final currentBalance = await _financeRepository.getCurrentBalance();
      emit(TransactionsLoaded(
        transactions: transactions,
        currentBalance: currentBalance,
      ));
    } catch (e) {
      emit(FinanceError(message: e.toString()));
    }
  }
}
