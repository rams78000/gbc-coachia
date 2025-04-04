import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:gbc_coachia/features/planner/domain/repositories/event_repository.dart';

part 'planner_event.dart';
part 'planner_state.dart';

class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  final EventRepository repository;

  PlannerBloc({required this.repository}) : super(PlannerInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<LoadEventsForDate>(_onLoadEventsForDate);
    on<LoadEventsForDateRange>(_onLoadEventsForDateRange);
    on<LoadEventsByCategory>(_onLoadEventsByCategory);
    on<LoadEventsByPriority>(_onLoadEventsByPriority);
    on<AddEvent>(_onAddEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<MarkEventAsCompleted>(_onMarkEventAsCompleted);
    on<FilterEvents>(_onFilterEvents);
  }

  Future<void> _onLoadEvents(
    LoadEvents event,
    Emitter<PlannerState> emit,
  ) async {
    emit(EventsLoading());
    try {
      final events = await repository.getEvents();
      emit(EventsLoaded(events: events));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onLoadEventsForDate(
    LoadEventsForDate event,
    Emitter<PlannerState> emit,
  ) async {
    emit(EventsLoading());
    try {
      final events = await repository.getEventsByDate(event.date);
      emit(EventsLoadedForDate(
        events: events,
        selectedDate: event.date,
      ));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onLoadEventsForDateRange(
    LoadEventsForDateRange event,
    Emitter<PlannerState> emit,
  ) async {
    emit(EventsLoading());
    try {
      final events = await repository.getEventsByDateRange(
        event.startDate,
        event.endDate,
      );
      emit(EventsLoadedForDateRange(
        events: events,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onLoadEventsByCategory(
    LoadEventsByCategory event,
    Emitter<PlannerState> emit,
  ) async {
    emit(EventsLoading());
    try {
      final events = await repository.getEventsByCategory(event.category);
      emit(EventsLoadedByCategory(
        events: events,
        category: event.category,
      ));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onLoadEventsByPriority(
    LoadEventsByPriority event,
    Emitter<PlannerState> emit,
  ) async {
    emit(EventsLoading());
    try {
      final events = await repository.getEventsByPriority(event.priority);
      emit(EventsLoadedByPriority(
        events: events,
        priority: event.priority,
      ));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onAddEvent(
    AddEvent event,
    Emitter<PlannerState> emit,
  ) async {
    try {
      await repository.addEvent(event.event);
      // Recharger les événements après l'ajout
      add(LoadEvents());
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateEvent(
    UpdateEvent event,
    Emitter<PlannerState> emit,
  ) async {
    try {
      await repository.updateEvent(event.event);
      // Recharger les événements après la mise à jour
      add(LoadEvents());
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onDeleteEvent(
    DeleteEvent event,
    Emitter<PlannerState> emit,
  ) async {
    try {
      await repository.deleteEvent(event.id);
      // Recharger les événements après la suppression
      add(LoadEvents());
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onMarkEventAsCompleted(
    MarkEventAsCompleted event,
    Emitter<PlannerState> emit,
  ) async {
    try {
      await repository.markEventAsCompleted(event.id, event.isCompleted);
      // Recharger les événements après la mise à jour
      add(LoadEvents());
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onFilterEvents(
    FilterEvents event,
    Emitter<PlannerState> emit,
  ) async {
    emit(EventsLoading());
    try {
      List<Event> events = await repository.getEvents();

      // Filtrer par catégorie si spécifié
      if (event.category != null) {
        events = events.where((e) => e.category == event.category).toList();
      }

      // Filtrer par priorité si spécifié
      if (event.priority != null) {
        events = events.where((e) => e.priority == event.priority).toList();
      }

      // Filtrer par plage de dates si spécifiée
      if (event.startDate != null && event.endDate != null) {
        final eventsInDateRange = await repository.getEventsByDateRange(
          event.startDate!,
          event.endDate!,
        );
        events = events
            .where((e) => eventsInDateRange.any((er) => er.id == e.id))
            .toList();
      }

      // Filtrer par statut de complétion
      if (event.isCompleted != null) {
        events = events
            .where((e) => e.isCompleted == event.isCompleted)
            .toList();
      }

      emit(EventsFiltered(
        events: events,
        category: event.category,
        priority: event.priority,
        startDate: event.startDate,
        endDate: event.endDate,
        isCompleted: event.isCompleted,
      ));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }
}
