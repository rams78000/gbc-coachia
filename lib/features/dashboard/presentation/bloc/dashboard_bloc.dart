import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc_coachai/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:gbc_coachai/features/dashboard/domain/repositories/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc({required DashboardRepository repository})
      : _repository = repository,
        super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
    on<LoadFinancialTrends>(_onLoadFinancialTrends);
    on<LoadActivitySummary>(_onLoadActivitySummary);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(DashboardLoading());
      final dashboardData = await _repository.getDashboardData();
      emit(DashboardLoaded(dashboardData: dashboardData));
    } catch (error) {
      emit(DashboardError(message: error.toString()));
    }
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      // Keep current state while refreshing
      final currentState = state;
      emit(DashboardRefreshing(
        dashboardData: currentState is DashboardLoaded
            ? currentState.dashboardData
            : DashboardData.empty(),
      ));

      await _repository.refreshDashboardData();
      final dashboardData = await _repository.getDashboardData();
      emit(DashboardLoaded(dashboardData: dashboardData));
    } catch (error) {
      emit(DashboardError(message: error.toString()));
    }
  }

  Future<void> _onLoadFinancialTrends(
    LoadFinancialTrends event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is DashboardLoaded) {
        emit(DashboardLoading());
        final trends = await _repository.getFinancialTrends(months: event.months);
        final financialOverview = currentState.dashboardData.financialOverview.copyWith(
          monthlySummary: trends,
        );
        final dashboardData = currentState.dashboardData.copyWith(
          financialOverview: financialOverview,
        );
        emit(DashboardLoaded(dashboardData: dashboardData));
      }
    } catch (error) {
      emit(DashboardError(message: error.toString()));
    }
  }

  Future<void> _onLoadActivitySummary(
    LoadActivitySummary event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is DashboardLoaded) {
        emit(DashboardLoading());
        final activitySummary = await _repository.getActivitySummary();
        final dashboardData = currentState.dashboardData.copyWith(
          activitySummary: activitySummary,
        );
        emit(DashboardLoaded(dashboardData: dashboardData));
      }
    } catch (error) {
      emit(DashboardError(message: error.toString()));
    }
  }
}
