part of 'planner_bloc.dart';

abstract class PlannerState extends Equatable {
  const PlannerState();
  
  @override
  List<Object?> get props => [];
}

class PlannerInitial extends PlannerState {}

class EventsLoading extends PlannerState {}

class EventsLoaded extends PlannerState {
  final List<Event> events;

  const EventsLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class EventsLoadedForDate extends PlannerState {
  final List<Event> events;
  final DateTime selectedDate;

  const EventsLoadedForDate({
    required this.events,
    required this.selectedDate,
  });

  @override
  List<Object> get props => [events, selectedDate];
}

class EventsLoadedForDateRange extends PlannerState {
  final List<Event> events;
  final DateTime startDate;
  final DateTime endDate;

  const EventsLoadedForDateRange({
    required this.events,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [events, startDate, endDate];
}

class EventsLoadedByCategory extends PlannerState {
  final List<Event> events;
  final EventCategory category;

  const EventsLoadedByCategory({
    required this.events,
    required this.category,
  });

  @override
  List<Object> get props => [events, category];
}

class EventsLoadedByPriority extends PlannerState {
  final List<Event> events;
  final EventPriority priority;

  const EventsLoadedByPriority({
    required this.events,
    required this.priority,
  });

  @override
  List<Object> get props => [events, priority];
}

class EventsFiltered extends PlannerState {
  final List<Event> events;
  final EventCategory? category;
  final EventPriority? priority;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isCompleted;

  const EventsFiltered({
    required this.events,
    this.category,
    this.priority,
    this.startDate,
    this.endDate,
    this.isCompleted,
  });

  @override
  List<Object?> get props => [
    events,
    category,
    priority,
    startDate,
    endDate,
    isCompleted,
  ];
}

class EventsError extends PlannerState {
  final String message;

  const EventsError({required this.message});

  @override
  List<Object> get props => [message];
}
