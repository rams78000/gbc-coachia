import 'package:gbc_coachia/features/dashboard/domain/entities/activity_summary.dart';
import 'package:gbc_coachia/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:gbc_coachia/features/dashboard/domain/entities/financial_overview.dart';
import 'package:gbc_coachia/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:gbc_coachia/features/documents/domain/repositories/document_repository.dart';
import 'package:gbc_coachia/features/finance/domain/repositories/transaction_repository.dart';
import 'package:gbc_coachia/features/planner/domain/repositories/event_repository.dart';
import 'package:intl/intl.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final TransactionRepository _transactionRepository;
  final EventRepository _eventRepository;
  final DocumentRepository _documentRepository;

  DashboardRepositoryImpl({
    required TransactionRepository transactionRepository,
    required EventRepository eventRepository,
    required DocumentRepository documentRepository,
  })  : _transactionRepository = transactionRepository,
        _eventRepository = eventRepository,
        _documentRepository = documentRepository;

  @override
  Future<DashboardData> getDashboardData() async {
    // Récupérer les événements à venir
    final now = DateTime.now();
    final upcomingEvents = await _eventRepository.getEventsBetweenDates(
      now,
      now.add(const Duration(days: 7)),
    );

    // Calculer la synthèse financière
    final currentMonth = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);
    
    final thisMonthTransactions = await _transactionRepository.getTransactionsBetweenDates(
      currentMonth,
      nextMonth.subtract(const Duration(days: 1)),
    );
    
    double incomeThisMonth = 0;
    double expensesThisMonth = 0;
    
    for (final transaction in thisMonthTransactions) {
      if (transaction.isIncome) {
        incomeThisMonth += transaction.amount;
      } else {
        expensesThisMonth += transaction.amount;
      }
    }
    
    final allTransactions = await _transactionRepository.getAllTransactions();
    double currentBalance = 0;
    double pendingInvoices = 0;
    
    for (final transaction in allTransactions) {
      if (transaction.isIncome) {
        currentBalance += transaction.amount;
        if (transaction.isPending) {
          pendingInvoices += transaction.amount;
        }
      } else {
        currentBalance -= transaction.amount;
      }
    }

    // Résumé des activités
    final allEvents = await _eventRepository.getAllEvents();
    final completedEvents = allEvents.where((event) => event.isCompleted).length;
    
    final allDocuments = await _documentRepository.getAllDocuments();
    
    // Tendances financières mensuelles (6 derniers mois)
    final monthlySummary = await getFinancialTrends();

    // Calculer la répartition par catégorie
    final Map<String, int> categoryCount = {};
    for (final transaction in allTransactions) {
      final category = transaction.category;
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }
    
    final totalTransactions = allTransactions.length;
    
    // Calculer le taux de complétion
    final completionRate = allEvents.isEmpty ? 0.0 : (completedEvents / allEvents.length) * 100;

    return DashboardData(
      upcomingEvents: upcomingEvents,
      financialOverview: FinancialOverview(
        currentBalance: currentBalance,
        incomeThisMonth: incomeThisMonth,
        expensesThisMonth: expensesThisMonth,
        pendingInvoices: pendingInvoices,
        monthlySummary: monthlySummary,
      ),
      activitySummary: ActivitySummary(
        totalEvents: allEvents.length,
        completedEvents: completedEvents,
        totalDocuments: allDocuments.length,
        totalTransactions: allTransactions.length,
        completionRate: completionRate,
      ),
    );
  }

  @override
  Future<List<MonthlySummary>> getFinancialTrends({int months = 6}) async {
    final List<MonthlySummary> monthlySummary = [];
    final now = DateTime.now();
    
    for (int i = months - 1; i >= 0; i--) {
      final targetMonth = DateTime(now.year, now.month - i);
      final startOfMonth = DateTime(targetMonth.year, targetMonth.month, 1);
      final endOfMonth = DateTime(targetMonth.year, targetMonth.month + 1, 0);
      
      final monthTransactions = await _transactionRepository.getTransactionsBetweenDates(
        startOfMonth,
        endOfMonth,
      );
      
      double monthlyIncome = 0;
      double monthlyExpenses = 0;
      
      for (final transaction in monthTransactions) {
        if (transaction.isIncome) {
          monthlyIncome += transaction.amount;
        } else {
          monthlyExpenses += transaction.amount;
        }
      }
      
      monthlySummary.add(
        MonthlySummary(
          month: DateFormat('MMM').format(startOfMonth),
          income: monthlyIncome,
          expenses: monthlyExpenses,
        ),
      );
    }
    
    return monthlySummary;
  }

  @override
  Future<ActivitySummary> getActivitySummary() async {
    final allEvents = await _eventRepository.getAllEvents();
    final completedEvents = allEvents.where((event) => event.isCompleted).length;
    
    final allDocuments = await _documentRepository.getAllDocuments();
    final allTransactions = await _transactionRepository.getAllTransactions();
    
    // Calculer le taux de complétion
    final completionRate = allEvents.isEmpty ? 0.0 : (completedEvents / allEvents.length) * 100;
    
    return ActivitySummary(
      totalEvents: allEvents.length,
      completedEvents: completedEvents,
      totalDocuments: allDocuments.length,
      totalTransactions: allTransactions.length,
      completionRate: completionRate,
    );
  }

  @override
  Future<void> refreshDashboardData() async {
    // Force refresh data from repositories if needed
  }
}
