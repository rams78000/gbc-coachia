import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_bloc.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_event.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_state.dart';
import 'package:intl/intl.dart';

/// Widget de calendrier pour afficher et gérer les événements
class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlannerBloc, PlannerState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Sélecteur de vue et de mois
            _buildCalendarHeader(context, state),
            
            // Vue du calendrier
            _buildCalendarView(context, state),
          ],
        );
      },
    );
  }

  /// Construit l'en-tête du calendrier avec contrôles de navigation
  Widget _buildCalendarHeader(BuildContext context, PlannerState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          // Sélection de vue (jour, semaine, mois)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatMonthTitle(state.currentMonth),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                    value: 'day',
                    label: Text('Jour'),
                    icon: Icon(Icons.view_day),
                  ),
                  ButtonSegment<String>(
                    value: 'week',
                    label: Text('Semaine'),
                    icon: Icon(Icons.view_week),
                  ),
                  ButtonSegment<String>(
                    value: 'month',
                    label: Text('Mois'),
                    icon: Icon(Icons.calendar_view_month),
                  ),
                ],
                selected: {state.currentView},
                onSelectionChanged: (Set<String> selection) {
                  context.read<PlannerBloc>().add(
                        ChangeView(view: selection.first),
                      );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Navigation du mois
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  // Mois précédent
                  final previousMonth = DateTime(
                    state.currentMonth.year,
                    state.currentMonth.month - 1,
                    1,
                  );
                  context.read<PlannerBloc>().add(
                        ChangeMonth(month: previousMonth),
                      );
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.today),
                label: const Text('Aujourd\'hui'),
                onPressed: () {
                  // Revenir au mois actuel
                  final today = DateTime.now();
                  final thisMonth = DateTime(today.year, today.month, 1);
                  context.read<PlannerBloc>().add(
                        ChangeMonth(month: thisMonth),
                      );
                },
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  // Mois suivant
                  final nextMonth = DateTime(
                    state.currentMonth.year,
                    state.currentMonth.month + 1,
                    1,
                  );
                  context.read<PlannerBloc>().add(
                        ChangeMonth(month: nextMonth),
                      );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit la vue du calendrier en fonction du mode sélectionné
  Widget _buildCalendarView(BuildContext context, PlannerState state) {
    switch (state.currentView) {
      case 'day':
        return _buildDayView(context, state);
      case 'week':
        return _buildWeekView(context, state);
      case 'month':
      default:
        return _buildMonthView(context, state);
    }
  }

  /// Vue journalière du calendrier
  Widget _buildDayView(BuildContext context, PlannerState state) {
    final today = DateTime(
      state.currentMonth.year,
      state.currentMonth.month,
      state.currentMonth.day,
    );
    
    // Filtrer les événements pour aujourd'hui
    final eventsToday = state.events.where((event) {
      final eventDate = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      return eventDate.isAtSameMomentAs(today);
    }).toList();
    
    return Expanded(
      child: Column(
        children: [
          // En-tête du jour
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(today),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          
          // Liste des événements
          Expanded(
            child: eventsToday.isEmpty
                ? Center(
                    child: Text(
                      'Aucun événement prévu ce jour',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: eventsToday.length,
                    itemBuilder: (context, index) {
                      final event = eventsToday[index];
                      return _buildEventCard(context, event);
                    },
                  ),
          ),
          
          // Bouton d'ajout d'événement
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un événement'),
              onPressed: () {
                // TODO: Ouvrir le formulaire d'ajout d'événement
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Vue hebdomadaire du calendrier
  Widget _buildWeekView(BuildContext context, PlannerState state) {
    // Trouver le premier jour de la semaine (lundi)
    final firstDayOfWeek = state.currentMonth.subtract(
      Duration(days: state.currentMonth.weekday - 1),
    );
    
    return Expanded(
      child: Column(
        children: [
          // En-tête des jours de la semaine
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: List.generate(7, (index) {
                final date = firstDayOfWeek.add(Duration(days: index));
                final isToday = _isToday(date);
                
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isToday ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('E', 'fr_FR').format(date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday ? Theme.of(context).colorScheme.primary : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Liste des événements pour chaque jour
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, dayIndex) {
                final date = firstDayOfWeek.add(Duration(days: dayIndex));
                
                // Filtrer les événements de cette journée
                final dayEvents = state.events.where((event) {
                  final eventDate = DateTime(
                    event.startTime.year,
                    event.startTime.month,
                    event.startTime.day,
                  );
                  final targetDate = DateTime(
                    date.year,
                    date.month,
                    date.day,
                  );
                  return eventDate.isAtSameMomentAs(targetDate);
                }).toList();
                
                if (dayEvents.isEmpty) {
                  return const SizedBox.shrink();
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat('EEEE d', 'fr_FR').format(date),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    ...dayEvents.map((event) => _buildEventCard(context, event)),
                  ],
                );
              },
            ),
          ),
          
          // Bouton d'ajout d'événement
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un événement'),
              onPressed: () {
                // TODO: Ouvrir le formulaire d'ajout d'événement
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Vue mensuelle du calendrier
  Widget _buildMonthView(BuildContext context, PlannerState state) {
    // Calculer le nombre de jours dans le mois
    final daysInMonth = DateTime(
      state.currentMonth.year,
      state.currentMonth.month + 1,
      0,
    ).day;
    
    // Premier jour du mois
    final firstDayOfMonth = DateTime(
      state.currentMonth.year,
      state.currentMonth.month,
      1,
    );
    
    // Décalage pour commencer par lundi
    final firstWeekdayOfMonth = firstDayOfMonth.weekday;
    
    // Nombre total de jours à afficher (inclut les jours du mois précédent/suivant)
    final totalDays = ((firstWeekdayOfMonth - 1) + daysInMonth + 7) ~/ 7 * 7;
    
    // Première date à afficher
    final firstDisplayedDate = firstDayOfMonth.subtract(
      Duration(days: firstWeekdayOfMonth - 1),
    );
    
    return Expanded(
      child: Column(
        children: [
          // En-tête des jours de la semaine
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: List.generate(7, (index) {
                final weekdayName = DateFormat('E', 'fr_FR').format(
                  DateTime(2023, 1, 2 + index), // 2023-01-02 est un lundi
                );
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      weekdayName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Grille des jours
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.9,
              ),
              itemCount: totalDays,
              itemBuilder: (context, index) {
                final date = firstDisplayedDate.add(Duration(days: index));
                
                final isCurrentMonth = date.month == state.currentMonth.month;
                final isToday = _isToday(date);
                
                // Filtrer les événements pour cette journée
                final dayEvents = state.events.where((event) {
                  final eventDate = DateTime(
                    event.startTime.year,
                    event.startTime.month,
                    event.startTime.day,
                  );
                  final targetDate = DateTime(
                    date.year,
                    date.month,
                    date.day,
                  );
                  return eventDate.isAtSameMomentAs(targetDate);
                }).toList();
                
                return InkWell(
                  onTap: () {
                    // Sélectionner cette journée et passer en vue jour
                    context.read<PlannerBloc>().add(ChangeMonth(month: date));
                    context.read<PlannerBloc>().add(const ChangeView(view: 'day'));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isToday 
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.2) 
                          : null,
                      border: Border.all(
                        color: isCurrentMonth 
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        // Numéro du jour
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, right: 4.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                color: !isCurrentMonth 
                                    ? Colors.grey
                                    : isToday 
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                              ),
                            ),
                          ),
                        ),
                        
                        // Indicateurs d'événements
                        if (dayEvents.isNotEmpty)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ListView.builder(
                                itemCount: dayEvents.length > 3 ? 3 : dayEvents.length,
                                itemBuilder: (context, index) {
                                  if (index == 2 && dayEvents.length > 3) {
                                    return Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '+${dayEvents.length - 2}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  }
                                  
                                  final event = dayEvents[index];
                                  return Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: event.color.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      event.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Bouton d'ajout d'événement
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un événement'),
              onPressed: () {
                // TODO: Ouvrir le formulaire d'ajout d'événement
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Vérifie si une date donnée est aujourd'hui
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Formate le titre du mois affiché dans l'en-tête
  String _formatMonthTitle(DateTime month) {
    return DateFormat('MMMM yyyy', 'fr_FR').format(month);
  }

  /// Construit une carte d'événement
  Widget _buildEventCard(BuildContext context, Event event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: event.color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Ouvrir le formulaire de modification d'événement
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: event.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              if (event.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (event.location.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      event.location,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
