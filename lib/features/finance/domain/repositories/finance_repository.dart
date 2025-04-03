import '../entities/account.dart';
import '../entities/transaction.dart';

/// Finance repository interface
abstract class FinanceRepository {
  /// Get all transactions
  Future<List<Transaction>> getTransactions();
  
  /// Get transaction by ID
  Future<Transaction?> getTransactionById(String id);
  
  /// Get transactions by date range
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end);
  
  /// Get transactions by type (income, expense, transfer)
  Future<List<Transaction>> getTransactionsByType(TransactionType type);
  
  /// Get transactions by category
  Future<List<Transaction>> getTransactionsByCategory(String categoryId);
  
  /// Get transactions by account
  Future<List<Transaction>> getTransactionsByAccount(String accountId);
  
  /// Add a new transaction
  Future<Transaction> addTransaction(Transaction transaction);
  
  /// Update transaction
  Future<Transaction> updateTransaction(Transaction transaction);
  
  /// Delete transaction
  Future<bool> deleteTransaction(String id);
  
  /// Get all accounts
  Future<List<Account>> getAccounts();
  
  /// Get account by ID
  Future<Account?> getAccountById(String id);
  
  /// Add a new account
  Future<Account> addAccount(Account account);
  
  /// Update account
  Future<Account> updateAccount(Account account);
  
  /// Delete account
  Future<bool> deleteAccount(String id);
  
  /// Get all categories
  Future<List<TransactionCategory>> getCategories();
  
  /// Get category by ID
  Future<TransactionCategory?> getCategoryById(String id);
  
  /// Add a new category
  Future<TransactionCategory> addCategory(TransactionCategory category);
  
  /// Update category
  Future<TransactionCategory> updateCategory(TransactionCategory category);
  
  /// Delete category
  Future<bool> deleteCategory(String id);
  
  /// Get total income for a date range
  Future<double> getTotalIncome(DateTime start, DateTime end);
  
  /// Get total expenses for a date range
  Future<double> getTotalExpenses(DateTime start, DateTime end);
  
  /// Get balance by date
  Future<double> getBalanceByDate(DateTime date);
  
  /// Get expenses by category for a date range
  Future<Map<String, double>> getExpensesByCategory(DateTime start, DateTime end);
}