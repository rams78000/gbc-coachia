import 'package:equatable/equatable.dart';

/// Résumé financier pour l'aperçu du tableau de bord
class FinancialOverview extends Equatable {
  final double totalIncome;
  final double totalExpenses;
  final double currentBalance;
  final double previousPeriodIncome;
  final double previousPeriodExpenses;
  final List<CategorySummary> topExpenseCategories;
  final List<MonthlyData> monthlyData;
  final DateTime lastUpdated;

  const FinancialOverview({
    required this.totalIncome,
    required this.totalExpenses,
    required this.currentBalance,
    required this.previousPeriodIncome,
    required this.previousPeriodExpenses,
    required this.topExpenseCategories,
    required this.monthlyData,
    required this.lastUpdated,
  });

  /// Calcule la variation en pourcentage des revenus par rapport à la période précédente
  double get incomeChangePercentage => 
    previousPeriodIncome == 0 
      ? 0 
      : ((totalIncome - previousPeriodIncome) / previousPeriodIncome) * 100;

  /// Calcule la variation en pourcentage des dépenses par rapport à la période précédente
  double get expensesChangePercentage =>
    previousPeriodExpenses == 0
      ? 0
      : ((totalExpenses - previousPeriodExpenses) / previousPeriodExpenses) * 100;

  /// Indique si les revenus sont en hausse par rapport à la période précédente
  bool get isIncomeIncreasing => totalIncome > previousPeriodIncome;

  /// Indique si les dépenses sont en hausse par rapport à la période précédente
  bool get isExpensesIncreasing => totalExpenses > previousPeriodExpenses;

  @override
  List<Object?> get props => [
    totalIncome,
    totalExpenses,
    currentBalance,
    previousPeriodIncome,
    previousPeriodExpenses,
    topExpenseCategories,
    monthlyData,
    lastUpdated,
  ];

  /// Crée une instance avec des données vides
  factory FinancialOverview.empty() {
    return FinancialOverview(
      totalIncome: 0,
      totalExpenses: 0,
      currentBalance: 0,
      previousPeriodIncome: 0,
      previousPeriodExpenses: 0,
      topExpenseCategories: const [],
      monthlyData: const [],
      lastUpdated: DateTime.now(),
    );
  }

  /// Crée une copie de cet objet avec les valeurs spécifiées
  FinancialOverview copyWith({
    double? totalIncome,
    double? totalExpenses,
    double? currentBalance,
    double? previousPeriodIncome,
    double? previousPeriodExpenses,
    List<CategorySummary>? topExpenseCategories,
    List<MonthlyData>? monthlyData,
    DateTime? lastUpdated,
  }) {
    return FinancialOverview(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      currentBalance: currentBalance ?? this.currentBalance,
      previousPeriodIncome: previousPeriodIncome ?? this.previousPeriodIncome,
      previousPeriodExpenses: previousPeriodExpenses ?? this.previousPeriodExpenses,
      topExpenseCategories: topExpenseCategories ?? this.topExpenseCategories,
      monthlyData: monthlyData ?? this.monthlyData,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Convertit l'objet en JSON
  Map<String, dynamic> toJson() {
    return {
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'currentBalance': currentBalance,
      'previousPeriodIncome': previousPeriodIncome,
      'previousPeriodExpenses': previousPeriodExpenses,
      'topExpenseCategories': topExpenseCategories.map((e) => e.toJson()).toList(),
      'monthlyData': monthlyData.map((e) => e.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Crée un objet à partir de JSON
  factory FinancialOverview.fromJson(Map<String, dynamic> json) {
    return FinancialOverview(
      totalIncome: json['totalIncome'] as double,
      totalExpenses: json['totalExpenses'] as double,
      currentBalance: json['currentBalance'] as double,
      previousPeriodIncome: json['previousPeriodIncome'] as double,
      previousPeriodExpenses: json['previousPeriodExpenses'] as double,
      topExpenseCategories: (json['topExpenseCategories'] as List)
          .map((e) => CategorySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      monthlyData: (json['monthlyData'] as List)
          .map((e) => MonthlyData.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}

/// Résumé des dépenses par catégorie
class CategorySummary extends Equatable {
  final String category;
  final double amount;
  final double percentage; // Pourcentage du total des dépenses

  const CategorySummary({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  @override
  List<Object?> get props => [category, amount, percentage];

  /// Convertit l'objet en JSON
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'amount': amount,
      'percentage': percentage,
    };
  }

  /// Crée un objet à partir de JSON
  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    return CategorySummary(
      category: json['category'] as String,
      amount: json['amount'] as double,
      percentage: json['percentage'] as double,
    );
  }
}

/// Données financières mensuelles pour les graphiques
class MonthlyData extends Equatable {
  final DateTime month;
  final double income;
  final double expenses;

  const MonthlyData({
    required this.month,
    required this.income,
    required this.expenses,
  });

  @override
  List<Object?> get props => [month, income, expenses];

  /// Convertit l'objet en JSON
  Map<String, dynamic> toJson() {
    return {
      'month': month.toIso8601String(),
      'income': income,
      'expenses': expenses,
    };
  }

  /// Crée un objet à partir de JSON
  factory MonthlyData.fromJson(Map<String, dynamic> json) {
    return MonthlyData(
      month: DateTime.parse(json['month'] as String),
      income: json['income'] as double,
      expenses: json['expenses'] as double,
    );
  }
}
