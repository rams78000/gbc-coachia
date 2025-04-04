import 'package:gbc_coachai/features/finance/domain/entities/transaction.dart';

abstract class TransactionRepository {
  /// Récupère toutes les transactions
  Future<List<Transaction>> getTransactions();
  
  /// Récupère une transaction par son ID
  Future<Transaction?> getTransactionById(String id);
  
  /// Ajoute une nouvelle transaction
  Future<void> addTransaction(Transaction transaction);
  
  /// Met à jour une transaction existante
  Future<void> updateTransaction(Transaction transaction);
  
  /// Supprime une transaction
  Future<void> deleteTransaction(String id);
  
  /// Récupère les transactions d'un certain type (revenus ou dépenses)
  Future<List<Transaction>> getTransactionsByType(TransactionType type);
  
  /// Récupère les transactions d'une certaine catégorie
  Future<List<Transaction>> getTransactionsByCategory(TransactionCategory category);
  
  /// Récupère les transactions pour une période donnée
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end);
  
  /// Calcule le total des revenus
  Future<double> getTotalIncome([DateTime? startDate, DateTime? endDate]);
  
  /// Calcule le total des dépenses
  Future<double> getTotalExpenses([DateTime? startDate, DateTime? endDate]);
  
  /// Calcule le solde (revenus - dépenses)
  Future<double> getBalance([DateTime? startDate, DateTime? endDate]);
}
