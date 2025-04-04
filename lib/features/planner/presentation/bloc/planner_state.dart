import 'package:equatable/equatable.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:gbc_coachia/features/planner/domain/entities/optimized_plan.dart';
import 'package:gbc_coachia/features/planner/domain/entities/task.dart';

/// États du BLoC Planner
class PlannerState extends Equatable {
  /// Liste des événements actuellement chargés
  final List<Event> events;
  
  /// Liste des tâches actuellement chargées
  final List<Task> tasks;
  
  /// Plan optimisé actuel
  final OptimizedPlan? optimizedPlan;
  
  /// Date de début de la période actuelle
  final DateTime? startDate;
  
  /// Date de fin de la période actuelle
  final DateTime? endDate;
  
  /// Mois actuellement affiché
  final DateTime currentMonth;
  
  /// Vue actuelle du calendrier ('day', 'week', 'month')
  final String currentView;
  
  /// Onglet actif (0 = Calendrier, 1 = Tâches, 2 = Plan optimisé)
  final int activeTab;
  
  /// Indique si des données sont en cours de chargement
  final bool isLoading;
  
  /// Message d'erreur éventuel
  final String? errorMessage;
  
  /// Constructeur
  const PlannerState({
    this.events = const [],
    this.tasks = const [],
    this.optimizedPlan,
    this.startDate,
    this.endDate,
    required this.currentMonth,
    this.currentView = 'month',
    this.activeTab = 0,
    this.isLoading = false,
    this.errorMessage,
  });
  
  /// État initial
  factory PlannerState.initial() {
    return PlannerState(
      currentMonth: DateTime.now(),
    );
  }
  
  /// Méthode pour créer une copie de l'état avec des modifications
  PlannerState copyWith({
    List<Event>? events,
    List<Task>? tasks,
    OptimizedPlan? optimizedPlan,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? currentMonth,
    String? currentView,
    int? activeTab,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PlannerState(
      events: events ?? this.events,
      tasks: tasks ?? this.tasks,
      optimizedPlan: optimizedPlan ?? this.optimizedPlan,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentMonth: currentMonth ?? this.currentMonth,
      currentView: currentView ?? this.currentView,
      activeTab: activeTab ?? this.activeTab,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [
    events, 
    tasks, 
    optimizedPlan, 
    startDate, 
    endDate, 
    currentMonth, 
    currentView,
    activeTab,
    isLoading, 
    errorMessage,
  ];
}
