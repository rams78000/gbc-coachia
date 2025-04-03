part of 'finance_bloc.dart';

abstract class FinanceState extends Equatable {
  const FinanceState();
  
  @override
  List<Object> get props => [];
}

class FinanceInitial extends FinanceState {}

class FinanceLoading extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final List<Map<String, dynamic>> transactions;
  final Map<String, dynamic>? budget;
  
  const FinanceLoaded({
    required this.transactions,
    this.budget,
  });
  
  @override
  List<Object> get props => [
    transactions,
    if (budget != null) budget!,
  ];
}

class FinanceError extends FinanceState {
  final String message;
  
  const FinanceError(this.message);
  
  @override
  List<Object> get props => [message];
}
