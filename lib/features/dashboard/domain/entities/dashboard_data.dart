import 'package:gbc_coachai/features/documents/domain/entities/document.dart';
import 'package:gbc_coachai/features/finance/domain/models/transaction.dart';
import 'package:gbc_coachai/features/planner/domain/models/calendar_event.dart';

class DashboardData {
  final List<CalendarEvent> upcomingEvents;
  final List<Transaction> recentTransactions;
  final List<Document> recentDocuments;
  final FinancialOverview financialOverview;
  final ActivitySummary activitySummary;

  DashboardData({
    required this.upcomingEvents,
    required this.recentTransactions,
    required this.recentDocuments,
    required this.financialOverview,
    required this.activitySummary,
  });

  factory DashboardData.empty() => DashboardData(
        upcomingEvents: const [],
        recentTransactions: const [],
        recentDocuments: const [],
        financialOverview: FinancialOverview.empty(),
        activitySummary: ActivitySummary.empty(),
      );

  DashboardData copyWith({
    List<CalendarEvent>? upcomingEvents,
    List<Transaction>? recentTransactions,
    List<Document>? recentDocuments,
    FinancialOverview? financialOverview,
    ActivitySummary? activitySummary,
  }) {
    return DashboardData(
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      recentDocuments: recentDocuments ?? this.recentDocuments,
      financialOverview: financialOverview ?? this.financialOverview,
      activitySummary: activitySummary ?? this.activitySummary,
    );
  }
}

class FinancialOverview {
  final double currentBalance;
  final double incomeThisMonth;
  final double expensesThisMonth;
  final double pendingInvoices;
  final List<MonthlyFinancialData> monthlySummary;

  FinancialOverview({
    required this.currentBalance,
    required this.incomeThisMonth,
    required this.expensesThisMonth,
    required this.pendingInvoices,
    required this.monthlySummary,
  });

  factory FinancialOverview.empty() => FinancialOverview(
        currentBalance: 0,
        incomeThisMonth: 0,
        expensesThisMonth: 0,
        pendingInvoices: 0,
        monthlySummary: const [],
      );

  FinancialOverview copyWith({
    double? currentBalance,
    double? incomeThisMonth,
    double? expensesThisMonth,
    double? pendingInvoices,
    List<MonthlyFinancialData>? monthlySummary,
  }) {
    return FinancialOverview(
      currentBalance: currentBalance ?? this.currentBalance,
      incomeThisMonth: incomeThisMonth ?? this.incomeThisMonth,
      expensesThisMonth: expensesThisMonth ?? this.expensesThisMonth,
      pendingInvoices: pendingInvoices ?? this.pendingInvoices,
      monthlySummary: monthlySummary ?? this.monthlySummary,
    );
  }
}

class MonthlyFinancialData {
  final String month;
  final double income;
  final double expenses;

  MonthlyFinancialData({
    required this.month,
    required this.income,
    required this.expenses,
  });
}

class ActivitySummary {
  final int totalEvents;
  final int completedEvents;
  final int totalDocuments;
  final int totalTransactions;
  final List<CategoryUsage> categoryUsage;

  ActivitySummary({
    required this.totalEvents,
    required this.completedEvents,
    required this.totalDocuments,
    required this.totalTransactions,
    required this.categoryUsage,
  });

  factory ActivitySummary.empty() => ActivitySummary(
        totalEvents: 0,
        completedEvents: 0,
        totalDocuments: 0,
        totalTransactions: 0,
        categoryUsage: const [],
      );

  ActivitySummary copyWith({
    int? totalEvents,
    int? completedEvents,
    int? totalDocuments,
    int? totalTransactions,
    List<CategoryUsage>? categoryUsage,
  }) {
    return ActivitySummary(
      totalEvents: totalEvents ?? this.totalEvents,
      completedEvents: completedEvents ?? this.completedEvents,
      totalDocuments: totalDocuments ?? this.totalDocuments,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      categoryUsage: categoryUsage ?? this.categoryUsage,
    );
  }
}

class CategoryUsage {
  final String category;
  final double percentage;

  CategoryUsage({
    required this.category,
    required this.percentage,
  });
}
