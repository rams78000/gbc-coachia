import 'package:equatable/equatable.dart';

import 'transaction.dart';

/// Périodes financières
enum FinancialPeriod {
  daily,    // Journalier
  weekly,   // Hebdomadaire
  monthly,  // Mensuel
  quarterly, // Trimestriel
  yearly,   // Annuel
  custom,   // Personnalisé
}

/// Extension pour ajouter des méthodes utilitaires aux périodes financières
extension FinancialPeriodExtension on FinancialPeriod {
  /// Renvoie le nom localisé de la période
  String getLocalizedName() {
    switch (this) {
      case FinancialPeriod.daily:
        return 'Jour';
      case FinancialPeriod.weekly:
        return 'Semaine';
      case FinancialPeriod.monthly:
        return 'Mois';
      case FinancialPeriod.quarterly:
        return 'Trimestre';
      case FinancialPeriod.yearly:
        return 'Année';
      case FinancialPeriod.custom:
        return 'Personnalisé';
    }
  }
  
  /// Renvoie la plage de dates pour la période actuelle
  (DateTime, DateTime) getDateRange() {
    final now = DateTime.now();
    
    switch (this) {
      case FinancialPeriod.daily:
        return (
          DateTime(now.year, now.month, now.day),
          DateTime(now.year, now.month, now.day, 23, 59, 59),
        );
      
      case FinancialPeriod.weekly:
        // Trouver le premier jour de la semaine (lundi)
        final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return (
          DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day),
          DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day + 6, 23, 59, 59),
        );
      
      case FinancialPeriod.monthly:
        return (
          DateTime(now.year, now.month, 1),
          DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1)),
        );
      
      case FinancialPeriod.quarterly:
        final currentQuarter = ((now.month - 1) ~/ 3);
        final firstMonthOfQuarter = currentQuarter * 3 + 1;
        return (
          DateTime(now.year, firstMonthOfQuarter, 1),
          DateTime(now.year, firstMonthOfQuarter + 3, 1).subtract(const Duration(days: 1)),
        );
      
      case FinancialPeriod.yearly:
        return (
          DateTime(now.year, 1, 1),
          DateTime(now.year, 12, 31, 23, 59, 59),
        );
      
      case FinancialPeriod.custom:
        // Par défaut, on utilise le mois en cours
        return (
          DateTime(now.year, now.month, 1),
          DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1)),
        );
    }
  }
}

/// Classe représentant un résumé financier pour une période donnée
class FinancialSummary extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final double totalIncome;
  final double totalExpenses;
  final double netBalance;
  final int transactionCount;
  final Map<TransactionCategory, double> expensesByCategory;
  final Map<TransactionCategory, double> incomesByCategory;
  final double? budgetAmount;
  final double? budgetAvailable;
  final double? budgetUsedPercentage;
  
  /// Constructeur
  const FinancialSummary({
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
    required this.transactionCount,
    required this.expensesByCategory,
    required this.incomesByCategory,
    this.budgetAmount,
    this.budgetAvailable,
    this.budgetUsedPercentage,
  });
  
  /// Crée un résumé financier à partir d'une liste de transactions
  factory FinancialSummary.fromTransactions({
    required List<Transaction> transactions,
    required DateTime startDate,
    required DateTime endDate,
    double? budgetAmount,
  }) {
    // Calcul des totaux
    double totalIncome = 0.0;
    double totalExpenses = 0.0;
    final expensesByCategory = <TransactionCategory, double>{};
    final incomesByCategory = <TransactionCategory, double>{};
    
    for (final transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        totalIncome += transaction.amount;
        
        // Mise à jour des revenus par catégorie
        final currentCategoryAmount = incomesByCategory[transaction.category] ?? 0.0;
        incomesByCategory[transaction.category] = currentCategoryAmount + transaction.amount;
      } else {
        totalExpenses += transaction.amount;
        
        // Mise à jour des dépenses par catégorie
        final currentCategoryAmount = expensesByCategory[transaction.category] ?? 0.0;
        expensesByCategory[transaction.category] = currentCategoryAmount + transaction.amount;
      }
    }
    
    // Calcul du solde net
    final netBalance = totalIncome - totalExpenses;
    
    // Calcul des informations de budget (si un budget est fourni)
    double? budgetAvailable;
    double? budgetUsedPercentage;
    
    if (budgetAmount != null) {
      budgetAvailable = budgetAmount - totalExpenses;
      budgetUsedPercentage = (totalExpenses / budgetAmount) * 100;
    }
    
    return FinancialSummary(
      startDate: startDate,
      endDate: endDate,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      netBalance: netBalance,
      transactionCount: transactions.length,
      expensesByCategory: expensesByCategory,
      incomesByCategory: incomesByCategory,
      budgetAmount: budgetAmount,
      budgetAvailable: budgetAvailable,
      budgetUsedPercentage: budgetUsedPercentage,
    );
  }
  
  /// Crée une copie du résumé avec des propriétés modifiées
  FinancialSummary copyWith({
    DateTime? startDate,
    DateTime? endDate,
    double? totalIncome,
    double? totalExpenses,
    double? netBalance,
    int? transactionCount,
    Map<TransactionCategory, double>? expensesByCategory,
    Map<TransactionCategory, double>? incomesByCategory,
    double? budgetAmount,
    double? budgetAvailable,
    double? budgetUsedPercentage,
    bool clearBudgetAmount = false,
    bool clearBudgetAvailable = false,
    bool clearBudgetUsedPercentage = false,
  }) {
    return FinancialSummary(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      netBalance: netBalance ?? this.netBalance,
      transactionCount: transactionCount ?? this.transactionCount,
      expensesByCategory: expensesByCategory ?? this.expensesByCategory,
      incomesByCategory: incomesByCategory ?? this.incomesByCategory,
      budgetAmount: clearBudgetAmount ? null : (budgetAmount ?? this.budgetAmount),
      budgetAvailable: clearBudgetAvailable ? null : (budgetAvailable ?? this.budgetAvailable),
      budgetUsedPercentage: clearBudgetUsedPercentage ? null : (budgetUsedPercentage ?? this.budgetUsedPercentage),
    );
  }
  
  @override
  List<Object?> get props => [
    startDate,
    endDate,
    totalIncome,
    totalExpenses,
    netBalance,
    transactionCount,
    expensesByCategory,
    incomesByCategory,
    budgetAmount,
    budgetAvailable,
    budgetUsedPercentage,
  ];
}
