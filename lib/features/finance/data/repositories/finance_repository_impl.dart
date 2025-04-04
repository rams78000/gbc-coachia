import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/finance_repository.dart';

/// Implémentation du repository des finances
class FinanceRepositoryImpl implements FinanceRepository {
  /// Clé pour stocker les transactions dans SharedPreferences
  static const _transactionsKey = 'finance_transactions';

  @override
  Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
    
    return transactionsJson
        .map((json) => _transactionFromJson(json))
        .toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // Trier par date décroissante
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
    
    // Utiliser l'ID existant ou en générer un nouveau
    final transactionWithId = transaction.id.isEmpty 
        ? transaction.copyWith(id: const Uuid().v4()) 
        : transaction;
    
    transactionsJson.add(_transactionToJson(transactionWithId));
    await prefs.setStringList(_transactionsKey, transactionsJson);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
    
    final transactions = transactionsJson.map((json) => _transactionFromJson(json)).toList();
    
    final index = transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      transactions[index] = transaction;
      
      final updatedTransactionsJson = transactions.map((t) => _transactionToJson(t)).toList();
      await prefs.setStringList(_transactionsKey, updatedTransactionsJson);
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
    
    final transactions = transactionsJson.map((json) => _transactionFromJson(json)).toList();
    
    transactions.removeWhere((transaction) => transaction.id == id);
    
    final updatedTransactionsJson = transactions.map((t) => _transactionToJson(t)).toList();
    await prefs.setStringList(_transactionsKey, updatedTransactionsJson);
  }

  @override
  Future<double> getCurrentBalance() async {
    final transactions = await getTransactions();
    
    double balance = 0;
    for (final transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      }
    }
    
    return balance;
  }

  @override
  Future<FinanceStats> getStats(Period period) async {
    final transactions = await getTransactions();
    
    final DateTime now = DateTime.now();
    final DateTime periodStart = _getPeriodStart(now, period);
    
    // Filtrer les transactions par période
    final periodTransactions = transactions.where((t) => t.date.isAfter(periodStart)).toList();
    
    // Calculer les totaux
    double totalIncome = 0;
    double totalExpenses = 0;
    final Map<String, double> expensesByCategory = {};
    
    for (final transaction in periodTransactions) {
      if (transaction.type == TransactionType.income) {
        totalIncome += transaction.amount;
      } else {
        totalExpenses += transaction.amount;
        
        // Ajouter à la catégorie
        if (expensesByCategory.containsKey(transaction.category)) {
          expensesByCategory[transaction.category] = 
              expensesByCategory[transaction.category]! + transaction.amount;
        } else {
          expensesByCategory[transaction.category] = transaction.amount;
        }
      }
    }
    
    // Générer les tendances
    final expenseTrend = _generateTrend(periodTransactions.where((t) => t.type == TransactionType.expense).toList(), period);
    final incomeTrend = _generateTrend(periodTransactions.where((t) => t.type == TransactionType.income).toList(), period);
    
    return FinanceStats(
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      netBalance: totalIncome - totalExpenses,
      expensesByCategory: expensesByCategory,
      expenseTrend: expenseTrend,
      incomeTrend: incomeTrend,
    );
  }

  /// Obtient la date de début pour la période spécifiée
  DateTime _getPeriodStart(DateTime now, Period period) {
    switch (period) {
      case Period.week:
        return now.subtract(const Duration(days: 7));
      case Period.month:
        return DateTime(now.year, now.month - 1, now.day);
      case Period.year:
        return DateTime(now.year - 1, now.month, now.day);
    }
  }

  /// Génère une tendance pour un ensemble de transactions
  List<DataPoint> _generateTrend(List<Transaction> transactions, Period period) {
    if (transactions.isEmpty) {
      return [];
    }
    
    final Map<String, double> dateTotals = {};
    
    for (final transaction in transactions) {
      final String key = _getKeyForPeriod(transaction.date, period);
      
      if (dateTotals.containsKey(key)) {
        dateTotals[key] = dateTotals[key]! + transaction.amount;
      } else {
        dateTotals[key] = transaction.amount;
      }
    }
    
    final trend = <DataPoint>[];
    final now = DateTime.now();
    
    switch (period) {
      case Period.week:
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final key = _getKeyForPeriod(date, period);
          trend.add(DataPoint(
            date: date,
            value: dateTotals[key] ?? 0,
          ));
        }
        break;
      case Period.month:
        for (int i = 29; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final key = _getKeyForPeriod(date, period);
          trend.add(DataPoint(
            date: date,
            value: dateTotals[key] ?? 0,
          ));
        }
        break;
      case Period.year:
        for (int i = 11; i >= 0; i--) {
          final month = now.month - i <= 0 
              ? now.month - i + 12 
              : now.month - i;
          final year = now.month - i <= 0 
              ? now.year - 1 
              : now.year;
          final date = DateTime(year, month, 1);
          final key = _getKeyForPeriod(date, period);
          trend.add(DataPoint(
            date: date,
            value: dateTotals[key] ?? 0,
          ));
        }
        break;
    }
    
    return trend;
  }

  /// Obtient la clé de regroupement pour une date selon la période
  String _getKeyForPeriod(DateTime date, Period period) {
    switch (period) {
      case Period.week:
        return '${date.year}-${date.month}-${date.day}';
      case Period.month:
        return '${date.year}-${date.month}-${(date.day / 3).floor()}';
      case Period.year:
        return '${date.year}-${date.month}';
    }
  }

  /// Convertit une Transaction en JSON
  String _transactionToJson(Transaction transaction) {
    return jsonEncode(transaction.toMap());
  }

  /// Crée une Transaction à partir d'un JSON
  Transaction _transactionFromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    
    // Convertir l'amount en double
    if (map['amount'] is int) {
      map['amount'] = (map['amount'] as int).toDouble();
    }
    
    return Transaction.fromMap(map);
  }
}
