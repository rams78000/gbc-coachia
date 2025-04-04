import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/planner/domain/repositories/planner_repository.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_event.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_state.dart';

/// BLoC pour la gestion du planificateur
class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  final PlannerRepository repository;

  PlannerBloc({required this.repository}) : super(PlannerState.initial()) {
    // Gestion des événements du calendrier
    on<LoadEvents>(_onLoadEvents);
    on<SaveEvent>(_onSaveEvent);
    on<DeleteEvent>(_onDeleteEvent);
    
    // Gestion des tâches
    on<LoadTasks>(_onLoadTasks);
    on<SaveTask>(_onSaveTask);
    on<DeleteTask>(_onDeleteTask);
    on<CompleteTask>(_onCompleteTask);
    
    // Gestion du plan optimisé
    on<GenerateOptimizedPlan>(_onGenerateOptimizedPlan);
    
    // Gestion de l'interface
    on<ChangeTab>(_onChangeTab);
    on<ChangeMonth>(_onChangeMonth);
    on<ChangeView>(_onChangeView);
  }

  /// Charge les événements pour une période donnée
  Future<void> _onLoadEvents(LoadEvents event, Emitter<PlannerState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      final events = await repository.getEvents(event.start, event.end);
      
      emit(state.copyWith(
        events: events,
        startDate: event.start,
        endDate: event.end,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement des événements: ${e.toString()}',
      ));
    }
  }

  /// Sauvegarde un événement
  Future<void> _onSaveEvent(SaveEvent event, Emitter<PlannerState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      await repository.saveEvent(event.event);
      
      // Recharger les événements si nous avons une période définie
      if (state.startDate != null && state.endDate != null) {
        final events = await repository.getEvents(state.startDate!, state.endDate!);
        emit(state.copyWith(events: events, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la sauvegarde de l\'événement: ${e.toString()}',
      ));
    }
  }

  /// Supprime un événement
  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<PlannerState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      await repository.deleteEvent(event.id);
      
      // Recharger les événements si nous avons une période définie
      if (state.startDate != null && state.endDate != null) {
        final events = await repository.getEvents(state.startDate!, state.endDate!);
        emit(state.copyWith(events: events, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la suppression de l\'événement: ${e.toString()}',
      ));
    }
  }

  /// Charge toutes les tâches
  Future<void> _onLoadTasks(LoadTasks event, Emitter<PlannerState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      final tasks = await repository.getTasks();
      
      emit(state.copyWith(
        tasks: tasks,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement des tâches: ${e.toString()}',
      ));
    }
  }

  /// Sauvegarde une tâche
  Future<void> _onSaveTask(SaveTask event, Emitter<PlannerState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      await repository.saveTask(event.task);
      
      // Recharger les tâches
      final tasks = await repository.getTasks();
      emit(state.copyWith(tasks: tasks, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la sauvegarde de la tâche: ${e.toString()}',
      ));
    }
  }

  /// Supprime une tâche
  Future<void> _onDeleteTask(DeleteTask event, Emitter<PlannerState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      await repository.deleteTask(event.id);
      
      // Recharger les tâches
      final tasks = await repository.getTasks();
      emit(state.copyWith(tasks: tasks, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la suppression de la tâche: ${e.toString()}',
      ));
    }
  }

  /// Marque une tâche comme terminée
  Future<void> _onCompleteTask(CompleteTask event, Emitter<PlannerState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      await repository.completeTask(event.id);
      
      // Recharger les tâches
      final tasks = await repository.getTasks();
      emit(state.copyWith(tasks: tasks, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la complétion de la tâche: ${e.toString()}',
      ));
    }
  }

  /// Génère un plan optimisé
  Future<void> _onGenerateOptimizedPlan(GenerateOptimizedPlan event, Emitter<PlannerState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      final plan = await repository.generateOptimizedPlan(event.date);
      
      emit(state.copyWith(
        optimizedPlan: plan,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la génération du plan optimisé: ${e.toString()}',
      ));
    }
  }

  /// Change l'onglet actif
  void _onChangeTab(ChangeTab event, Emitter<PlannerState> emit) {
    emit(state.copyWith(activeTab: event.index));
  }

  /// Change le mois affiché
  void _onChangeMonth(ChangeMonth event, Emitter<PlannerState> emit) {
    emit(state.copyWith(currentMonth: event.month));
    
    // Charger les événements pour le nouveau mois
    final firstDay = DateTime(event.month.year, event.month.month, 1);
    final lastDay = DateTime(event.month.year, event.month.month + 1, 0);
    add(LoadEvents(start: firstDay, end: lastDay));
  }

  /// Change la vue du calendrier
  void _onChangeView(ChangeView event, Emitter<PlannerState> emit) {
    DateTime start;
    DateTime end;
    
    // Calculer les dates de début et de fin selon la vue
    switch (event.view) {
      case 'day':
        start = DateTime(state.currentMonth.year, state.currentMonth.month, state.currentMonth.day);
        end = start.add(const Duration(days: 1));
        break;
      case 'week':
        // Trouver le premier jour de la semaine (lundi)
        final day = state.currentMonth;
        start = day.subtract(Duration(days: day.weekday - 1));
        end = start.add(const Duration(days: 7));
        break;
      case 'month':
      default:
        start = DateTime(state.currentMonth.year, state.currentMonth.month, 1);
        end = DateTime(state.currentMonth.year, state.currentMonth.month + 1, 0);
        break;
    }
    
    emit(state.copyWith(currentView: event.view));
    add(LoadEvents(start: start, end: end));
  }
}
