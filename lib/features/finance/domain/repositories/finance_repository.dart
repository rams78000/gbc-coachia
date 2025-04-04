import '../entities/account.dart';
import '../entities/financial_summary.dart';
import '../entities/transaction.dart';

/// Interface du repository pour les finances
abstract class FinanceRepository {
  /// Récupère toutes les transactions
  Future<List<Transaction>> getTransactions();
  
  /// Récupère une transaction par son ID
  Future<Transaction?> getTransactionById(String id);
  
  /// Récupère les transactions filtrées par critères
  Future<List<Transaction>> getFilteredTransactions({
    TransactionType? type,
    TransactionCategory? category,
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
    String? searchQuery,
  });
  
  /// Ajoute une nouvelle transaction
  Future<Transaction> addTransaction(Transaction transaction);
  
  /// Met à jour une transaction existante
  Future<Transaction> updateTransaction(Transaction transaction);
  
  /// Supprime une transaction
  Future<bool> deleteTransaction(String id);
  
  /// Récupère tous les comptes
  Future<List<Account>> getAccounts();
  
  /// Récupère un compte par son ID
  Future<Account?> getAccountById(String id);
  
  /// Ajoute un nouveau compte
  Future<Account> addAccount(Account account);
  
  /// Met à jour un compte existant
  Future<Account> updateAccount(Account account);
  
  /// Supprime un compte
  Future<bool> deleteAccount(String id);
  
  /// Récupère un résumé financier pour une période donnée
  Future<FinancialSummary> getFinancialSummary({
    required DateTime startDate,
    required DateTime endDate,
    double? budgetAmount,
  });
  
  /// Récupère les tendances financières pour plusieurs périodes
  Future<List<FinancialSummary>> getFinancialTrends({
    required FinancialPeriod period,
    required int count,
    DateTime? endDate,
  });
}
