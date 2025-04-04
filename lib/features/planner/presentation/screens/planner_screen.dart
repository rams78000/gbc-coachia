import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/repositories/planner_repository.dart';
import '../bloc/planner_bloc.dart';

/// Écran du planificateur
class PlannerScreen extends StatefulWidget {
  /// Constructeur
  const PlannerScreen({Key? key}) : super(key: key);

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlannerBloc>(context).add(const LoadEvents());
  }

  List<PlanEvent> _getEventsForDay(List<PlanEvent> allEvents, DateTime day) {
    return allEvents.where((event) {
      final eventDay = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      final selectedDay = DateTime(day.year, day.month, day.day);
      return eventDay.isAtSameMomentAs(selectedDay);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Planificateur',
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showAddEventDialog(context),
        ),
      ],
      body: BlocBuilder<PlannerBloc, PlannerState>(
        builder: (context, state) {
          if (state is PlannerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlannerLoaded) {
            final events = state.events;
            
            return Column(
              children: [
                // Calendrier
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: (day) => _getEventsForDay(events, day),
                  calendarStyle: CalendarStyle(
                    markersMaxCount: 3,
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                
                // En-tête de la liste des événements
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        DateFormat.yMMMd().format(_selectedDay),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_getEventsForDay(events, _selectedDay).length} événements',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                
                // Liste des événements pour le jour sélectionné
                Expanded(
                  child: _EventsList(
                    events: _getEventsForDay(events, _selectedDay),
                  ),
                ),
              ],
            );
          } else if (state is PlannerError) {
            return Center(
              child: Text(
                'Erreur: ${state.message}',
                style: TextStyle(color: Colors.red[700]),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _EventFormDialog(
        onSave: (event) {
          context.read<PlannerBloc>().add(AddEvent(event));
        },
      ),
    );
  }
}

/// Widget pour afficher la liste des événements
class _EventsList extends StatelessWidget {
  final List<PlanEvent> events;

  const _EventsList({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text(
          'Aucun événement pour ce jour',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final event = events[index];
        return _EventCard(
          event: event,
          onTap: () => _showEventDetails(context, event),
        );
      },
    );
  }

  void _showEventDetails(BuildContext context, PlanEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EventDetailsBottomSheet(event: event),
    );
  }
}

/// Widget pour afficher une carte d'événement
class _EventCard extends StatelessWidget {
  final PlanEvent event;
  final VoidCallback onTap;

  const _EventCard({
    Key? key,
    required this.event,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(event.colorValue);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicateur de couleur
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              
              // Contenu principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre de l'événement
                    Text(
                      event.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Description (si disponible)
                    if (event.description != null && event.description!.isNotEmpty)
                      Text(
                        event.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    
                    // Horaire
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.isAllDay
                              ? 'Toute la journée'
                              : '${DateFormat.Hm().format(event.startTime)} - ${DateFormat.Hm().format(event.endTime)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Bouton d'édition
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Feuille de détails d'événement
class _EventDetailsBottomSheet extends StatelessWidget {
  final PlanEvent event;

  const _EventDetailsBottomSheet({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(event.colorValue);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barre de poignée
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // En-tête
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              if (event.category != null)
                Text(
                  event.category!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const Spacer(),
              
              // Boutons d'action
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pop(context);
                  _showEditEventDialog(context, event);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  _showDeleteConfirmation(context, event);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Titre
          Text(
            event.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Date et heure
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 20),
              const SizedBox(width: 8),
              Text(
                DateFormat.yMMMMd().format(event.startTime),
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              const Icon(Icons.access_time, size: 20),
              const SizedBox(width: 8),
              Text(
                event.isAllDay
                    ? 'Toute la journée'
                    : '${DateFormat.Hm().format(event.startTime)} - ${DateFormat.Hm().format(event.endTime)}',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          
          if (event.description != null && event.description!.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            
            // Description
            Text(
              'Description',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.description!,
              style: theme.textTheme.bodyLarge,
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Bouton fermer
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Fermer',
              onPressed: () => Navigator.pop(context),
              isPrimary: false,
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showEditEventDialog(BuildContext context, PlanEvent event) {
    showDialog(
      context: context,
      builder: (context) => _EventFormDialog(
        event: event,
        onSave: (updatedEvent) {
          context.read<PlannerBloc>().add(UpdateEvent(updatedEvent));
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, PlanEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'événement'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer l\'événement "${event.title}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer la boîte de dialogue
              Navigator.pop(context); // Fermer la feuille de détails
              context.read<PlannerBloc>().add(DeleteEvent(event.id));
            },
            child: const Text('Supprimer'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}

/// Dialogue de formulaire d'événement (ajout/modification)
class _EventFormDialog extends StatefulWidget {
  final PlanEvent? event;
  final Function(PlanEvent) onSave;

  const _EventFormDialog({
    Key? key,
    this.event,
    required this.onSave,
  }) : super(key: key);

  @override
  State<_EventFormDialog> createState() => _EventFormDialogState();
}

class _EventFormDialogState extends State<_EventFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  bool _isAllDay = false;
  int _selectedColorValue = 0xFF1976D2; // Bleu par défaut
  String? _selectedCategory;

  final List<CategoryOption> _categories = [
    const CategoryOption('Travail', 0xFF1976D2), // Bleu
    const CategoryOption('Personnel', 0xFF388E3C), // Vert
    const CategoryOption('Rendez-vous', 0xFFF57C00), // Orange
    const CategoryOption('Urgent', 0xFFD32F2F), // Rouge
    const CategoryOption('Autre', 0xFF7B1FA2), // Violet
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialiser les valeurs à partir de l'événement existant ou par défaut
    if (widget.event != null) {
      _titleController = TextEditingController(text: widget.event!.title);
      _descriptionController = TextEditingController(text: widget.event!.description ?? '');
      _startDate = widget.event!.startTime;
      _endDate = widget.event!.endTime;
      _startTime = TimeOfDay.fromDateTime(widget.event!.startTime);
      _endTime = TimeOfDay.fromDateTime(widget.event!.endTime);
      _isAllDay = widget.event!.isAllDay;
      _selectedColorValue = widget.event!.colorValue;
      _selectedCategory = widget.event!.category;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(hours: 1));
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay.fromDateTime(
        DateTime.now().add(const Duration(hours: 1)),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.event == null ? 'Ajouter un événement' : 'Modifier l\'événement'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  hintText: 'Entrez le titre de l\'événement',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optionnelle)',
                  hintText: 'Entrez une description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              // Toute la journée
              SwitchListTile(
                title: const Text('Toute la journée'),
                value: _isAllDay,
                onChanged: (value) {
                  setState(() {
                    _isAllDay = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              
              // Date de début
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date de début'),
                subtitle: Text(DateFormat.yMMMd().format(_startDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              
              // Heure de début (si pas toute la journée)
              if (!_isAllDay)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Heure de début'),
                  subtitle: Text(_startTime.format(context)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _selectTime(context, true),
                ),
              
              // Date de fin
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date de fin'),
                subtitle: Text(DateFormat.yMMMd().format(_endDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              
              // Heure de fin (si pas toute la journée)
              if (!_isAllDay)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Heure de fin'),
                  subtitle: Text(_endTime.format(context)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _selectTime(context, false),
                ),
              
              const SizedBox(height: 16),
              
              // Catégorie
              const Text('Catégorie'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _categories.map((category) {
                  return ChoiceChip(
                    label: Text(category.name),
                    selected: _selectedCategory == category.name,
                    selectedColor: Color(category.colorValue).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: _selectedCategory == category.name
                          ? Color(category.colorValue)
                          : null,
                      fontWeight: _selectedCategory == category.name
                          ? FontWeight.bold
                          : null,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category.name : null;
                        if (selected) {
                          _selectedColorValue = category.colorValue;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _saveEvent,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _startTime.hour,
            _startTime.minute,
          );
          
          // Si la date de fin est avant la date de début, ajuster
          if (_endDate.isBefore(_startDate)) {
            _endDate = DateTime(
              picked.year,
              picked.month,
              picked.day,
              _endTime.hour,
              _endTime.minute,
            );
          }
        } else {
          _endDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _endTime.hour,
            _endTime.minute,
          );
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          _startDate = DateTime(
            _startDate.year,
            _startDate.month,
            _startDate.day,
            picked.hour,
            picked.minute,
          );
          
          // Si l'heure de fin est avant l'heure de début le même jour, ajuster
          final startDateTime = DateTime(
            _startDate.year,
            _startDate.month,
            _startDate.day,
            picked.hour,
            picked.minute,
          );
          
          final endDateTime = DateTime(
            _endDate.year,
            _endDate.month,
            _endDate.day,
            _endTime.hour,
            _endTime.minute,
          );
          
          if (_startDate.year == _endDate.year &&
              _startDate.month == _endDate.month &&
              _startDate.day == _endDate.day &&
              endDateTime.isBefore(startDateTime)) {
            _endTime = TimeOfDay.fromDateTime(
              startDateTime.add(const Duration(hours: 1)),
            );
            _endDate = DateTime(
              _endDate.year,
              _endDate.month,
              _endDate.day,
              _endTime.hour,
              _endTime.minute,
            );
          }
        } else {
          _endTime = picked;
          _endDate = DateTime(
            _endDate.year,
            _endDate.month,
            _endDate.day,
            picked.hour,
            picked.minute,
          );
        }
      });
    }
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      // Construire l'objet DateTime final
      final startDateTime = _isAllDay
          ? DateTime(_startDate.year, _startDate.month, _startDate.day)
          : DateTime(
              _startDate.year,
              _startDate.month,
              _startDate.day,
              _startTime.hour,
              _startTime.minute,
            );
      
      final endDateTime = _isAllDay
          ? DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59)
          : DateTime(
              _endDate.year,
              _endDate.month,
              _endDate.day,
              _endTime.hour,
              _endTime.minute,
            );
      
      // Vérifier si la date de fin est après la date de début
      if (endDateTime.isBefore(startDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La date de fin doit être après la date de début'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Créer ou mettre à jour l'événement
      final event = PlanEvent(
        id: widget.event?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        startTime: startDateTime,
        endTime: endDateTime,
        colorValue: _selectedColorValue,
        isAllDay: _isAllDay,
        category: _selectedCategory,
      );
      
      widget.onSave(event);
      Navigator.pop(context);
    }
  }
}

/// Option de catégorie pour un événement
class CategoryOption {
  final String name;
  final int colorValue;

  const CategoryOption(this.name, this.colorValue);
}
