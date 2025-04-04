import 'package:flutter/material.dart';
import 'package:gbc_coachai/features/planner/domain/models/calendar_event.dart';
import 'package:intl/intl.dart';

class UpcomingEventsCard extends StatelessWidget {
  final List<CalendarEvent> events;
  final VoidCallback onTap;
  final VoidCallback onAddEvent;

  const UpcomingEventsCard({
    Key? key,
    required this.events,
    required this.onTap,
    required this.onAddEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.event,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Événements à venir',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: theme.colorScheme.secondary,
                        ),
                        onPressed: onAddEvent,
                        tooltip: 'Ajouter un événement',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Events List
            SizedBox(
              height: 280,
              child: events.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: events.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return _buildEventItem(context, events[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun événement à venir',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Votre emploi du temps est libre',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAddEvent,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter un événement'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, CalendarEvent event) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('E d MMM', 'fr_FR');
    final timeFormat = DateFormat('HH:mm', 'fr_FR');
    
    // Determine if event is today
    final now = DateTime.now();
    final isToday = event.start.year == now.year &&
        event.start.month == now.month &&
        event.start.day == now.day;
    
    // Determine if it's tomorrow
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final isTomorrow = event.start.year == tomorrow.year &&
        event.start.month == tomorrow.month &&
        event.start.day == tomorrow.day;
    
    // Format date text
    String dateText;
    if (isToday) {
      dateText = "Aujourd'hui";
    } else if (isTomorrow) {
      dateText = "Demain";
    } else {
      dateText = dateFormat.format(event.start);
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time indicator
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isToday
                    ? Colors.blue[100]
                    : isTomorrow
                        ? Colors.purple[100]
                        : Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                dateText,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isToday
                      ? Colors.blue[800]
                      : isTomorrow
                          ? Colors.purple[800]
                          : Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeFormat.format(event.start),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            if (event.end != null) ...[
              const SizedBox(height: 2),
              Text(
                timeFormat.format(event.end!),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
        
        const SizedBox(width: 12),
        
        // Vertical line
        Container(
          width: 2,
          height: 65,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: _getCategoryColor(event.category),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Event details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (event.description.isNotEmpty)
                Text(
                  event.description,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    _getCategoryIcon(event.category),
                    size: 14,
                    color: _getCategoryColor(event.category),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getCategoryName(event.category),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getCategoryColor(event.category),
                    ),
                  ),
                  if (event.location.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'client':
      case 'clients':
        return Colors.blue;
      case 'meeting':
      case 'réunion':
      case 'reunion':
        return Colors.purple;
      case 'deadline':
      case 'échéance':
      case 'echeance':
        return Colors.red;
      case 'task':
      case 'tâche':
      case 'tache':
        return Colors.orange;
      case 'reminder':
      case 'rappel':
        return Colors.amber;
      case 'personal':
      case 'personnel':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'client':
      case 'clients':
        return Icons.person;
      case 'meeting':
      case 'réunion':
      case 'reunion':
        return Icons.groups;
      case 'deadline':
      case 'échéance':
      case 'echeance':
        return Icons.timer;
      case 'task':
      case 'tâche':
      case 'tache':
        return Icons.check_circle;
      case 'reminder':
      case 'rappel':
        return Icons.notifications;
      case 'personal':
      case 'personnel':
        return Icons.person_pin;
      default:
        return Icons.event;
    }
  }

  String _getCategoryName(String category) {
    switch (category.toLowerCase()) {
      case 'client':
      case 'clients':
        return 'Client';
      case 'meeting':
      case 'réunion':
      case 'reunion':
        return 'Réunion';
      case 'deadline':
      case 'échéance':
      case 'echeance':
        return 'Échéance';
      case 'task':
      case 'tâche':
      case 'tache':
        return 'Tâche';
      case 'reminder':
      case 'rappel':
        return 'Rappel';
      case 'personal':
      case 'personnel':
        return 'Personnel';
      default:
        return category;
    }
  }
}
