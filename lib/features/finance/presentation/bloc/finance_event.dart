part of 'finance_bloc.dart';

abstract class FinanceEvent extends Equatable {
  const FinanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends FinanceEvent {}

class LoadTransactionsByType extends FinanceEvent {
  final TransactionType type;

  const LoadTransactionsByType(this.type);

  @override
  List<Object> get props => [type];
}

class LoadTransactionsByDateRange extends FinanceEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadTransactionsByDateRange({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

class AddTransaction extends FinanceEvent {
  final Transaction transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class UpdateTransaction extends FinanceEvent {
  final Transaction transaction;

  const UpdateTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteTransaction extends FinanceEvent {
  final String id;

  const DeleteTransaction(this.id);

  @override
  List<Object> get props => [id];
}

class CalculateFinancialSummary extends FinanceEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const CalculateFinancialSummary({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
