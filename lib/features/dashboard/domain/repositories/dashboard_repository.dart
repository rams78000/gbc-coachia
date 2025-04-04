import 'package:gbc_coachia/features/dashboard/domain/entities/activity_summary.dart';
import 'package:gbc_coachia/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:gbc_coachia/features/dashboard/domain/entities/financial_overview.dart';

/// Interface for the Dashboard Repository
abstract class DashboardRepository {
  /// Récupère toutes les données du tableau de bord
  Future<DashboardData> getDashboardData();
  
  /// Récupère les tendances financières pour un nombre spécifié de mois
  Future<List<MonthlySummary>> getFinancialTrends({int months = 6});
  
  /// Récupère le résumé des activités
  Future<ActivitySummary> getActivitySummary();
  
  /// Rafraîchit les données du tableau de bord
  Future<void> refreshDashboardData();
}
