import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/event.dart';

/// Widget représentant une carte pour un événement
class EventCard extends StatelessWidget {
  /// L'événement à afficher
  final Event event;
  
  /// Callback appelé lorsque l'événement est édité
  final Function(Event) onEventEdit;
  
  /// Callback appelé lorsque l'événement est supprimé
  final Function(String) onEventDelete;
  
  /// Constructeur
  const EventCard({
    Key? key,
    required this.event,
    required this.onEventEdit,
    required this.onEventDelete,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('HH:mm');
    
    // Couleurs basées sur la catégorie
    final categoryColors = {
      EventCategory.meeting: Colors.blue.shade100,
      EventCategory.work: Colors.orange.shade100,
      EventCategory.personal: Colors.green.shade100,
      EventCategory.health: Colors.red.shade100,
      EventCategory.social: Colors.purple.shade100,
      EventCategory.learning: Colors.teal.shade100,
      EventCategory.other: Colors.grey.shade100,
    };
    
    // Icônes basées sur la catégorie
    final categoryIcons = {
      EventCategory.meeting: Icons.people,
      EventCategory.work: Icons.work,
      EventCategory.personal: Icons.person,
      EventCategory.health: Icons.favorite,
      EventCategory.social: Icons.celebration,
      EventCategory.learning: Icons.school,
      EventCategory.other: Icons.more_horiz,
    };
    
    // Calcul de la durée
    final duration = event.end.difference(event.start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final durationText = hours > 0 
        ? '$hours h ${minutes > 0 ? '$minutes min' : ''}'
        : '$minutes min';
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2.0,
      color: categoryColors[event.category],
      child: InkWell(
        onTap: () => onEventEdit(event),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icône de catégorie
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  categoryIcons[event.category] ?? Icons.event,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Informations de l'événement
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      event.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    if (event.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    const SizedBox(height: 8),
                    
                    // Horaire et durée
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${timeFormat.format(event.start)} - ${timeFormat.format(event.end)}',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.timelapse,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          durationText,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    
                    // Lieu (si présent)
                    if (event.location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location,
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Menu d'options
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEventEdit(event);
                  } else if (value == 'delete') {
                    onEventDelete(event.id);
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
