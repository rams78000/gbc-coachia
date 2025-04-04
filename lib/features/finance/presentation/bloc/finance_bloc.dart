import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc_coachia/features/finance/domain/entities/transaction.dart';
import 'package:gbc_coachia/features/finance/domain/repositories/transaction_repository.dart';

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
    on<ChangePeriodView>(_onChangePeriodView);
    on<FilterTransactionsByCategory>(_onFilterTransactionsByCategory);
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
      
      // Récupérer les transactions pour regrouper par catégorie
      final transactions = await repository.getTransactionsByDateRange(
        event.startDate ?? DateTime.now().subtract(const Duration(days: 365)),
        event.endDate ?? DateTime.now(),
      );
      
      // Regrouper par catégorie
      final expensesByCategory = _groupTransactionsByCategory(
        transactions, 
        TransactionType.expense,
      );
      
      final incomesByCategory = _groupTransactionsByCategory(
        transactions, 
        TransactionType.income,
      );
      
      // Générer des résumés historiques si demandé
      List<FinancialSummary>? summaries;
      if (event.generateHistoricalData) {
        summaries = await _generateHistoricalSummaries(event.period);
      }
      
      emit(FinancialSummaryLoaded(
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        balance: balance,
        startDate: event.startDate,
        endDate: event.endDate,
        expensesByCategory: expensesByCategory,
        incomesByCategory: incomesByCategory,
        summaries: summaries,
        selectedPeriod: event.period,
      ));
    } catch (e) {
      emit(FinancialSummaryError(message: e.toString()));
    }
  }
  
  /// Groupe les transactions par catégorie pour un type donné
  Map<TransactionCategory, double> _groupTransactionsByCategory(
    List<Transaction> transactions,
    TransactionType type,
  ) {
    final Map<TransactionCategory, double> result = {};
    
    for (final transaction in transactions) {
      if (transaction.type == type) {
        final currentAmount = result[transaction.category] ?? 0.0;
        result[transaction.category] = currentAmount + transaction.amount;
      }
    }
    
    return result;
  }
  
  /// Génère des résumés financiers historiques pour la visualisation
  Future<List<FinancialSummary>> _generateHistoricalSummaries(FinancialPeriod period) async {
    final List<FinancialSummary> summaries = [];
    final now = DateTime.now();
    
    // Définir le nombre de périodes à générer
    int periodCount;
    switch (period) {
      case FinancialPeriod.daily:
        periodCount = 14; // 2 semaines
        break;
      case FinancialPeriod.weekly:
        periodCount = 12; // 12 semaines (~3 mois)
        break;
      case FinancialPeriod.monthly:
        periodCount = 12; // 12 mois (1 an)
        break;
      case FinancialPeriod.quarterly:
        periodCount = 8; // 8 trimestres (2 ans)
        break;
      case FinancialPeriod.yearly:
        periodCount = 5; // 5 ans
        break;
      default:
        periodCount = 12; // Par défaut, 12 périodes
    }
    
    // Générer chaque période
    for (int i = 0; i < periodCount; i++) {
      final DateTime periodEnd;
      final DateTime periodStart;
      
      switch (period) {
        case FinancialPeriod.daily:
          periodEnd = now.subtract(Duration(days: i));
          periodStart = DateTime(periodEnd.year, periodEnd.month, periodEnd.day);
          break;
        case FinancialPeriod.weekly:
          // Trouver la fin de la semaine (dimanche)
          final daysToEndOfWeek = 7 - now.weekday;
          final endOfCurrentWeek = now.add(Duration(days: daysToEndOfWeek));
          periodEnd = endOfCurrentWeek.subtract(Duration(days: i * 7));
          periodStart = periodEnd.subtract(const Duration(days: 6));
          break;
        case FinancialPeriod.monthly:
          periodEnd = DateTime(now.year, now.month - i, 0); // Dernier jour du mois
          periodStart = DateTime(periodEnd.year, periodEnd.month, 1); // Premier jour du mois
          break;
        case FinancialPeriod.quarterly:
          final currentQuarter = ((now.month - 1) ~/ 3);
          final quartersAgo = i;
          final targetYear = now.year - (currentQuarter + quartersAgo) ~/ 4;
          final targetQuarter = (currentQuarter - quartersAgo) % 4;
          final targetMonth = targetQuarter * 3 + 1; // Premier mois du trimestre
          periodStart = DateTime(targetYear, targetMonth, 1);
          periodEnd = DateTime(targetYear, targetMonth + 3, 0); // Dernier jour du trimestre
          break;
        case FinancialPeriod.yearly:
          periodStart = DateTime(now.year - i, 1, 1);
          periodEnd = DateTime(now.year - i, 12, 31);
          break;
        default:
          periodStart = DateTime(now.year, now.month - i, 1);
          periodEnd = DateTime(now.year, now.month - i + 1, 0);
      }
      
      // Récupérer les transactions de la période
      final transactions = await repository.getTransactionsByDateRange(
        periodStart,
        periodEnd,
      );
      
      // Créer le résumé financier pour la période
      final summary = FinancialSummary.fromTransactions(
        transactions: transactions,
        startDate: periodStart,
        endDate: periodEnd,
      );
      
      summaries.add(summary);
    }
    
    return summaries;
  }
  
  /// Gère le changement de période d'affichage
  Future<void> _onChangePeriodView(
    ChangePeriodView event,
    Emitter<FinanceState> emit,
  ) async {
    // Si l'état actuel est déjà un résumé financier chargé, mettre à jour la période
    if (state is FinancialSummaryLoaded) {
      final currentState = state as FinancialSummaryLoaded;
      
      // Générer de nouveaux résumés pour la période sélectionnée
      final summaries = await _generateHistoricalSummaries(event.period);
      
      emit(currentState.copyWith(
        selectedPeriod: event.period,
        summaries: summaries,
      ));
    } else {
      // Sinon, déclencher un calcul complet
      add(CalculateFinancialSummary(period: event.period));
    }
  }
  
  /// Filtre les transactions par catégorie
  Future<void> _onFilterTransactionsByCategory(
    FilterTransactionsByCategory event,
    Emitter<FinanceState> emit,
  ) async {
    emit(TransactionsLoading());
    try {
      final transactions = await repository.getTransactions();
      
      // Filtrer par catégorie et éventuellement par type
      final filteredTransactions = transactions.where((transaction) {
        final matchesCategory = transaction.category == event.category;
        final matchesType = event.type == null || transaction.type == event.type;
        return matchesCategory && matchesType;
      }).toList();
      
      emit(TransactionsLoaded(
        transactions: filteredTransactions,
        filteredType: event.type,
      ));
    } catch (e) {
      emit(TransactionsError(message: e.toString()));
    }
  }
}
