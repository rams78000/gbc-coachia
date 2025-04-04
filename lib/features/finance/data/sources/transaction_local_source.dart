import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gbc_coachai/features/finance/domain/entities/transaction.dart';

abstract class TransactionLocalSource {
  Future<List<Transaction>> getTransactions();
  Future<Transaction?> getTransactionById(String id);
  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
}

class TransactionLocalSourceImpl implements TransactionLocalSource {
  final SharedPreferences sharedPreferences;
  static const String _transactionsKey = 'transactions';

  TransactionLocalSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Transaction>> getTransactions() async {
    final transactionsJson = sharedPreferences.getStringList(_transactionsKey) ?? [];
    return transactionsJson
        .map((json) => Transaction.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    final transactions = await getTransactions();
    return transactions.firstWhere(
      (transaction) => transaction.id == id,
      orElse: () => throw Exception('Transaction not found'),
    );
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final transactions = await getTransactions();
    transactions.add(transaction);
    await _saveTransactions(transactions);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final transactions = await getTransactions();
    final index = transactions.indexWhere((t) => t.id == transaction.id);
    
    if (index != -1) {
      transactions[index] = transaction;
      await _saveTransactions(transactions);
    } else {
      throw Exception('Transaction not found');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final transactions = await getTransactions();
    transactions.removeWhere((transaction) => transaction.id == id);
    await _saveTransactions(transactions);
  }

  Future<void> _saveTransactions(List<Transaction> transactions) async {
    final transactionsJson = transactions
        .map((transaction) => jsonEncode(transaction.toJson()))
        .toList();
    
    await sharedPreferences.setStringList(_transactionsKey, transactionsJson);
  }
}
