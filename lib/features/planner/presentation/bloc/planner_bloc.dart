import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/planner_repository.dart';

/// Événements pour le bloc planificateur
abstract class PlannerEvent extends Equatable {
  /// Constructeur
  const PlannerEvent();

  @override
  List<Object> get props => [];
}

/// Événement pour charger tous les événements
class LoadEvents extends PlannerEvent {
  /// Constructeur
  const LoadEvents();
}

/// Événement pour ajouter un nouvel événement
class AddEvent extends PlannerEvent {
  /// L'événement à ajouter
  final PlanEvent event;

  /// Constructeur
  const AddEvent(this.event);

  @override
  List<Object> get props => [event];
}

/// Événement pour mettre à jour un événement existant
class UpdateEvent extends PlannerEvent {
  /// L'événement à mettre à jour
  final PlanEvent event;

  /// Constructeur
  const UpdateEvent(this.event);

  @override
  List<Object> get props => [event];
}

/// Événement pour supprimer un événement
class DeleteEvent extends PlannerEvent {
  /// L'identifiant de l'événement à supprimer
  final String id;

  /// Constructeur
  const DeleteEvent(this.id);

  @override
  List<Object> get props => [id];
}

/// États pour le bloc planificateur
abstract class PlannerState extends Equatable {
  /// Constructeur
  const PlannerState();

  @override
  List<Object> get props => [];
}

/// État initial du planificateur
class PlannerInitial extends PlannerState {}

/// État de chargement des événements
class PlannerLoading extends PlannerState {}

/// État lorsque les événements sont chargés
class PlannerLoaded extends PlannerState {
  /// Liste des événements
  final List<PlanEvent> events;

  /// Constructeur
  const PlannerLoaded(this.events);

  @override
  List<Object> get props => [events];
}

/// État d'erreur du planificateur
class PlannerError extends PlannerState {
  /// Message d'erreur
  final String message;

  /// Constructeur
  const PlannerError(this.message);

  @override
  List<Object> get props => [message];
}

/// Bloc gérant le planificateur
class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  final PlannerRepository _plannerRepository;

  /// Constructeur
  PlannerBloc({required PlannerRepository plannerRepository})
      : _plannerRepository = plannerRepository,
        super(PlannerInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<AddEvent>(_onAddEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onLoadEvents(
    LoadEvents event,
    Emitter<PlannerState> emit,
  ) async {
    emit(PlannerLoading());
    try {
      final events = await _plannerRepository.getEvents();
      emit(PlannerLoaded(events));
    } catch (e) {
      emit(PlannerError(e.toString()));
    }
  }

  Future<void> _onAddEvent(
    AddEvent event,
    Emitter<PlannerState> emit,
  ) async {
    emit(PlannerLoading());
    try {
      await _plannerRepository.addEvent(event.event);
      final events = await _plannerRepository.getEvents();
      emit(PlannerLoaded(events));
    } catch (e) {
      emit(PlannerError(e.toString()));
    }
  }

  Future<void> _onUpdateEvent(
    UpdateEvent event,
    Emitter<PlannerState> emit,
  ) async {
    emit(PlannerLoading());
    try {
      await _plannerRepository.updateEvent(event.event);
      final events = await _plannerRepository.getEvents();
      emit(PlannerLoaded(events));
    } catch (e) {
      emit(PlannerError(e.toString()));
    }
  }

  Future<void> _onDeleteEvent(
    DeleteEvent event,
    Emitter<PlannerState> emit,
  ) async {
    emit(PlannerLoading());
    try {
      await _plannerRepository.deleteEvent(event.id);
      final events = await _plannerRepository.getEvents();
      emit(PlannerLoaded(events));
    } catch (e) {
      emit(PlannerError(e.toString()));
    }
  }
}
