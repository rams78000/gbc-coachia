import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'planner_event.dart';
part 'planner_state.dart';

class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  PlannerBloc() : super(PlannerInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }
  
  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<PlannerState> emit,
  ) async {
    emit(PlannerLoading());
    
    // TODO: Implement task loading from repository
    
    emit(PlannerLoaded(tasks: []));
  }
  
  Future<void> _onAddTask(
    AddTask event,
    Emitter<PlannerState> emit,
  ) async {
    // TODO: Implement add task
  }
  
  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<PlannerState> emit,
  ) async {
    // TODO: Implement update task
  }
  
  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<PlannerState> emit,
  ) async {
    // TODO: Implement delete task
  }
}
