part of 'finance_bloc.dart';

abstract class FinanceEvent extends Equatable {
  const FinanceEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends FinanceEvent {}

class AddTransaction extends FinanceEvent {
  final Map<String, dynamic> transaction;
  
  const AddTransaction({required this.transaction});
  
  @override
  List<Object> get props => [transaction];
}

class UpdateTransaction extends FinanceEvent {
  final String transactionId;
  final Map<String, dynamic> updates;
  
  const UpdateTransaction({
    required this.transactionId,
    required this.updates,
  });
  
  @override
  List<Object> get props => [transactionId, updates];
}

class DeleteTransaction extends FinanceEvent {
  final String transactionId;
  
  const DeleteTransaction({required this.transactionId});
  
  @override
  List<Object> get props => [transactionId];
}

class LoadBudget extends FinanceEvent {}

class UpdateBudget extends FinanceEvent {
  final Map<String, dynamic> budget;
  
  const UpdateBudget({required this.budget});
  
  @override
  List<Object> get props => [budget];
}
