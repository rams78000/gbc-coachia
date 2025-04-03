import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'finance_event.dart';
part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc() : super(FinanceInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<LoadBudget>(_onLoadBudget);
    on<UpdateBudget>(_onUpdateBudget);
  }
  
  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    
    // TODO: Implement transaction loading
    
    emit(FinanceLoaded(transactions: []));
  }
  
  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    // TODO: Implement add transaction
  }
  
  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    // TODO: Implement update transaction
  }
  
  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<FinanceState> emit,
  ) async {
    // TODO: Implement delete transaction
  }
  
  Future<void> _onLoadBudget(
    LoadBudget event,
    Emitter<FinanceState> emit,
  ) async {
    // TODO: Implement load budget
  }
  
  Future<void> _onUpdateBudget(
    UpdateBudget event,
    Emitter<FinanceState> emit,
  ) async {
    // TODO: Implement update budget
  }
}
