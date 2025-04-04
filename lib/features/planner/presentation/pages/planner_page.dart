import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:gbc_coachia/features/planner/domain/entities/task.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_bloc.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_event.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_state.dart';
import 'package:gbc_coachia/features/planner/presentation/widgets/calendar_widget.dart';
import 'package:gbc_coachia/features/planner/presentation/widgets/event_form_widget.dart';
import 'package:gbc_coachia/features/planner/presentation/widgets/optimized_plan_widget.dart';
import 'package:gbc_coachia/features/planner/presentation/widgets/task_form_widget.dart';
import 'package:gbc_coachia/features/planner/presentation/widgets/tasks_list_widget.dart';
import 'package:gbc_coachia/features/shared/presentation/widgets/main_scaffold.dart';

/// Page principale du planificateur
class PlannerPage extends StatefulWidget {
  const PlannerPage({Key? key}) : super(key: key);

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> with SingleTickerProviderStateMixin {
  // Contrôleur pour la TabBar
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    
    // Initialiser le contrôleur avec 3 onglets
    _tabController = TabController(length: 3, vsync: this);
    
    // Écouter les changements d'onglet
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Mettre à jour l'onglet actif dans le BLoC
        context.read<PlannerBloc>().add(ChangeTab(index: _tabController.index));
      }
    });
    
    // Charger les données initiales
    _loadInitialData();
  }
  
  /// Charge les données initiales pour le planificateur
  void _loadInitialData() {
    // Date actuelle
    final now = DateTime.now();
    
    // Début et fin du mois courant
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    
    // Charger les événements du mois courant
    context.read<PlannerBloc>().add(LoadEvents(
      start: firstDayOfMonth,
      end: lastDayOfMonth,
    ));
    
    // Charger les tâches
    context.read<PlannerBloc>().add(const LoadTasks());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {
        // Synchroniser le TabController avec l'état du BLoC
        if (_tabController.index != state.activeTab) {
          _tabController.animateTo(state.activeTab);
        }
        
        // Afficher les messages d'erreur
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return MainScaffold(
          title: 'Planificateur',
          body: Column(
            children: [
              // TabBar
              ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.calendar_today),
                      text: 'Calendrier',
                    ),
                    Tab(
                      icon: Icon(Icons.task_alt),
                      text: 'Tâches',
                    ),
                    Tab(
                      icon: Icon(Icons.auto_awesome),
                      text: 'Plan IA',
                    ),
                  ],
                ),
              ),
              
              // TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    // Onglet Calendrier
                    CalendarWidget(),
                    
                    // Onglet Tâches
                    TasksListWidget(),
                    
                    // Onglet Plan optimisé
                    OptimizedPlanWidget(),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: _buildFloatingActionButton(context, state),
        );
      },
    );
  }
  
  /// Construit le FAB approprié selon l'onglet actif
  Widget? _buildFloatingActionButton(BuildContext context, PlannerState state) {
    // Aucun FAB pour l'onglet Plan IA
    if (state.activeTab == 2) {
      return null;
    }
    
    // FAB pour l'onglet Calendrier
    if (state.activeTab == 0) {
      return FloatingActionButton(
        onPressed: () => _showEventForm(context),
        tooltip: 'Ajouter un événement',
        child: const Icon(Icons.add),
      );
    }
    
    // FAB pour l'onglet Tâches
    return FloatingActionButton(
      onPressed: () => _showTaskForm(context),
      tooltip: 'Ajouter une tâche',
      child: const Icon(Icons.add),
    );
  }
  
  /// Affiche le formulaire d'ajout d'événement
  void _showEventForm(BuildContext context, {Event? event}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 8,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            initialChildSize: 0.7,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: EventFormWidget(event: event),
              );
            },
          ),
        );
      },
    );
  }
  
  /// Affiche le formulaire d'ajout de tâche
  void _showTaskForm(BuildContext context, {Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 8,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            initialChildSize: 0.7,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: TaskFormWidget(task: task),
              );
            },
          ),
        );
      },
    );
  }
}
