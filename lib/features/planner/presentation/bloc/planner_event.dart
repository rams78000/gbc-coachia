part of 'planner_bloc.dart';

abstract class PlannerEvent extends Equatable {
  const PlannerEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvents extends PlannerEvent {}

class LoadEventsForDate extends PlannerEvent {
  final DateTime date;

  const LoadEventsForDate(this.date);

  @override
  List<Object> get props => [date];
}

class LoadEventsForDateRange extends PlannerEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadEventsForDateRange({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

class LoadEventsByCategory extends PlannerEvent {
  final EventCategory category;

  const LoadEventsByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class LoadEventsByPriority extends PlannerEvent {
  final EventPriority priority;

  const LoadEventsByPriority(this.priority);

  @override
  List<Object> get props => [priority];
}

class AddEvent extends PlannerEvent {
  final Event event;

  const AddEvent(this.event);

  @override
  List<Object> get props => [event];
}

class UpdateEvent extends PlannerEvent {
  final Event event;

  const UpdateEvent(this.event);

  @override
  List<Object> get props => [event];
}

class DeleteEvent extends PlannerEvent {
  final String id;

  const DeleteEvent(this.id);

  @override
  List<Object> get props => [id];
}

class MarkEventAsCompleted extends PlannerEvent {
  final String id;
  final bool isCompleted;

  const MarkEventAsCompleted({
    required this.id,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [id, isCompleted];
}

class FilterEvents extends PlannerEvent {
  final EventCategory? category;
  final EventPriority? priority;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isCompleted;

  const FilterEvents({
    this.category,
    this.priority,
    this.startDate,
    this.endDate,
    this.isCompleted,
  });

  @override
  List<Object?> get props => [
    category,
    priority,
    startDate,
    endDate,
    isCompleted,
  ];
}
