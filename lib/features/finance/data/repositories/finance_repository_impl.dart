import 'package:uuid/uuid.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finance_repository.dart';

/// Implementation of FinanceRepository
class FinanceRepositoryImpl implements FinanceRepository {
  /// In-memory transactions for testing, will be replaced with API or local storage
  final List<Transaction> _transactions = [];
  
  /// In-memory accounts for testing, will be replaced with API or local storage
  final List<Account> _accounts = [];
  
  /// In-memory categories for testing, will be replaced with API or local storage
  final List<TransactionCategory> _categories = [];
  
  /// Uuid generator
  final Uuid _uuid = const Uuid();

  @override
  Future<List<Transaction>> getTransactions() async {
    // TODO: Implement with API or local storage
    return _transactions;
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    // TODO: Implement with API or local storage
    return _transactions.firstWhere(
      (transaction) => transaction.id == id,
      orElse: () => throw Exception('Transaction not found'),
    );
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    // TODO: Implement with API or local storage
    return _transactions.where((transaction) {
      return transaction.date.isAfter(start) && transaction.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    // TODO: Implement with API or local storage
    return _transactions.where((transaction) => transaction.type == type).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByCategory(String categoryId) async {
    // TODO: Implement with API or local storage
    return _transactions.where((transaction) => transaction.category.id == categoryId).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByAccount(String accountId) async {
    // TODO: Implement with API or local storage
    return _transactions.where((transaction) => transaction.accountId == accountId).toList();
  }

  @override
  Future<Transaction> addTransaction(Transaction transaction) async {
    // TODO: Implement with API or local storage
    final newTransaction = transaction.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _transactions.add(newTransaction);
    
    // Update account balance
    final accountIndex = _accounts.indexWhere((account) => account.id == newTransaction.accountId);
    if (accountIndex != -1) {
      final account = _accounts[accountIndex];
      double newBalance = account.balance;
      
      switch (newTransaction.type) {
        case TransactionType.income:
          newBalance += newTransaction.amount;
          break;
        case TransactionType.expense:
          newBalance -= newTransaction.amount;
          break;
        case TransactionType.transfer:
          newBalance -= newTransaction.amount;
          
          // Update destination account
          if (newTransaction.destinationAccountId != null) {
            final destAccountIndex = _accounts.indexWhere(
              (account) => account.id == newTransaction.destinationAccountId,
            );
            
            if (destAccountIndex != -1) {
              final destAccount = _accounts[destAccountIndex];
              _accounts[destAccountIndex] = destAccount.copyWith(
                balance: destAccount.balance + newTransaction.amount,
                updatedAt: DateTime.now(),
              );
            }
          }
          break;
      }
      
      _accounts[accountIndex] = account.copyWith(
        balance: newBalance,
        updatedAt: DateTime.now(),
      );
    }
    
    return newTransaction;
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    // TODO: Implement with API or local storage
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    
    if (index != -1) {
      final oldTransaction = _transactions[index];
      
      // Revert old transaction effect on accounts
      if (oldTransaction.accountId == transaction.accountId) {
        final accountIndex = _accounts.indexWhere((account) => account.id == oldTransaction.accountId);
        if (accountIndex != -1) {
          final account = _accounts[accountIndex];
          double newBalance = account.balance;
          
          switch (oldTransaction.type) {
            case TransactionType.income:
              newBalance -= oldTransaction.amount;
              break;
            case TransactionType.expense:
              newBalance += oldTransaction.amount;
              break;
            case TransactionType.transfer:
              newBalance += oldTransaction.amount;
              
              // Revert destination account
              if (oldTransaction.destinationAccountId != null) {
                final destAccountIndex = _accounts.indexWhere(
                  (account) => account.id == oldTransaction.destinationAccountId,
                );
                
                if (destAccountIndex != -1) {
                  final destAccount = _accounts[destAccountIndex];
                  _accounts[destAccountIndex] = destAccount.copyWith(
                    balance: destAccount.balance - oldTransaction.amount,
                    updatedAt: DateTime.now(),
                  );
                }
              }
              break;
          }
          
          _accounts[accountIndex] = account.copyWith(
            balance: newBalance,
            updatedAt: DateTime.now(),
          );
        }
      }
      
      // Apply new transaction effect on accounts
      final accountIndex = _accounts.indexWhere((account) => account.id == transaction.accountId);
      if (accountIndex != -1) {
        final account = _accounts[accountIndex];
        double newBalance = account.balance;
        
        switch (transaction.type) {
          case TransactionType.income:
            newBalance += transaction.amount;
            break;
          case TransactionType.expense:
            newBalance -= transaction.amount;
            break;
          case TransactionType.transfer:
            newBalance -= transaction.amount;
            
            // Update destination account
            if (transaction.destinationAccountId != null) {
              final destAccountIndex = _accounts.indexWhere(
                (account) => account.id == transaction.destinationAccountId,
              );
              
              if (destAccountIndex != -1) {
                final destAccount = _accounts[destAccountIndex];
                _accounts[destAccountIndex] = destAccount.copyWith(
                  balance: destAccount.balance + transaction.amount,
                  updatedAt: DateTime.now(),
                );
              }
            }
            break;
        }
        
        _accounts[accountIndex] = account.copyWith(
          balance: newBalance,
          updatedAt: DateTime.now(),
        );
      }
      
      final updatedTransaction = transaction.copyWith(
        updatedAt: DateTime.now(),
      );
      
      _transactions[index] = updatedTransaction;
      return updatedTransaction;
    } else {
      throw Exception('Transaction not found');
    }
  }

  @override
  Future<bool> deleteTransaction(String id) async {
    // TODO: Implement with API or local storage
    final index = _transactions.indexWhere((transaction) => transaction.id == id);
    
    if (index != -1) {
      final transaction = _transactions[index];
      
      // Revert transaction effect on accounts
      final accountIndex = _accounts.indexWhere((account) => account.id == transaction.accountId);
      if (accountIndex != -1) {
        final account = _accounts[accountIndex];
        double newBalance = account.balance;
        
        switch (transaction.type) {
          case TransactionType.income:
            newBalance -= transaction.amount;
            break;
          case TransactionType.expense:
            newBalance += transaction.amount;
            break;
          case TransactionType.transfer:
            newBalance += transaction.amount;
            
            // Revert destination account
            if (transaction.destinationAccountId != null) {
              final destAccountIndex = _accounts.indexWhere(
                (account) => account.id == transaction.destinationAccountId,
              );
              
              if (destAccountIndex != -1) {
                final destAccount = _accounts[destAccountIndex];
                _accounts[destAccountIndex] = destAccount.copyWith(
                  balance: destAccount.balance - transaction.amount,
                  updatedAt: DateTime.now(),
                );
              }
            }
            break;
        }
        
        _accounts[accountIndex] = account.copyWith(
          balance: newBalance,
          updatedAt: DateTime.now(),
        );
      }
      
      _transactions.removeAt(index);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<Account>> getAccounts() async {
    // TODO: Implement with API or local storage
    return _accounts;
  }

  @override
  Future<Account?> getAccountById(String id) async {
    // TODO: Implement with API or local storage
    return _accounts.firstWhere(
      (account) => account.id == id,
      orElse: () => throw Exception('Account not found'),
    );
  }

  @override
  Future<Account> addAccount(Account account) async {
    // TODO: Implement with API or local storage
    final newAccount = account.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _accounts.add(newAccount);
    return newAccount;
  }

  @override
  Future<Account> updateAccount(Account account) async {
    // TODO: Implement with API or local storage
    final index = _accounts.indexWhere((a) => a.id == account.id);
    
    if (index != -1) {
      final updatedAccount = account.copyWith(
        updatedAt: DateTime.now(),
      );
      
      _accounts[index] = updatedAccount;
      return updatedAccount;
    } else {
      throw Exception('Account not found');
    }
  }

  @override
  Future<bool> deleteAccount(String id) async {
    // TODO: Implement with API or local storage
    // Check if there are transactions for this account
    final hasTransactions = _transactions.any(
      (transaction) => transaction.accountId == id || transaction.destinationAccountId == id,
    );
    
    if (hasTransactions) {
      throw Exception('Cannot delete account with transactions');
    }
    
    final index = _accounts.indexWhere((account) => account.id == id);
    
    if (index != -1) {
      _accounts.removeAt(index);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<TransactionCategory>> getCategories() async {
    // TODO: Implement with API or local storage
    return _categories;
  }

  @override
  Future<TransactionCategory?> getCategoryById(String id) async {
    // TODO: Implement with API or local storage
    return _categories.firstWhere(
      (category) => category.id == id,
      orElse: () => throw Exception('Category not found'),
    );
  }

  @override
  Future<TransactionCategory> addCategory(TransactionCategory category) async {
    // TODO: Implement with API or local storage
    final newCategory = TransactionCategory(
      id: _uuid.v4(),
      name: category.name,
      icon: category.icon,
      color: category.color,
      isIncome: category.isIncome,
    );
    
    _categories.add(newCategory);
    return newCategory;
  }

  @override
  Future<TransactionCategory> updateCategory(TransactionCategory category) async {
    // TODO: Implement with API or local storage
    final index = _categories.indexWhere((c) => c.id == category.id);
    
    if (index != -1) {
      _categories[index] = category;
      return category;
    } else {
      throw Exception('Category not found');
    }
  }

  @override
  Future<bool> deleteCategory(String id) async {
    // TODO: Implement with API or local storage
    // Check if there are transactions for this category
    final hasTransactions = _transactions.any(
      (transaction) => transaction.category.id == id,
    );
    
    if (hasTransactions) {
      throw Exception('Cannot delete category with transactions');
    }
    
    final index = _categories.indexWhere((category) => category.id == id);
    
    if (index != -1) {
      _categories.removeAt(index);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<double> getTotalIncome(DateTime start, DateTime end) async {
    // TODO: Implement with API or local storage
    return _transactions
        .where((transaction) => 
            transaction.type == TransactionType.income &&
            transaction.date.isAfter(start) && 
            transaction.date.isBefore(end.add(const Duration(days: 1))))
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Future<double> getTotalExpenses(DateTime start, DateTime end) async {
    // TODO: Implement with API or local storage
    return _transactions
        .where((transaction) => 
            transaction.type == TransactionType.expense &&
            transaction.date.isAfter(start) && 
            transaction.date.isBefore(end.add(const Duration(days: 1))))
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Future<double> getBalanceByDate(DateTime date) async {
    // TODO: Implement with API or local storage
    return _accounts
        .where((account) => account.includeInTotal)
        .fold(0, (sum, account) => sum + account.balance);
  }

  @override
  Future<Map<String, double>> getExpensesByCategory(DateTime start, DateTime end) async {
    // TODO: Implement with API or local storage
    final expensesByCategory = <String, double>{};
    
    final expenses = _transactions
        .where((transaction) => 
            transaction.type == TransactionType.expense &&
            transaction.date.isAfter(start) && 
            transaction.date.isBefore(end.add(const Duration(days: 1))));
    
    for (final transaction in expenses) {
      final categoryId = transaction.category.id;
      expensesByCategory[categoryId] = (expensesByCategory[categoryId] ?? 0) + transaction.amount;
    }
    
    return expensesByCategory;
  }
}