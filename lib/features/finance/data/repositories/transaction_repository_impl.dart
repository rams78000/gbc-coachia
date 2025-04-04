import 'package:gbc_coachai/features/finance/data/sources/transaction_local_source.dart';
import 'package:gbc_coachai/features/finance/domain/entities/transaction.dart';
import 'package:gbc_coachai/features/finance/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalSource localSource;

  TransactionRepositoryImpl({required this.localSource});

  @override
  Future<List<Transaction>> getTransactions() async {
    return await localSource.getTransactions();
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    return await localSource.getTransactionById(id);
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await localSource.addTransaction(transaction);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    await localSource.updateTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await localSource.deleteTransaction(id);
  }

  @override
  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    final transactions = await localSource.getTransactions();
    return transactions.where((transaction) => transaction.type == type).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByCategory(TransactionCategory category) async {
    final transactions = await localSource.getTransactions();
    return transactions.where((transaction) => transaction.category == category).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    final transactions = await localSource.getTransactions();
    return transactions.where((transaction) {
      return transaction.date.isAfter(start.subtract(const Duration(days: 1))) && 
             transaction.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Future<double> getTotalIncome([DateTime? startDate, DateTime? endDate]) async {
    List<Transaction> transactions;
    
    if (startDate != null && endDate != null) {
      transactions = await getTransactionsByDateRange(startDate, endDate);
    } else {
      transactions = await getTransactions();
    }
    
    final incomeTransactions = transactions.where(
      (transaction) => transaction.type == TransactionType.income
    );
    
    return incomeTransactions.fold(0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Future<double> getTotalExpenses([DateTime? startDate, DateTime? endDate]) async {
    List<Transaction> transactions;
    
    if (startDate != null && endDate != null) {
      transactions = await getTransactionsByDateRange(startDate, endDate);
    } else {
      transactions = await getTransactions();
    }
    
    final expenseTransactions = transactions.where(
      (transaction) => transaction.type == TransactionType.expense
    );
    
    return expenseTransactions.fold(0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Future<double> getBalance([DateTime? startDate, DateTime? endDate]) async {
    final totalIncome = await getTotalIncome(startDate, endDate);
    final totalExpenses = await getTotalExpenses(startDate, endDate);
    
    return totalIncome - totalExpenses;
  }
}
