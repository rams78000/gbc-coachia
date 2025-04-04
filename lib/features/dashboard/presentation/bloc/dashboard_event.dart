part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  const LoadDashboardData();
}

class RefreshDashboardData extends DashboardEvent {
  const RefreshDashboardData();
}

class LoadFinancialTrends extends DashboardEvent {
  final int months;

  const LoadFinancialTrends({this.months = 6});

  @override
  List<Object> get props => [months];
}

class LoadActivitySummary extends DashboardEvent {
  const LoadActivitySummary();
}
