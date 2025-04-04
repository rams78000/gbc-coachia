import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/event.dart';
import '../../domain/entities/task.dart';
import '../bloc/planner_event.dart';

/// Widget représentant une vue de calendrier
class CalendarView extends StatelessWidget {
  /// Liste des tâches à afficher
  final List<Task> tasks;
  
  /// Liste des événements à afficher
  final List<Event> events;
  
  /// Date actuellement sélectionnée
  final DateTime selectedDate;
  
  /// Type de vue du calendrier
  final CalendarViewType viewType;
  
  /// Callback appelé lorsqu'une date est sélectionnée
  final Function(DateTime) onDateSelected;
  
  /// Callback appelé lorsque le type de vue change
  final Function(CalendarViewType) onViewTypeChanged;
  
  /// Callback appelé lorsqu'un événement est sélectionné
  final Function(Event) onEventTap;
  
  /// Callback appelé lorsqu'une tâche est sélectionnée
  final Function(Task) onTaskTap;
  
  /// Constructeur
  const CalendarView({
    Key? key,
    required this.tasks,
    required this.events,
    required this.selectedDate,
    required this.viewType,
    required this.onDateSelected,
    required this.onViewTypeChanged,
    required this.onEventTap,
    required this.onTaskTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Barre d'outils du calendrier
        _buildCalendarToolbar(context),
        
        const SizedBox(height: 8),
        
        // Vue du calendrier
        Expanded(
          child: viewType == CalendarViewType.day
              ? _buildDayView(context)
              : viewType == CalendarViewType.week
                  ? _buildWeekView(context)
                  : _buildMonthView(context),
        ),
      ],
    );
  }
  
  /// Construit la barre d'outils du calendrier
  Widget _buildCalendarToolbar(BuildContext context) {
    final theme = Theme.of(context);
    
    String title;
    final dateFormat = DateFormat.yMMMM('fr_FR');
    final dayFormat = DateFormat.EEEE('fr_FR');
    
    if (viewType == CalendarViewType.day) {
      title = '${dayFormat.format(selectedDate).capitalize()} ${DateFormat.d('fr_FR').format(selectedDate)} ${dateFormat.format(selectedDate)}';
    } else if (viewType == CalendarViewType.week) {
      final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      
      if (startOfWeek.month == endOfWeek.month) {
        title = '${DateFormat.d('fr_FR').format(startOfWeek)} - ${DateFormat.d('fr_FR').format(endOfWeek)} ${dateFormat.format(startOfWeek)}';
      } else if (startOfWeek.year == endOfWeek.year) {
        title = '${DateFormat.d('fr_FR').format(startOfWeek)} ${DateFormat.MMM('fr_FR').format(startOfWeek)} - ${DateFormat.d('fr_FR').format(endOfWeek)} ${DateFormat.MMM('fr_FR').format(endOfWeek)} ${DateFormat.y('fr_FR').format(startOfWeek)}';
      } else {
        title = '${DateFormat.d('fr_FR').format(startOfWeek)} ${DateFormat.MMM('fr_FR').format(startOfWeek)} ${DateFormat.y('fr_FR').format(startOfWeek)} - ${DateFormat.d('fr_FR').format(endOfWeek)} ${DateFormat.MMM('fr_FR').format(endOfWeek)} ${DateFormat.y('fr_FR').format(endOfWeek)}';
      }
    } else {
      title = dateFormat.format(selectedDate);
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Boutons de navigation
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _navigateCalendar(false),
                tooltip: 'Précédent',
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _navigateCalendar(true),
                tooltip: 'Suivant',
              ),
              IconButton(
                icon: const Icon(Icons.today),
                onPressed: () => onDateSelected(DateTime.now()),
                tooltip: 'Aujourd\'hui',
              ),
            ],
          ),
          
          // Titre
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Sélecteur de vue
          SegmentedButton<CalendarViewType>(
            segments: const [
              ButtonSegment(
                value: CalendarViewType.day, 
                label: Text('Jour'),
                icon: Icon(Icons.view_day),
              ),
              ButtonSegment(
                value: CalendarViewType.week, 
                label: Text('Semaine'),
                icon: Icon(Icons.view_week),
              ),
              ButtonSegment(
                value: CalendarViewType.month, 
                label: Text('Mois'),
                icon: Icon(Icons.calendar_month),
              ),
            ],
            selected: {viewType},
            onSelectionChanged: (Set<CalendarViewType> newSelection) {
              if (newSelection.isNotEmpty) {
                onViewTypeChanged(newSelection.first);
              }
            },
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Gère la navigation du calendrier
  void _navigateCalendar(bool forward) {
    late DateTime newDate;
    
    switch (viewType) {
      case CalendarViewType.day:
        newDate = forward
            ? selectedDate.add(const Duration(days: 1))
            : selectedDate.subtract(const Duration(days: 1));
        break;
      case CalendarViewType.week:
        newDate = forward
            ? selectedDate.add(const Duration(days: 7))
            : selectedDate.subtract(const Duration(days: 7));
        break;
      case CalendarViewType.month:
        final newMonth = forward
            ? selectedDate.month + 1
            : selectedDate.month - 1;
        newDate = DateTime(
          selectedDate.year + (newMonth > 12 ? 1 : (newMonth < 1 ? -1 : 0)),
          newMonth > 12 ? 1 : (newMonth < 1 ? 12 : newMonth),
          1,
        );
        break;
    }
    
    onDateSelected(newDate);
  }
  
  /// Construit la vue journalière
  Widget _buildDayView(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('HH:mm');
    
    // Filtrer les événements pour la date sélectionnée
    final dayEvents = events.where((event) {
      return event.start.year == selectedDate.year &&
          event.start.month == selectedDate.month &&
          event.start.day == selectedDate.day;
    }).toList();
    
    // Filtrer les tâches pour la date sélectionnée
    final dayTasks = tasks.where((task) {
      return task.dueDate.year == selectedDate.year &&
          task.dueDate.month == selectedDate.month &&
          task.dueDate.day == selectedDate.day;
    }).toList();
    
    // Trier les événements par heure de début
    dayEvents.sort((a, b) => a.start.compareTo(b.start));
    
    return ListView(
      children: [
        // En-tête
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Planning du jour',
            style: theme.textTheme.titleMedium,
          ),
        ),
        
        // Liste des plages horaires
        for (int hour = 0; hour < 24; hour++)
          _buildTimeSlot(context, hour, dayEvents, dayTasks),
      ],
    );
  }
  
  /// Construit une plage horaire pour la vue journalière
  Widget _buildTimeSlot(BuildContext context, int hour, List<Event> dayEvents, List<Task> dayTasks) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final isCurrentHour = now.hour == hour && 
        now.day == selectedDate.day && 
        now.month == selectedDate.month && 
        now.year == selectedDate.year;
    
    // Filtrer les événements pour cette heure
    final hourEvents = dayEvents.where((event) {
      return event.start.hour <= hour && event.end.hour > hour;
    }).toList();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
        color: isCurrentHour ? theme.colorScheme.primary.withOpacity(0.1) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heure
          SizedBox(
            width: 50,
            child: Text(
              '$hour:00',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isCurrentHour ? FontWeight.bold : null,
                color: isCurrentHour ? theme.colorScheme.primary : null,
              ),
            ),
          ),
          
          // Ligne verticale
          Container(
            width: 1,
            height: hourEvents.isEmpty ? 30 : null,
            color: theme.dividerColor,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
          ),
          
          // Événements
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: hourEvents.isEmpty
                  ? [const SizedBox(height: 30)]
                  : hourEvents.map((event) => _buildEventItem(context, event)).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Construit un élément d'événement pour la vue journalière
  Widget _buildEventItem(BuildContext context, Event event) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('HH:mm');
    
    // Couleurs basées sur la catégorie
    final categoryColors = {
      EventCategory.meeting: theme.colorScheme.primary.withOpacity(0.8),
      EventCategory.work: Colors.orange,
      EventCategory.personal: Colors.green,
      EventCategory.health: Colors.red,
      EventCategory.social: Colors.purple,
      EventCategory.learning: Colors.teal,
      EventCategory.other: Colors.grey,
    };
    
    final color = categoryColors[event.category] ?? theme.colorScheme.primary;
    
    return GestureDetector(
      onTap: () => onEventTap(event),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${timeFormat.format(event.start)} - ${timeFormat.format(event.end)}',
                    style: theme.textTheme.bodySmall,
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
  
  /// Construit la vue hebdomadaire
  Widget _buildWeekView(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('E d', 'fr_FR');
    
    // Déterminer le début et la fin de la semaine
    final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final dates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    
    return Column(
      children: [
        // En-têtes des jours
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: dates.map((date) {
              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;
              final isSelected = date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () => onDateSelected(date),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.2)
                          : null,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Text(
                          dateFormat.format(date).capitalize(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: isToday || isSelected
                                ? FontWeight.bold
                                : null,
                            color: isToday
                                ? theme.colorScheme.primary
                                : null,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (isToday)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        // Contenu de la semaine
        Expanded(
          child: ListView(
            children: [
              // Vue des événements
              for (final date in dates)
                _buildDayEventsForWeekView(context, date),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Construit les événements d'une journée pour la vue hebdomadaire
  Widget _buildDayEventsForWeekView(BuildContext context, DateTime date) {
    final theme = Theme.of(context);
    final isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;
    final isSelected = date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
    
    // Filtrer les événements pour cette journée
    final dayEvents = events.where((event) {
      return event.start.year == date.year &&
          event.start.month == date.month &&
          event.start.day == date.day;
    }).toList();
    
    // Filtrer les tâches pour cette journée
    final dayTasks = tasks.where((task) {
      return task.dueDate.year == date.year &&
          task.dueDate.month == date.month &&
          task.dueDate.day == date.day;
    }).toList();
    
    // Trier les événements par heure de début
    dayEvents.sort((a, b) => a.start.compareTo(b.start));
    
    if (dayEvents.isEmpty && dayTasks.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withOpacity(0.1)
            : isToday
                ? theme.colorScheme.primary.withOpacity(0.05)
                : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected || isToday
              ? theme.colorScheme.primary.withOpacity(0.5)
              : theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date
          Text(
            DateFormat.yMMMMEEEEd('fr_FR').format(date).capitalize(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isToday ? theme.colorScheme.primary : null,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Événements
          if (dayEvents.isNotEmpty) ...[
            const Text('Événements'),
            const SizedBox(height: 4),
            ...dayEvents.map((event) => _buildEventItemCompact(context, event)),
            const SizedBox(height: 8),
          ],
          
          // Tâches
          if (dayTasks.isNotEmpty) ...[
            const Text('Tâches'),
            const SizedBox(height: 4),
            ...dayTasks.map((task) => _buildTaskItemCompact(context, task)),
          ],
        ],
      ),
    );
  }
  
  /// Construit un élément d'événement compact pour la vue hebdomadaire
  Widget _buildEventItemCompact(BuildContext context, Event event) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('HH:mm');
    
    // Couleurs basées sur la catégorie
    final categoryColors = {
      EventCategory.meeting: theme.colorScheme.primary,
      EventCategory.work: Colors.orange,
      EventCategory.personal: Colors.green,
      EventCategory.health: Colors.red,
      EventCategory.social: Colors.purple,
      EventCategory.learning: Colors.teal,
      EventCategory.other: Colors.grey,
    };
    
    final color = categoryColors[event.category] ?? theme.colorScheme.primary;
    
    return GestureDetector(
      onTap: () => onEventTap(event),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color, width: 0.5),
        ),
        child: Row(
          children: [
            Text(
              '${timeFormat.format(event.start)} - ${timeFormat.format(event.end)}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                event.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Construit un élément de tâche compact pour la vue hebdomadaire
  Widget _buildTaskItemCompact(BuildContext context, Task task) {
    final theme = Theme.of(context);
    
    // Couleurs basées sur la priorité
    final priorityColors = {
      TaskPriority.veryLow: Colors.grey,
      TaskPriority.low: Colors.blue,
      TaskPriority.medium: Colors.green,
      TaskPriority.high: Colors.orange,
      TaskPriority.veryHigh: Colors.red,
    };
    
    final color = priorityColors[task.priority] ?? theme.colorScheme.primary;
    final isDone = task.status == TaskStatus.completed;
    
    return GestureDetector(
      onTap: () => onTaskTap(task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(
              isDone ? Icons.check_circle : Icons.circle_outlined,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                task.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              'P${task.priority.value}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Construit la vue mensuelle
  Widget _buildMonthView(BuildContext context) {
    final theme = Theme.of(context);
    
    // Déterminer le premier jour du mois
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    
    // Déterminer le premier jour à afficher (peut être du mois précédent)
    final firstDayToShow = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday - 1));
    
    // Déterminer le dernier jour du mois
    final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    
    // Nombre total de semaines à afficher
    final weeksToShow = ((lastDayOfMonth.day - 1 + firstDayOfMonth.weekday) / 7).ceil();
    
    // Générer tous les jours à afficher
    final daysToShow = List.generate(
      weeksToShow * 7,
      (index) => firstDayToShow.add(Duration(days: index)),
    );
    
    return Column(
      children: [
        // En-têtes des jours de la semaine
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              for (int i = 0; i < 7; i++)
                Expanded(
                  child: Text(
                    DateFormat.E('fr_FR').format(DateTime(2023, 1, 2 + i)).capitalize(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        
        // Grille du calendrier
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.8,
            ),
            itemCount: daysToShow.length,
            itemBuilder: (context, index) {
              final date = daysToShow[index];
              return _buildDayCell(context, date);
            },
          ),
        ),
      ],
    );
  }
  
  /// Construit une cellule de jour pour la vue mensuelle
  Widget _buildDayCell(BuildContext context, DateTime date) {
    final theme = Theme.of(context);
    final isCurrentMonth = date.month == selectedDate.month;
    final isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;
    final isSelected = date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
    
    // Filtrer les événements pour cette journée
    final dayEvents = events.where((event) {
      return event.start.year == date.year &&
          event.start.month == date.month &&
          event.start.day == date.day;
    }).toList();
    
    // Filtrer les tâches pour cette journée
    final dayTasks = tasks.where((task) {
      return task.dueDate.year == date.year &&
          task.dueDate.month == date.month &&
          task.dueDate.day == date.day;
    }).toList();
    
    // Nombre total d'éléments
    final totalItems = dayEvents.length + dayTasks.length;
    final hasItems = totalItems > 0;
    
    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.2)
              : isToday
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : isToday
                    ? theme.colorScheme.primary.withOpacity(0.5)
                    : isCurrentMonth
                        ? theme.dividerColor
                        : Colors.transparent,
            width: isSelected || isToday ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          children: [
            // Numéro du jour
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : isToday
                        ? theme.colorScheme.primary.withOpacity(0.8)
                        : null,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(7),
                ),
              ),
              child: Text(
                date.day.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: (isSelected || isToday)
                      ? Colors.white
                      : isCurrentMonth
                          ? null
                          : theme.disabledColor,
                  fontWeight: isToday || isSelected ? FontWeight.bold : null,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Aperçu des événements et tâches
            if (hasItems)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Afficher quelques événements
                      for (int i = 0; i < dayEvents.length && i < 2; i++)
                        _buildEventDot(context, dayEvents[i]),
                      
                      // Afficher quelques tâches
                      for (int i = 0; i < dayTasks.length && i < 2; i++)
                        _buildTaskDot(context, dayTasks[i]),
                      
                      // Si plus d'éléments
                      if (totalItems > 4)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            '+${totalItems - 4}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  /// Construit un indicateur d'événement pour la vue mensuelle
  Widget _buildEventDot(BuildContext context, Event event) {
    final theme = Theme.of(context);
    
    // Couleurs basées sur la catégorie
    final categoryColors = {
      EventCategory.meeting: theme.colorScheme.primary,
      EventCategory.work: Colors.orange,
      EventCategory.personal: Colors.green,
      EventCategory.health: Colors.red,
      EventCategory.social: Colors.purple,
      EventCategory.learning: Colors.teal,
      EventCategory.other: Colors.grey,
    };
    
    final color = categoryColors[event.category] ?? theme.colorScheme.primary;
    
    return Container(
      height: 16,
      margin: const EdgeInsets.only(bottom: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              event.title,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Construit un indicateur de tâche pour la vue mensuelle
  Widget _buildTaskDot(BuildContext context, Task task) {
    final theme = Theme.of(context);
    
    // Couleurs basées sur la priorité
    final priorityColors = {
      TaskPriority.veryLow: Colors.grey,
      TaskPriority.low: Colors.blue,
      TaskPriority.medium: Colors.green,
      TaskPriority.high: Colors.orange,
      TaskPriority.veryHigh: Colors.red,
    };
    
    final color = priorityColors[task.priority] ?? theme.colorScheme.primary;
    final isDone = task.status == TaskStatus.completed;
    
    return Container(
      height: 16,
      margin: const EdgeInsets.only(bottom: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: color,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.circle_outlined,
            size: 6,
            color: color,
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                decoration: isDone ? TextDecoration.lineThrough : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Extension pour capitaliser une chaîne
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
