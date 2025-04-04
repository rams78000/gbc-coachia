/// Représente une synthèse financière mensuelle
class MonthlySummary {
  final String month;
  final double income;
  final double expenses;

  const MonthlySummary({
    required this.month,
    required this.income,
    required this.expenses,
  });

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'income': income,
      'expenses': expenses,
    };
  }

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      month: json['month'],
      income: json['income'],
      expenses: json['expenses'],
    );
  }
}

/// Représente une vue d'ensemble des données financières
class FinancialOverview {
  final double currentBalance;
  final double incomeThisMonth;
  final double expensesThisMonth;
  final double pendingInvoices;
  final List<MonthlySummary> monthlySummary;

  const FinancialOverview({
    required this.currentBalance,
    required this.incomeThisMonth,
    required this.expensesThisMonth,
    required this.pendingInvoices,
    required this.monthlySummary,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentBalance': currentBalance,
      'incomeThisMonth': incomeThisMonth,
      'expensesThisMonth': expensesThisMonth,
      'pendingInvoices': pendingInvoices,
      'monthlySummary': monthlySummary.map((m) => m.toJson()).toList(),
    };
  }

  factory FinancialOverview.fromJson(Map<String, dynamic> json) {
    return FinancialOverview(
      currentBalance: json['currentBalance'],
      incomeThisMonth: json['incomeThisMonth'],
      expensesThisMonth: json['expensesThisMonth'],
      pendingInvoices: json['pendingInvoices'],
      monthlySummary: (json['monthlySummary'] as List)
          .map((m) => MonthlySummary.fromJson(m))
          .toList(),
    );
  }
}
