import 'package:gbc_coachai/features/dashboard/domain/entities/dashboard_data.dart';

abstract class DashboardRepository {
  Future<DashboardData> getDashboardData();
  Future<List<MonthlyFinancialData>> getFinancialTrends({int months = 6});
  Future<ActivitySummary> getActivitySummary();
  Future<void> refreshDashboardData();
}
