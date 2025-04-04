import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    // Charger les événements au démarrage
    context.read<PlannerBloc>().add(LoadEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: BlocConsumer<PlannerBloc, PlannerState>(
        listener: (context, state) {
          if (state is EventsLoaded || 
              state is EventsLoadedForDate || 
              state is EventsLoadedForDateRange ||
              state is EventsLoadedByCategory ||
              state is EventsLoadedByPriority || 
              state is EventsFiltered) {
            // Convertir les événements en Map pour l'affichage du calendrier
            List<Event> events = [];
            
            if (state is EventsLoaded) {
              events = state.events;
            } else if (state is EventsLoadedForDate) {
              events = state.events;
              setState(() {
                _selectedDay = state.selectedDate;
                _focusedDay = state.selectedDate;
              });
            } else if (state is EventsLoadedForDateRange) {
              events = state.events;
            } else if (state is EventsLoadedByCategory) {
              events = state.events;
            } else if (state is EventsLoadedByPriority) {
              events = state.events;
            } else if (state is EventsFiltered) {
              events = state.events;
            }
            
            setState(() {
              _events = _groupEventsByDay(events);
            });
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              TableCalendar<Event>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                eventLoader: (day) {
                  return _getEventsForDay(day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  // Charger les événements pour le jour sélectionné
                  context.read<PlannerBloc>().add(LoadEventsForDate(selectedDay));
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  markerDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildEventList(state),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventList(PlannerState state) {
    if (state is EventsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is EventsError) {
      return Center(
        child: Text('Erreur: ${state.message}'),
      );
    } else {
      // Récupérer les événements pour le jour sélectionné
      final events = _getEventsForDay(_selectedDay);
      
      if (events.isEmpty) {
        return _buildEmptyState();
      }
      
      return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return _buildEventItem(events[index]);
        },
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.event_available,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucun événement pour cette journée',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ajoutez un événement en utilisant le bouton +',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _showAddEventDialog(context);
            },
            child: const Text('Ajouter un événement'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(Event event) {
    final DateTime now = DateTime.now();
    final bool isPast = event.endDate != null
        ? event.endDate!.isBefore(now)
        : event.startDate.isBefore(now);
    
    // Formater les heures pour l'affichage
    final startTime = DateFormat('HH:mm').format(event.startDate);
    final endTime = event.endDate != null
        ? DateFormat('HH:mm').format(event.endDate!)
        : '';
    
    return Dismissible(
      key: Key(event.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text(
                  'Êtes-vous sûr de vouloir supprimer cet événement ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Supprimer'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<PlannerBloc>().add(DeleteEvent(event.id));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Événement supprimé'),
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          _showEventDetailsDialog(context, event);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Container(
              width: 12,
              height: double.infinity,
              color: _getPriorityColor(event.priority),
            ),
            title: Text(
              event.title,
              style: TextStyle(
                decoration: event.isCompleted ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.bold,
                color: isPast ? Colors.grey : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isPast ? Colors.grey : null,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(event.category),
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getCategoryName(event.category),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (!event.isAllDay) ...[
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.endDate != null
                              ? '$startTime - $endTime'
                              : startTime,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ] else ...[
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Toute la journée',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            trailing: Checkbox(
              value: event.isCompleted,
              onChanged: (value) {
                if (value != null) {
                  context.read<PlannerBloc>().add(
                        MarkEventAsCompleted(
                          id: event.id,
                          isCompleted: value,
                        ),
                      );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showEventDetailsDialog(BuildContext context, Event event) {
    // Formater les dates pour l'affichage
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    
    final startDate = dateFormat.format(event.startDate);
    final startTime = timeFormat.format(event.startDate);
    
    final endDate = event.endDate != null
        ? dateFormat.format(event.endDate!)
        : null;
    final endTime = event.endDate != null
        ? timeFormat.format(event.endDate!)
        : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (event.description.isNotEmpty) ...[
                  const Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                    child: Text(event.description),
                  ),
                ],
                const Text(
                  'Date et heure:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                  child: Text(
                    event.isAllDay
                        ? 'Le $startDate (toute la journée)'
                        : event.endDate != null
                            ? endDate == startDate
                                ? 'Le $startDate, de $startTime à $endTime'
                                : 'Du $startDate à $startTime au $endDate à $endTime'
                            : 'Le $startDate à $startTime',
                  ),
                ),
                const Text(
                  'Catégorie:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(event.category),
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(_getCategoryName(event.category)),
                    ],
                  ),
                ),
                const Text(
                  'Priorité:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getPriorityColor(event.priority),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(_getPriorityName(event.priority)),
                    ],
                  ),
                ),
                if (event.location != null && event.location!.isNotEmpty) ...[
                  const Text(
                    'Lieu:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(event.location!),
                        ),
                      ],
                    ),
                  ),
                ],
                if (event.attendees != null && event.attendees!.isNotEmpty) ...[
                  const Text(
                    'Participants:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: event.attendees!
                          .map(
                            (attendee) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(attendee),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
                if (event.isRecurring && event.recurrencePattern != null) ...[
                  const Text(
                    'Récurrence:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                    child: Text(_getRecurrenceDescription(event.recurrencePattern!)),
                  ),
                ],
                if (event.notes.isNotEmpty) ...[
                  const Text(
                    'Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: event.notes
                          .map(
                            (note) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text('• $note'),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showEditEventDialog(context, event);
              },
              child: const Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEventDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    DateTime startDate = _selectedDay;
    TimeOfDay startTime = TimeOfDay.now();
    DateTime? endDate;
    TimeOfDay? endTime;
    bool isAllDay = false;
    EventPriority priority = EventPriority.medium;
    EventCategory category = EventCategory.other;
    String? location;
    List<String> attendees = [];
    String attendeeText = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter un événement'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Titre
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Titre',
                          hintText: 'Entrez un titre',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un titre';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                      
                      // Description
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description (optionnel)',
                          hintText: 'Entrez une description',
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                      
                      // Toute la journée
                      CheckboxListTile(
                        title: const Text('Toute la journée'),
                        value: isAllDay,
                        onChanged: (value) {
                          setState(() {
                            isAllDay = value ?? false;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      
                      // Date de début
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Text('Date: '),
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: startDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      startDate = pickedDate;
                                      if (endDate == null || endDate!.isBefore(pickedDate)) {
                                        endDate = pickedDate;
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  DateFormat('dd/MM/yyyy').format(startDate),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Heure de début
                      if (!isAllDay)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Text('Heure de début: '),
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    final pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: startTime,
                                    );
                                    if (pickedTime != null) {
                                      setState(() {
                                        startTime = pickedTime;
                                      });
                                    }
                                  },
                                  child: Text(
                                    startTime.format(context),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Date de fin
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Text('Date de fin: '),
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: endDate ?? startDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      endDate = pickedDate;
                                    });
                                  }
                                },
                                child: Text(
                                  endDate != null
                                      ? DateFormat('dd/MM/yyyy').format(endDate!)
                                      : 'Non spécifiée',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Heure de fin
                      if (!isAllDay)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Text('Heure de fin: '),
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    final pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: endTime ?? startTime,
                                    );
                                    if (pickedTime != null) {
                                      setState(() {
                                        endTime = pickedTime;
                                      });
                                    }
                                  },
                                  child: Text(
                                    endTime != null
                                        ? endTime!.format(context)
                                        : 'Non spécifiée',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Priorité
                      DropdownButtonFormField<EventPriority>(
                        decoration: const InputDecoration(
                          labelText: 'Priorité',
                        ),
                        value: priority,
                        items: EventPriority.values.map((priority) {
                          return DropdownMenuItem<EventPriority>(
                            value: priority,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(priority),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(_getPriorityName(priority)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            priority = value!;
                          });
                        },
                      ),
                      
                      // Catégorie
                      DropdownButtonFormField<EventCategory>(
                        decoration: const InputDecoration(
                          labelText: 'Catégorie',
                        ),
                        value: category,
                        items: EventCategory.values.map((cat) {
                          return DropdownMenuItem<EventCategory>(
                            value: cat,
                            child: Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(cat),
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(_getCategoryName(cat)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            category = value!;
                          });
                        },
                      ),
                      
                      // Lieu
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Lieu (optionnel)',
                          hintText: 'Entrez un lieu',
                        ),
                        onChanged: (value) {
                          location = value;
                        },
                      ),
                      
                      // Participants
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Participants:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      // Liste des participants ajoutés
                      if (attendees.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Wrap(
                            spacing: 8,
                            children: attendees
                                .map(
                                  (attendee) => Chip(
                                    label: Text(attendee),
                                    deleteIcon: const Icon(Icons.clear, size: 16),
                                    onDeleted: () {
                                      setState(() {
                                        attendees.remove(attendee);
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      
                      // Ajouter un participant
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Ajouter un participant',
                                hintText: 'Entrez un nom ou email',
                              ),
                              onChanged: (value) {
                                attendeeText = value;
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              if (attendeeText.isNotEmpty) {
                                setState(() {
                                  attendees.add(attendeeText);
                                  attendeeText = '';
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Convertir les heures en DateTime
                      final startDateTime = isAllDay
                          ? DateTime(
                              startDate.year,
                              startDate.month,
                              startDate.day,
                            )
                          : DateTime(
                              startDate.year,
                              startDate.month,
                              startDate.day,
                              startTime.hour,
                              startTime.minute,
                            );
                      
                      DateTime? endDateTime;
                      if (endDate != null) {
                        endDateTime = isAllDay
                            ? DateTime(
                                endDate!.year,
                                endDate!.month,
                                endDate!.day,
                                23, // heure de fin à 23:59:59
                                59,
                                59,
                              )
                            : endTime != null
                                ? DateTime(
                                    endDate!.year,
                                    endDate!.month,
                                    endDate!.day,
                                    endTime!.hour,
                                    endTime!.minute,
                                  )
                                : null;
                      }
                      
                      // Créer le nouvel événement
                      final newEvent = Event.create(
                        title: title,
                        description: description,
                        startDate: startDateTime,
                        endDate: endDateTime,
                        isAllDay: isAllDay,
                        priority: priority,
                        category: category,
                        location: location,
                        attendees: attendees.isNotEmpty ? attendees : null,
                      );
                      
                      // Ajouter l'événement via le bloc
                      context.read<PlannerBloc>().add(AddEvent(newEvent));
                      
                      Navigator.of(context).pop();
                      
                      // Afficher un message de confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Événement ajouté avec succès'),
                        ),
                      );
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditEventDialog(BuildContext context, Event event) {
    final formKey = GlobalKey<FormState>();
    String title = event.title;
    String description = event.description;
    DateTime startDate = event.startDate;
    TimeOfDay startTime = TimeOfDay(
      hour: event.startDate.hour,
      minute: event.startDate.minute,
    );
    DateTime? endDate = event.endDate;
    TimeOfDay? endTime = event.endDate != null
        ? TimeOfDay(
            hour: event.endDate!.hour,
            minute: event.endDate!.minute,
          )
        : null;
    bool isAllDay = event.isAllDay;
    EventPriority priority = event.priority;
    EventCategory category = event.category;
    String? location = event.location;
    List<String> attendees = event.attendees != null
        ? List<String>.from(event.attendees!)
        : [];
    String attendeeText = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Modifier l\'événement'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Titre
                      TextFormField(
                        initialValue: title,
                        decoration: const InputDecoration(
                          labelText: 'Titre',
                          hintText: 'Entrez un titre',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un titre';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                      
                      // Description
                      TextFormField(
                        initialValue: description,
                        decoration: const InputDecoration(
                          labelText: 'Description (optionnel)',
                          hintText: 'Entrez une description',
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                      
                      // Toute la journée
                      CheckboxListTile(
                        title: const Text('Toute la journée'),
                        value: isAllDay,
                        onChanged: (value) {
                          setState(() {
                            isAllDay = value ?? false;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      
                      // Date de début
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Text('Date: '),
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: startDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      startDate = DateTime(
                                        pickedDate.year,
                                        pickedDate.month,
                                        pickedDate.day,
                                        startDate.hour,
                                        startDate.minute,
                                      );
                                      if (endDate == null || endDate!.isBefore(startDate)) {
                                        endDate = startDate;
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  DateFormat('dd/MM/yyyy').format(startDate),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Heure de début
                      if (!isAllDay)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Text('Heure de début: '),
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    final pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: startTime,
                                    );
                                    if (pickedTime != null) {
                                      setState(() {
                                        startTime = pickedTime;
                                      });
                                    }
                                  },
                                  child: Text(
                                    startTime.format(context),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Date de fin
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Text('Date de fin: '),
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: endDate ?? startDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      if (endDate != null) {
                                        endDate = DateTime(
                                          pickedDate.year,
                                          pickedDate.month,
                                          pickedDate.day,
                                          endDate!.hour,
                                          endDate!.minute,
                                        );
                                      } else {
                                        endDate = pickedDate;
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  endDate != null
                                      ? DateFormat('dd/MM/yyyy').format(endDate!)
                                      : 'Non spécifiée',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Heure de fin
                      if (!isAllDay)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Text('Heure de fin: '),
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    final pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: endTime ?? startTime,
                                    );
                                    if (pickedTime != null) {
                                      setState(() {
                                        endTime = pickedTime;
                                      });
                                    }
                                  },
                                  child: Text(
                                    endTime != null
                                        ? endTime!.format(context)
                                        : 'Non spécifiée',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Priorité
                      DropdownButtonFormField<EventPriority>(
                        decoration: const InputDecoration(
                          labelText: 'Priorité',
                        ),
                        value: priority,
                        items: EventPriority.values.map((p) {
                          return DropdownMenuItem<EventPriority>(
                            value: p,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(p),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(_getPriorityName(p)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            priority = value!;
                          });
                        },
                      ),
                      
                      // Catégorie
                      DropdownButtonFormField<EventCategory>(
                        decoration: const InputDecoration(
                          labelText: 'Catégorie',
                        ),
                        value: category,
                        items: EventCategory.values.map((cat) {
                          return DropdownMenuItem<EventCategory>(
                            value: cat,
                            child: Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(cat),
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(_getCategoryName(cat)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            category = value!;
                          });
                        },
                      ),
                      
                      // Lieu
                      TextFormField(
                        initialValue: location,
                        decoration: const InputDecoration(
                          labelText: 'Lieu (optionnel)',
                          hintText: 'Entrez un lieu',
                        ),
                        onChanged: (value) {
                          location = value;
                        },
                      ),
                      
                      // Participants
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Participants:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      // Liste des participants ajoutés
                      if (attendees.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Wrap(
                            spacing: 8,
                            children: attendees
                                .map(
                                  (attendee) => Chip(
                                    label: Text(attendee),
                                    deleteIcon: const Icon(Icons.clear, size: 16),
                                    onDeleted: () {
                                      setState(() {
                                        attendees.remove(attendee);
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      
                      // Ajouter un participant
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Ajouter un participant',
                                hintText: 'Entrez un nom ou email',
                              ),
                              onChanged: (value) {
                                attendeeText = value;
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              if (attendeeText.isNotEmpty) {
                                setState(() {
                                  attendees.add(attendeeText);
                                  attendeeText = '';
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Convertir les heures en DateTime
                      final startDateTime = isAllDay
                          ? DateTime(
                              startDate.year,
                              startDate.month,
                              startDate.day,
                            )
                          : DateTime(
                              startDate.year,
                              startDate.month,
                              startDate.day,
                              startTime.hour,
                              startTime.minute,
                            );
                      
                      DateTime? endDateTime;
                      if (endDate != null) {
                        endDateTime = isAllDay
                            ? DateTime(
                                endDate!.year,
                                endDate!.month,
                                endDate!.day,
                                23, // heure de fin à 23:59:59
                                59,
                                59,
                              )
                            : endTime != null
                                ? DateTime(
                                    endDate!.year,
                                    endDate!.month,
                                    endDate!.day,
                                    endTime!.hour,
                                    endTime!.minute,
                                  )
                                : null;
                      }
                      
                      // Mettre à jour l'événement
                      final updatedEvent = event.copyWith(
                        title: title,
                        description: description,
                        startDate: startDateTime,
                        endDate: endDateTime,
                        isAllDay: isAllDay,
                        priority: priority,
                        category: category,
                        location: location,
                        attendees: attendees.isNotEmpty ? attendees : null,
                      );
                      
                      // Mettre à jour l'événement via le bloc
                      context.read<PlannerBloc>().add(UpdateEvent(updatedEvent));
                      
                      Navigator.of(context).pop();
                      
                      // Afficher un message de confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Événement mis à jour avec succès'),
                        ),
                      );
                    }
                  },
                  child: const Text('Modifier'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    EventCategory? selectedCategory;
    EventPriority? selectedPriority;
    DateTime? startDate;
    DateTime? endDate;
    bool? isCompleted;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filtrer les événements'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Catégorie
                    DropdownButtonFormField<EventCategory?>(
                      decoration: const InputDecoration(
                        labelText: 'Catégorie',
                      ),
                      value: selectedCategory,
                      items: [
                        const DropdownMenuItem<EventCategory?>(
                          value: null,
                          child: Text('Toutes les catégories'),
                        ),
                        ...EventCategory.values.map((cat) {
                          return DropdownMenuItem<EventCategory?>(
                            value: cat,
                            child: Text(_getCategoryName(cat)),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    
                    // Priorité
                    DropdownButtonFormField<EventPriority?>(
                      decoration: const InputDecoration(
                        labelText: 'Priorité',
                      ),
                      value: selectedPriority,
                      items: [
                        const DropdownMenuItem<EventPriority?>(
                          value: null,
                          child: Text('Toutes les priorités'),
                        ),
                        ...EventPriority.values.map((p) {
                          return DropdownMenuItem<EventPriority?>(
                            value: p,
                            child: Text(_getPriorityName(p)),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value;
                        });
                      },
                    ),
                    
                    // Date de début
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          const Text('À partir du: '),
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: startDate ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    startDate = pickedDate;
                                  });
                                }
                              },
                              child: Text(
                                startDate != null
                                    ? DateFormat('dd/MM/yyyy').format(startDate!)
                                    : 'Non spécifiée',
                              ),
                            ),
                          ),
                          if (startDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  startDate = null;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    
                    // Date de fin
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          const Text('Jusqu\'au: '),
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: endDate ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    endDate = pickedDate;
                                  });
                                }
                              },
                              child: Text(
                                endDate != null
                                    ? DateFormat('dd/MM/yyyy').format(endDate!)
                                    : 'Non spécifiée',
                              ),
                            ),
                          ),
                          if (endDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  endDate = null;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    
                    // Statut de complétion
                    DropdownButtonFormField<bool?>(
                      decoration: const InputDecoration(
                        labelText: 'Statut',
                      ),
                      value: isCompleted,
                      items: const [
                        DropdownMenuItem<bool?>(
                          value: null,
                          child: Text('Tous les événements'),
                        ),
                        DropdownMenuItem<bool?>(
                          value: true,
                          child: Text('Complétés'),
                        ),
                        DropdownMenuItem<bool?>(
                          value: false,
                          child: Text('Non complétés'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          isCompleted = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    // Réinitialiser tous les filtres
                    context.read<PlannerBloc>().add(LoadEvents());
                    Navigator.of(context).pop();
                  },
                  child: const Text('Réinitialiser'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Appliquer les filtres
                    if (selectedCategory != null ||
                        selectedPriority != null ||
                        startDate != null ||
                        endDate != null ||
                        isCompleted != null) {
                      context.read<PlannerBloc>().add(
                            FilterEvents(
                              category: selectedCategory,
                              priority: selectedPriority,
                              startDate: startDate,
                              endDate: endDate,
                              isCompleted: isCompleted,
                            ),
                          );
                    } else {
                      // Si aucun filtre n'est spécifié, charger tous les événements
                      context.read<PlannerBloc>().add(LoadEvents());
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Appliquer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Convert the day to a date without time
    final DateTime dateOnly = DateTime(day.year, day.month, day.day);
    
    // Get events from the map or return an empty list
    return _events[dateOnly] ?? [];
  }

  Map<DateTime, List<Event>> _groupEventsByDay(List<Event> events) {
    final Map<DateTime, List<Event>> eventsByDay = {};
    
    for (final event in events) {
      // Créer une date sans heure pour regrouper les événements par jour
      final DateTime dateOnly = DateTime(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );
      
      if (!eventsByDay.containsKey(dateOnly)) {
        eventsByDay[dateOnly] = [];
      }
      
      eventsByDay[dateOnly]!.add(event);
      
      // Pour les événements sur plusieurs jours, les ajouter à chaque jour concerné
      if (event.endDate != null && event.endDate!.isAfter(event.startDate)) {
        DateTime currentDate = dateOnly.add(const Duration(days: 1));
        final DateTime endDate = DateTime(
          event.endDate!.year,
          event.endDate!.month,
          event.endDate!.day,
        );
        
        // Ajouter l'événement à chaque jour jusqu'à la date de fin
        while (!currentDate.isAfter(endDate)) {
          if (!eventsByDay.containsKey(currentDate)) {
            eventsByDay[currentDate] = [];
          }
          
          eventsByDay[currentDate]!.add(event);
          currentDate = currentDate.add(const Duration(days: 1));
        }
      }
    }
    
    return eventsByDay;
  }

  Color _getPriorityColor(EventPriority priority) {
    switch (priority) {
      case EventPriority.low:
        return Colors.green;
      case EventPriority.medium:
        return Colors.orange;
      case EventPriority.high:
        return Colors.red;
    }
  }

  String _getPriorityName(EventPriority priority) {
    switch (priority) {
      case EventPriority.low:
        return 'Faible';
      case EventPriority.medium:
        return 'Moyenne';
      case EventPriority.high:
        return 'Haute';
    }
  }

  String _getCategoryName(EventCategory category) {
    switch (category) {
      case EventCategory.meeting:
        return 'Réunion';
      case EventCategory.task:
        return 'Tâche';
      case EventCategory.deadline:
        return 'Échéance';
      case EventCategory.appointment:
        return 'Rendez-vous';
      case EventCategory.reminder:
        return 'Rappel';
      case EventCategory.personal:
        return 'Personnel';
      case EventCategory.other:
        return 'Autre';
    }
  }

  IconData _getCategoryIcon(EventCategory category) {
    switch (category) {
      case EventCategory.meeting:
        return Icons.groups;
      case EventCategory.task:
        return Icons.assignment;
      case EventCategory.deadline:
        return Icons.alarm;
      case EventCategory.appointment:
        return Icons.event;
      case EventCategory.reminder:
        return Icons.notifications;
      case EventCategory.personal:
        return Icons.person;
      case EventCategory.other:
        return Icons.category;
    }
  }

  String _getRecurrenceDescription(RecurrencePattern pattern) {
    String frequency;
    switch (pattern.frequency) {
      case RecurrenceFrequency.daily:
        frequency = pattern.interval > 1 
            ? 'Tous les ${pattern.interval} jours' 
            : 'Tous les jours';
        break;
      case RecurrenceFrequency.weekly:
        frequency = pattern.interval > 1 
            ? 'Toutes les ${pattern.interval} semaines' 
            : 'Toutes les semaines';
        break;
      case RecurrenceFrequency.monthly:
        frequency = pattern.interval > 1 
            ? 'Tous les ${pattern.interval} mois' 
            : 'Tous les mois';
        break;
      case RecurrenceFrequency.yearly:
        frequency = pattern.interval > 1 
            ? 'Tous les ${pattern.interval} ans' 
            : 'Tous les ans';
        break;
    }
    
    String endDescription = '';
    if (pattern.endDate != null) {
      endDescription = ' jusqu\'au ${DateFormat('dd/MM/yyyy').format(pattern.endDate!)}';
    } else if (pattern.occurrences != null) {
      endDescription = ' pour ${pattern.occurrences} occurrence${pattern.occurrences! > 1 ? 's' : ''}';
    }
    
    return '$frequency$endDescription';
  }
}
