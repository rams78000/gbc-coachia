import 'package:equatable/equatable.dart';

/// Classe principale pour gérer les données du tableau de bord
class DashboardData extends Equatable {
  final FinancialOverview financialOverview;
  final List<PlannerQuickView> upcomingEvents;
  final List<MessageQuickView> recentMessages;
  final List<DocumentQuickView> recentDocuments;
  final List<TodoItem> tasks;
  final DateTime lastUpdated;

  const DashboardData({
    required this.financialOverview,
    required this.upcomingEvents,
    required this.recentMessages,
    required this.recentDocuments,
    required this.tasks,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        financialOverview,
        upcomingEvents,
        recentMessages,
        recentDocuments,
        tasks,
        lastUpdated,
      ];

  /// Crée un tableau de bord vide
  factory DashboardData.empty() {
    return DashboardData(
      financialOverview: FinancialOverview.empty(),
      upcomingEvents: const [],
      recentMessages: const [],
      recentDocuments: const [],
      tasks: const [],
      lastUpdated: DateTime.now(),
    );
  }

  /// Crée une copie de cet objet avec les valeurs spécifiées
  DashboardData copyWith({
    FinancialOverview? financialOverview,
    List<PlannerQuickView>? upcomingEvents,
    List<MessageQuickView>? recentMessages,
    List<DocumentQuickView>? recentDocuments,
    List<TodoItem>? tasks,
    DateTime? lastUpdated,
  }) {
    return DashboardData(
      financialOverview: financialOverview ?? this.financialOverview,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      recentMessages: recentMessages ?? this.recentMessages,
      recentDocuments: recentDocuments ?? this.recentDocuments,
      tasks: tasks ?? this.tasks,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Résumé financier pour l'aperçu du tableau de bord
class FinancialOverview extends Equatable {
  final double totalIncome;
  final double totalExpenses;
  final double currentBalance;
  final double previousPeriodIncome;
  final double previousPeriodExpenses;
  final double incomeThisMonth;
  final double expensesThisMonth;
  final double pendingInvoices;
  final List<CategorySummary> topExpenseCategories;
  final List<MonthlySummary> monthlySummary;
  final DateTime lastUpdated;

  const FinancialOverview({
    required this.totalIncome,
    required this.totalExpenses,
    required this.currentBalance,
    required this.previousPeriodIncome,
    required this.previousPeriodExpenses,
    required this.incomeThisMonth,
    required this.expensesThisMonth,
    required this.pendingInvoices,
    required this.topExpenseCategories,
    required this.monthlySummary,
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
    incomeThisMonth,
    expensesThisMonth,
    pendingInvoices,
    topExpenseCategories,
    monthlySummary,
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
      incomeThisMonth: 0,
      expensesThisMonth: 0,
      pendingInvoices: 0,
      topExpenseCategories: const [],
      monthlySummary: const [],
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
    double? incomeThisMonth,
    double? expensesThisMonth,
    double? pendingInvoices,
    List<CategorySummary>? topExpenseCategories,
    List<MonthlySummary>? monthlySummary,
    DateTime? lastUpdated,
  }) {
    return FinancialOverview(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      currentBalance: currentBalance ?? this.currentBalance,
      previousPeriodIncome: previousPeriodIncome ?? this.previousPeriodIncome,
      previousPeriodExpenses: previousPeriodExpenses ?? this.previousPeriodExpenses,
      incomeThisMonth: incomeThisMonth ?? this.incomeThisMonth,
      expensesThisMonth: expensesThisMonth ?? this.expensesThisMonth,
      pendingInvoices: pendingInvoices ?? this.pendingInvoices,
      topExpenseCategories: topExpenseCategories ?? this.topExpenseCategories,
      monthlySummary: monthlySummary ?? this.monthlySummary,
      lastUpdated: lastUpdated ?? this.lastUpdated,
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
}

/// Données financières mensuelles pour les graphiques
class MonthlySummary extends Equatable {
  final String month;
  final double income;
  final double expenses;

  const MonthlySummary({
    required this.month,
    required this.income,
    required this.expenses,
  });

  @override
  List<Object?> get props => [month, income, expenses];
}

/// Aperçu rapide des événements à venir pour le tableau de bord
class PlannerQuickView extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final bool isAllDay;
  final String? location;

  const PlannerQuickView({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.isAllDay,
    this.location,
  });

  @override
  List<Object?> get props => [id, title, date, description, isAllDay, location];
}

/// Aperçu rapide des messages récents pour le tableau de bord
class MessageQuickView extends Equatable {
  final String id;
  final String sender;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  const MessageQuickView({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });

  @override
  List<Object?> get props => [id, sender, content, timestamp, isRead];
}

/// Aperçu rapide des documents récents pour le tableau de bord
class DocumentQuickView extends Equatable {
  final String id;
  final String title;
  final String fileType;
  final DateTime lastModified;
  final String? category;

  const DocumentQuickView({
    required this.id,
    required this.title,
    required this.fileType,
    required this.lastModified,
    this.category,
  });

  @override
  List<Object?> get props => [id, title, fileType, lastModified, category];
}

/// Élément de liste de tâches pour le tableau de bord
class TodoItem extends Equatable {
  final String id;
  final String title;
  final DateTime? dueDate;
  final bool isCompleted;
  final String? category;
  final int? priority; // 1 (élevé) à 3 (faible)

  const TodoItem({
    required this.id,
    required this.title,
    this.dueDate,
    required this.isCompleted,
    this.category,
    this.priority,
  });

  @override
  List<Object?> get props => [id, title, dueDate, isCompleted, category, priority];
}
