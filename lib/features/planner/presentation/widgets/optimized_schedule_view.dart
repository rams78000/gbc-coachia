import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/optimized_schedule.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/event.dart';

/// Widget affichant un planning optimisé
class OptimizedScheduleView extends StatelessWidget {
  /// Planning optimisé à afficher
  final OptimizedSchedule schedule;
  
  /// Date sélectionnée
  final DateTime selectedDate;
  
  /// Callback lorsqu'un événement est sélectionné
  final Function(Event) onEventTap;
  
  /// Callback lorsqu'une tâche est sélectionnée
  final Function(Task) onTaskTap;
  
  /// Constructeur
  const OptimizedScheduleView({
    Key? key,
    required this.schedule,
    required this.selectedDate,
    required this.onEventTap,
    required this.onTaskTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Planning optimisé',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMMEEEEd('fr_FR').format(selectedDate).capitalize(),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              Chip(
                avatar: const Icon(
                  Icons.settings,
                  size: 16,
                ),
                label: Text(
                  _getStrategyLabel(schedule.strategy),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        
        // Conseils
        if (schedule.tips.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              color: theme.colorScheme.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Conseils pour optimiser votre journée',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...schedule.tips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(child: Text(tip)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        
        const SizedBox(height: 8),
        
        // Statistiques
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildStatCard(
                context,
                'Productivité estimée',
                '${schedule.estimatedProductivity.toStringAsFixed(0)}%',
                Icons.speed,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                'Temps de pause',
                '${schedule.totalBreakTime} min',
                Icons.coffee,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                'Score d\'équilibre',
                '${schedule.balanceScore.toStringAsFixed(1)}/10',
                Icons.balance,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Timeline
        Expanded(
          child: ListView.builder(
            itemCount: schedule.timeBlocks.length,
            itemBuilder: (context, index) {
              final block = schedule.timeBlocks[index];
              return _buildTimeBlock(context, block, index);
            },
          ),
        ),
      ],
    );
  }
  
  /// Construit une carte de statistique
  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Construit un bloc de temps
  Widget _buildTimeBlock(BuildContext context, TimeBlock block, int index) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('HH:mm');
    
    // Couleurs pour différents types de blocs
    final blockColors = {
      TimeBlockType.task: theme.colorScheme.primary.withOpacity(0.1),
      TimeBlockType.event: Colors.orange.withOpacity(0.1),
      TimeBlockType.break: Colors.green.withOpacity(0.1),
      TimeBlockType.focusTime: Colors.purple.withOpacity(0.1),
    };
    
    // Icônes pour différents types de blocs
    final blockIcons = {
      TimeBlockType.task: Icons.task,
      TimeBlockType.event: Icons.event,
      TimeBlockType.break: Icons.coffee,
      TimeBlockType.focusTime: Icons.notifications_off,
    };
    
    // Bordure de connexion
    final isFirst = index == 0;
    final isLast = index == schedule.timeBlocks.length - 1;
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline verticale
          SizedBox(
            width: 70,
            child: Column(
              children: [
                // Heure de début
                Text(
                  timeFormat.format(block.start),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                // Ligne verticale
                Expanded(
                  child: Center(
                    child: Container(
                      width: 1,
                      color: theme.dividerColor,
                    ),
                  ),
                ),
                
                // Heure de fin (seulement pour le dernier bloc)
                if (isLast)
                  Text(
                    timeFormat.format(block.end),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          
          // Contenu du bloc
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: 8,
                top: isFirst ? 0 : 8,
                right: 16,
                bottom: isLast ? 0 : 8,
              ),
              decoration: BoxDecoration(
                color: blockColors[block.type] ?? theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.dividerColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête du bloc
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(7),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: theme.dividerColor,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          blockIcons[block.type],
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getBlockTypeLabel(block.type),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${block.durationMinutes} min',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  
                  // Contenu du bloc
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (block.title.isNotEmpty)
                          Text(
                            block.title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                        if (block.description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(block.description),
                        ],
                        
                        if (block.relatedTaskId != null || block.relatedEventId != null) ...[
                          const SizedBox(height: 8),
                          _buildRelatedItem(context, block),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Construit un élément lié (tâche ou événement)
  Widget _buildRelatedItem(BuildContext context, TimeBlock block) {
    final theme = Theme.of(context);
    
    // Si lié à une tâche
    if (block.relatedTaskId != null) {
      final task = schedule.tasks.firstWhere(
        (t) => t.id == block.relatedTaskId,
        orElse: () => Task(
          id: '',
          title: 'Tâche non trouvée',
          description: '',
          dueDate: DateTime.now(),
          estimatedDuration: 0,
          priority: TaskPriority.medium,
          status: TaskStatus.pending,
          category: TaskCategory.other,
        ),
      );
      
      return InkWell(
        onTap: () => onTaskTap(task),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.task,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (task.description.isNotEmpty)
                      Text(
                        task.description,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Si lié à un événement
    if (block.relatedEventId != null) {
      final event = schedule.events.firstWhere(
        (e) => e.id == block.relatedEventId,
        orElse: () => Event(
          id: '',
          title: 'Événement non trouvé',
          description: '',
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(hours: 1)),
          category: EventCategory.other,
          location: '',
        ),
      );
      
      return InkWell(
        onTap: () => onEventTap(event),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.05),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.orange.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.event,
                size: 16,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (event.location.isNotEmpty)
                      Text(
                        event.location,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
  
  /// Obtient le libellé pour une stratégie
  String _getStrategyLabel(OptimizationStrategy strategy) {
    switch (strategy) {
      case OptimizationStrategy.productivity:
        return 'Stratégie: Productivité maximale';
      case OptimizationStrategy.balance:
        return 'Stratégie: Équilibre travail-vie';
      case OptimizationStrategy.energy:
        return 'Stratégie: Gestion d\'énergie';
    }
  }
  
  /// Obtient le libellé pour un type de bloc
  String _getBlockTypeLabel(TimeBlockType type) {
    switch (type) {
      case TimeBlockType.task:
        return 'Tâche';
      case TimeBlockType.event:
        return 'Événement';
      case TimeBlockType.break:
        return 'Pause';
      case TimeBlockType.focusTime:
        return 'Temps de concentration';
    }
  }
}

/// Extension pour capitaliser une chaîne
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
