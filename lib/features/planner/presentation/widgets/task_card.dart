import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/task.dart';

/// Widget représentant une carte pour une tâche
class TaskCard extends StatelessWidget {
  /// La tâche à afficher
  final Task task;
  
  /// Callback appelé lorsque la tâche est cochée/décochée
  final Function(Task, bool) onTaskToggle;
  
  /// Callback appelé lorsque la tâche est éditée
  final Function(Task) onTaskEdit;
  
  /// Callback appelé lorsque la tâche est supprimée
  final Function(String) onTaskDelete;
  
  /// Constructeur
  const TaskCard({
    Key? key,
    required this.task,
    required this.onTaskToggle,
    required this.onTaskEdit,
    required this.onTaskDelete,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = task.status == TaskStatus.completed;
    
    // Couleurs basées sur la priorité
    final priorityColors = {
      TaskPriority.veryLow: Colors.grey.shade300,
      TaskPriority.low: Colors.blue.shade100,
      TaskPriority.medium: Colors.green.shade100,
      TaskPriority.high: Colors.orange.shade100,
      TaskPriority.veryHigh: Colors.red.shade100,
    };
    
    // Icônes basées sur la catégorie
    final categoryIcons = {
      TaskCategory.work: Icons.work,
      TaskCategory.personal: Icons.person,
      TaskCategory.admin: Icons.admin_panel_settings,
      TaskCategory.learning: Icons.school,
      TaskCategory.health: Icons.favorite,
      TaskCategory.meeting: Icons.people,
      TaskCategory.other: Icons.more_horiz,
    };
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2.0,
      color: priorityColors[task.priority],
      child: InkWell(
        onTap: () => onTaskEdit(task),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: isDone,
                onChanged: (value) => onTaskToggle(task, value ?? false),
              ),
              
              // Icône de catégorie
              Icon(
                categoryIcons[task.category] ?? Icons.task,
                color: theme.colorScheme.primary,
              ),
              
              const SizedBox(width: 16),
              
              // Informations de la tâche
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: isDone ? TextDecoration.lineThrough : null,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    const SizedBox(height: 8),
                    
                    // Date d'échéance et durée
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM/yyyy').format(task.dueDate),
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.timer,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${task.estimatedDuration} min',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Indicateur de priorité
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'P${task.priority.value}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Menu d'options
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit') {
                    onTaskEdit(task);
                  } else if (value == 'delete') {
                    onTaskDelete(task.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text('Supprimer'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
