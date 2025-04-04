import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/planner/domain/entities/task.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_bloc.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_event.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_state.dart';
import 'package:intl/intl.dart';

/// Widget pour afficher et gérer les tâches
class TasksListWidget extends StatelessWidget {
  const TasksListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlannerBloc, PlannerState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Filtres et contrôles
            _buildTasksHeader(context, state),
            
            // Liste des tâches
            Expanded(
              child: state.tasks.isEmpty
                  ? _buildEmptyState(context)
                  : _buildTasksList(context, state),
            ),
            
            // Bouton d'ajout de tâche
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Ajouter une tâche'),
                onPressed: () {
                  // TODO: Ouvrir le formulaire d'ajout de tâche
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Construit l'en-tête avec les contrôles et filtres
  Widget _buildTasksHeader(BuildContext context, PlannerState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes tâches',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          
          // Filtres (statut, priorité, etc.)
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('Toutes'),
                selected: true,
                onSelected: (selected) {
                  // TODO: Implémenter le filtre
                },
              ),
              FilterChip(
                label: const Text('En attente'),
                selected: false,
                onSelected: (selected) {
                  // TODO: Implémenter le filtre
                },
              ),
              FilterChip(
                label: const Text('En cours'),
                selected: false,
                onSelected: (selected) {
                  // TODO: Implémenter le filtre
                },
              ),
              FilterChip(
                label: const Text('Terminées'),
                selected: false,
                onSelected: (selected) {
                  // TODO: Implémenter le filtre
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit l'état vide (aucune tâche)
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 70,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune tâche pour le moment',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre première tâche en cliquant sur le bouton ci-dessous',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la liste des tâches
  Widget _buildTasksList(BuildContext context, PlannerState state) {
    // Trier les tâches par priorité, puis par statut
    final sortedTasks = List<Task>.from(state.tasks);
    sortedTasks.sort((a, b) {
      // D'abord par statut (en attente et en cours en premier)
      if (a.status != b.status) {
        if (a.status == TaskStatus.completed || a.status == TaskStatus.cancelled) {
          return 1;
        }
        if (b.status == TaskStatus.completed || b.status == TaskStatus.cancelled) {
          return -1;
        }
      }
      
      // Ensuite par priorité (décroissante)
      int priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;
      
      // Enfin par date d'échéance (croissante)
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      } else if (a.dueDate != null) {
        return -1;
      } else if (b.dueDate != null) {
        return 1;
      }
      
      return 0;
    });
    
    // Regrouper les tâches par catégorie
    Map<String, List<Task>> tasksByCategory = {};
    
    for (final task in sortedTasks) {
      if (!tasksByCategory.containsKey(task.category)) {
        tasksByCategory[task.category] = [];
      }
      tasksByCategory[task.category]!.add(task);
    }
    
    return ListView.builder(
      itemCount: tasksByCategory.length,
      itemBuilder: (context, categoryIndex) {
        final category = tasksByCategory.keys.elementAt(categoryIndex);
        final tasksInCategory = tasksByCategory[category]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de la catégorie
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                category,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Tâches de cette catégorie
            ...tasksInCategory.map((task) => _buildTaskCard(context, task)).toList(),
            
            // Séparateur
            if (categoryIndex < tasksByCategory.length - 1)
              const Divider(height: 32, indent: 16, endIndent: 16),
          ],
        );
      },
    );
  }

  /// Construit une carte pour une tâche
  Widget _buildTaskCard(BuildContext context, Task task) {
    // Couleurs selon le statut
    Color statusColor;
    switch (task.status) {
      case TaskStatus.pending:
        statusColor = Colors.orange;
        break;
      case TaskStatus.inProgress:
        statusColor = Colors.blue;
        break;
      case TaskStatus.completed:
        statusColor = Colors.green;
        break;
      case TaskStatus.cancelled:
        statusColor = Colors.grey;
        break;
    }
    
    // Texte du statut
    String statusText;
    switch (task.status) {
      case TaskStatus.pending:
        statusText = 'En attente';
        break;
      case TaskStatus.inProgress:
        statusText = 'En cours';
        break;
      case TaskStatus.completed:
        statusText = 'Terminée';
        break;
      case TaskStatus.cancelled:
        statusText = 'Annulée';
        break;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Ouvrir le formulaire de modification de tâche
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Case à cocher pour marquer comme terminée
                  if (task.status != TaskStatus.completed && task.status != TaskStatus.cancelled)
                    Checkbox(
                      value: false,
                      onChanged: (value) {
                        if (value == true) {
                          context.read<PlannerBloc>().add(CompleteTask(id: task.id));
                        }
                      },
                    )
                  else
                    const SizedBox(width: 44), // Pour l'alignement
                  
                  // Titre de la tâche
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: task.status == TaskStatus.completed || task.status == TaskStatus.cancelled
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.status == TaskStatus.completed || task.status == TaskStatus.cancelled
                            ? Colors.grey[600]
                            : null,
                      ),
                    ),
                  ),
                  
                  // Indicateur de priorité
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(task.priority).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'P${task.priority}',
                      style: TextStyle(
                        color: _getPriorityColor(task.priority),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 44),
                  child: Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: task.status == TaskStatus.completed || task.status == TaskStatus.cancelled
                          ? Colors.grey[600]
                          : null,
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 44),
                child: Row(
                  children: [
                    // Statut
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Date d'échéance
                    if (task.dueDate != null) ...[
                      Icon(
                        Icons.event,
                        size: 14,
                        color: _isOverdue(task) ? Colors.red : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('d MMM', 'fr_FR').format(task.dueDate!),
                        style: TextStyle(
                          color: _isOverdue(task) ? Colors.red : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                    
                    const SizedBox(width: 8),
                    
                    // Temps estimé
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDuration(task.estimatedDuration),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Retourne la couleur associée à une priorité
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 5:
        return Colors.red;
      case 4:
        return Colors.deepOrange;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.amber;
      case 1:
      default:
        return Colors.green;
    }
  }

  /// Vérifie si une tâche est en retard
  bool _isOverdue(Task task) {
    if (task.dueDate == null || task.status == TaskStatus.completed || task.status == TaskStatus.cancelled) {
      return false;
    }
    
    final now = DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return task.dueDate!.isBefore(todayEnd);
  }

  /// Formate une durée en minutes en un texte lisible
  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      
      if (remainingMinutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h${remainingMinutes}';
      }
    }
  }
}
