part of 'planner_bloc.dart';

abstract class PlannerState extends Equatable {
  const PlannerState();
  
  @override
  List<Object> get props => [];
}

class PlannerInitial extends PlannerState {}

class PlannerLoading extends PlannerState {}

class PlannerLoaded extends PlannerState {
  final List<Map<String, dynamic>> tasks;
  
  const PlannerLoaded({required this.tasks});
  
  @override
  List<Object> get props => [tasks];
}

class PlannerError extends PlannerState {
  final String message;
  
  const PlannerError(this.message);
  
  @override
  List<Object> get props => [message];
}
