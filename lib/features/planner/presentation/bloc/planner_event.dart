part of 'planner_bloc.dart';

abstract class PlannerEvent extends Equatable {
  const PlannerEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends PlannerEvent {}

class AddTask extends PlannerEvent {
  final Map<String, dynamic> task;
  
  const AddTask({required this.task});
  
  @override
  List<Object> get props => [task];
}

class UpdateTask extends PlannerEvent {
  final String taskId;
  final Map<String, dynamic> updates;
  
  const UpdateTask({
    required this.taskId,
    required this.updates,
  });
  
  @override
  List<Object> get props => [taskId, updates];
}

class DeleteTask extends PlannerEvent {
  final String taskId;
  
  const DeleteTask({required this.taskId});
  
  @override
  List<Object> get props => [taskId];
}
