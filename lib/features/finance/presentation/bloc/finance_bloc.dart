import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finance_repository.dart';
import 'finance_event.dart';
import 'finance_state.dart';

/// BLoC to handle finance functionality
class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  /// Finance repository
  final FinanceRepository? financeRepository;

  /// Constructor
  FinanceBloc({this.financeRepository}) : super(FinanceInitial()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<LoadTransactionsByDateRangeEvent>(_onLoadTransactionsByDateRange);
    on<LoadTransactionsByTypeEvent>(_onLoadTransactionsByType);
    on<LoadTransactionsByCategoryEvent>(_onLoadTransactionsByCategory);
    on<LoadTransactionsByAccountEvent>(_onLoadTransactionsByAccount);
    on<AddTransactionEvent>(_onAddTransaction);
    on<UpdateTransactionEvent>(_onUpdateTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    
    on<LoadAccountsEvent>(_onLoadAccounts);
    on<AddAccountEvent>(_onAddAccount);
    on<UpdateAccountEvent>(_onUpdateAccount);
    on<DeleteAccountEvent>(_onDeleteAccount);
    
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    
    on<LoadFinancialSummaryEvent>(_onLoadFinancialSummary);
  }

  /// Handle loading all transactions
  Future<void> _onLoadTransactions(
    LoadTransactionsEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    
    try {
      // TODO: Replace with actual repository implementation
      final transactions = await Future.delayed(
        const Duration(milliseconds: 500),
        () => <Transaction>[],
      );
      
      if (state is FinanceLoaded) {
        final currentState = state as FinanceLoaded;
        emit(currentState.copyWith(transactions: transactions));
      } else {
        emit(FinanceLoaded(
          transactions: transactions,
          accounts: [],
          categories: [],
        ));
      }
    } catch (e) {
      emit(FinanceError(message: 'Failed to load transactions'));
    }
  }

  /// Handle loading transactions by date range
  Future<void> _onLoadTransactionsByDateRange(
    LoadTransactionsByDateRangeEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceLoading());
      
      try {
        // TODO: Replace with actual repository implementation
        final transactions = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <Transaction>[],
        );
        
        emit(currentState.copyWith(
          transactions: transactions,
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      } catch (e) {
        emit(FinanceError(message: 'Failed to load transactions by date range'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle loading transactions by type
  Future<void> _onLoadTransactionsByType(
    LoadTransactionsByTypeEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceLoading());
      
      try {
        // TODO: Replace with actual repository implementation
        final transactions = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <Transaction>[],
        );
        
        emit(currentState.copyWith(
          transactions: transactions,
          transactionType: event.type,
        ));
      } catch (e) {
        emit(FinanceError(message: 'Failed to load transactions by type'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle loading transactions by category
  Future<void> _onLoadTransactionsByCategory(
    LoadTransactionsByCategoryEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceLoading());
      
      try {
        // TODO: Replace with actual repository implementation
        final transactions = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <Transaction>[],
        );
        
        emit(currentState.copyWith(
          transactions: transactions,
          categoryId: event.categoryId,
        ));
      } catch (e) {
        emit(FinanceError(message: 'Failed to load transactions by category'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle loading transactions by account
  Future<void> _onLoadTransactionsByAccount(
    LoadTransactionsByAccountEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceLoading());
      
      try {
        // TODO: Replace with actual repository implementation
        final transactions = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <Transaction>[],
        );
        
        emit(currentState.copyWith(
          transactions: transactions,
          accountId: event.accountId,
        ));
      } catch (e) {
        emit(FinanceError(message: 'Failed to load transactions by account'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle adding a transaction
  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final newTransaction = await Future.delayed(
          const Duration(milliseconds: 500),
          () => event.transaction,
        );
        
        final updatedTransactions = List.of(currentState.transactions)
          ..add(newTransaction);
        emit(currentState.copyWith(transactions: updatedTransactions));
      } catch (e) {
        emit(FinanceError(message: 'Failed to add transaction'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle updating a transaction
  Future<void> _onUpdateTransaction(
    UpdateTransactionEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final updatedTransaction = await Future.delayed(
          const Duration(milliseconds: 500),
          () => event.transaction,
        );
        
        final transactionIndex = currentState.transactions.indexWhere(
          (transaction) => transaction.id == updatedTransaction.id,
        );
        
        if (transactionIndex != -1) {
          final updatedTransactions = List.of(currentState.transactions);
          updatedTransactions[transactionIndex] = updatedTransaction;
          emit(currentState.copyWith(transactions: updatedTransactions));
        } else {
          emit(FinanceError(message: 'Transaction not found'));
          emit(currentState); // Revert to previous state
        }
      } catch (e) {
        emit(FinanceError(message: 'Failed to update transaction'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle deleting a transaction
  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final success = await Future.delayed(
          const Duration(milliseconds: 500),
          () => true,
        );
        
        if (success) {
          final updatedTransactions = currentState.transactions
              .where((transaction) => transaction.id != event.transactionId)
              .toList();
          emit(currentState.copyWith(transactions: updatedTransactions));
        } else {
          emit(FinanceError(message: 'Failed to delete transaction'));
          emit(currentState); // Revert to previous state
        }
      } catch (e) {
        emit(FinanceError(message: 'Failed to delete transaction'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle loading all accounts
  Future<void> _onLoadAccounts(
    LoadAccountsEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      
      try {
        // TODO: Replace with actual repository implementation
        final accounts = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <Account>[],
        );
        
        emit(currentState.copyWith(accounts: accounts));
      } catch (e) {
        emit(FinanceError(message: 'Failed to load accounts'));
        emit(currentState); // Revert to previous state
      }
    } else {
      emit(FinanceLoading());
      
      try {
        // TODO: Replace with actual repository implementation
        final accounts = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <Account>[],
        );
        
        emit(FinanceLoaded(
          transactions: [],
          accounts: accounts,
          categories: [],
        ));
      } catch (e) {
        emit(FinanceError(message: 'Failed to load accounts'));
      }
    }
  }

  /// Handle adding an account
  Future<void> _onAddAccount(
    AddAccountEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final newAccount = await Future.delayed(
          const Duration(milliseconds: 500),
          () => event.account,
        );
        
        final updatedAccounts = List.of(currentState.accounts)..add(newAccount);
        emit(currentState.copyWith(accounts: updatedAccounts));
      } catch (e) {
        emit(FinanceError(message: 'Failed to add account'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle updating an account
  Future<void> _onUpdateAccount(
    UpdateAccountEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final updatedAccount = await Future.delayed(
          const Duration(milliseconds: 500),
          () => event.account,
        );
        
        final accountIndex = currentState.accounts.indexWhere(
          (account) => account.id == updatedAccount.id,
        );
        
        if (accountIndex != -1) {
          final updatedAccounts = List.of(currentState.accounts);
          updatedAccounts[accountIndex] = updatedAccount;
          emit(currentState.copyWith(accounts: updatedAccounts));
        } else {
          emit(FinanceError(message: 'Account not found'));
          emit(currentState); // Revert to previous state
        }
      } catch (e) {
        emit(FinanceError(message: 'Failed to update account'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle deleting an account
  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final success = await Future.delayed(
          const Duration(milliseconds: 500),
          () => true,
        );
        
        if (success) {
          final updatedAccounts = currentState.accounts
              .where((account) => account.id != event.accountId)
              .toList();
          emit(currentState.copyWith(accounts: updatedAccounts));
        } else {
          emit(FinanceError(message: 'Failed to delete account'));
          emit(currentState); // Revert to previous state
        }
      } catch (e) {
        emit(FinanceError(message: 'Failed to delete account'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle loading all categories
  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      
      try {
        // TODO: Replace with actual repository implementation
        final categories = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <TransactionCategory>[],
        );
        
        emit(currentState.copyWith(categories: categories));
      } catch (e) {
        emit(FinanceError(message: 'Failed to load categories'));
        emit(currentState); // Revert to previous state
      }
    } else {
      emit(FinanceLoading());
      
      try {
        // TODO: Replace with actual repository implementation
        final categories = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <TransactionCategory>[],
        );
        
        emit(FinanceLoaded(
          transactions: [],
          accounts: [],
          categories: categories,
        ));
      } catch (e) {
        emit(FinanceError(message: 'Failed to load categories'));
      }
    }
  }

  /// Handle adding a category
  Future<void> _onAddCategory(
    AddCategoryEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final newCategory = await Future.delayed(
          const Duration(milliseconds: 500),
          () => event.category,
        );
        
        final updatedCategories = List.of(currentState.categories)..add(newCategory);
        emit(currentState.copyWith(categories: updatedCategories));
      } catch (e) {
        emit(FinanceError(message: 'Failed to add category'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle updating a category
  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final updatedCategory = await Future.delayed(
          const Duration(milliseconds: 500),
          () => event.category,
        );
        
        final categoryIndex = currentState.categories.indexWhere(
          (category) => category.id == updatedCategory.id,
        );
        
        if (categoryIndex != -1) {
          final updatedCategories = List.of(currentState.categories);
          updatedCategories[categoryIndex] = updatedCategory;
          emit(currentState.copyWith(categories: updatedCategories));
        } else {
          emit(FinanceError(message: 'Category not found'));
          emit(currentState); // Revert to previous state
        }
      } catch (e) {
        emit(FinanceError(message: 'Failed to update category'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle deleting a category
  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(FinanceOperationInProgress());
      
      try {
        // TODO: Replace with actual repository implementation
        final success = await Future.delayed(
          const Duration(milliseconds: 500),
          () => true,
        );
        
        if (success) {
          final updatedCategories = currentState.categories
              .where((category) => category.id != event.categoryId)
              .toList();
          emit(currentState.copyWith(categories: updatedCategories));
        } else {
          emit(FinanceError(message: 'Failed to delete category'));
          emit(currentState); // Revert to previous state
        }
      } catch (e) {
        emit(FinanceError(message: 'Failed to delete category'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle loading financial summary
  Future<void> _onLoadFinancialSummary(
    LoadFinancialSummaryEvent event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      
      try {
        // TODO: Replace with actual repository implementation
        final totalIncome = await Future.delayed(
          const Duration(milliseconds: 500),
          () => 0.0,
        );
        
        final totalExpenses = await Future.delayed(
          const Duration(milliseconds: 500),
          () => 0.0,
        );
        
        final expensesByCategory = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <String, double>{},
        );
        
        emit(currentState.copyWith(
          totalIncome: totalIncome,
          totalExpenses: totalExpenses,
          expensesByCategory: expensesByCategory,
        ));
      } catch (e) {
        emit(FinanceError(message: 'Failed to load financial summary'));
        emit(currentState); // Revert to previous state
      }
    }
  }
}
