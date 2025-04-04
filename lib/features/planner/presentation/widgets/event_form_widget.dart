import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/planner/domain/entities/event.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_bloc.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_event.dart' as planner_event;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// Widget de formulaire pour ajouter ou modifier un événement
class EventFormWidget extends StatefulWidget {
  /// Événement à modifier (null pour un nouveau événement)
  final Event? event;

  const EventFormWidget({Key? key, this.event}) : super(key: key);

  @override
  State<EventFormWidget> createState() => _EventFormWidgetState();
}

class _EventFormWidgetState extends State<EventFormWidget> {
  // Contrôleurs de texte
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  
  // Valeurs du formulaire
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  late Color _color;
  late bool _isAllDay;
  late String _type;
  
  // Options disponibles
  final List<String> _eventTypes = [
    'Professionnel',
    'Client',
    'Réunion',
    'Formation',
    'Personnel',
    'Autre',
  ];
  
  // Couleurs disponibles
  final List<Color> _availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    
    // Si on modifie un événement existant
    if (widget.event != null) {
      _titleController = TextEditingController(text: widget.event!.title);
      _descriptionController = TextEditingController(text: widget.event!.description);
      _locationController = TextEditingController(text: widget.event!.location);
      
      _startDate = widget.event!.startTime;
      _startTime = TimeOfDay(
        hour: widget.event!.startTime.hour,
        minute: widget.event!.startTime.minute,
      );
      
      _endDate = widget.event!.endTime;
      _endTime = TimeOfDay(
        hour: widget.event!.endTime.hour,
        minute: widget.event!.endTime.minute,
      );
      
      _color = widget.event!.color;
      _isAllDay = widget.event!.isAllDay;
      _type = widget.event!.type;
    } 
    // Sinon, initialiser avec des valeurs par défaut
    else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _locationController = TextEditingController();
      
      // Par défaut, commencer dans 1 heure, durée 1 heure
      final now = DateTime.now();
      final roundedHour = DateTime(
        now.year, 
        now.month, 
        now.day, 
        now.hour + 1, 
        0,
      );
      
      _startDate = roundedHour;
      _startTime = TimeOfDay(hour: roundedHour.hour, minute: 0);
      
      _endDate = roundedHour.add(const Duration(hours: 1));
      _endTime = TimeOfDay(hour: roundedHour.hour + 1, minute: 0);
      
      _color = Colors.blue;
      _isAllDay = false;
      _type = _eventTypes[0];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre du formulaire
          Text(
            widget.event == null ? 'Nouvel événement' : 'Modifier l\'événement',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          
          // Titre de l'événement
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Titre',
              hintText: 'Entrez le titre de l\'événement',
              border: OutlineInputBorder(),
            ),
            maxLength: 100,
          ),
          const SizedBox(height: 16),
          
          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Décrivez l\'événement (optionnel)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            maxLength: 500,
          ),
          const SizedBox(height: 16),
          
          // Journée entière
          SwitchListTile(
            title: const Text('Journée entière'),
            value: _isAllDay,
            onChanged: (value) {
              setState(() {
                _isAllDay = value;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Date et heure de début
          Text(
            'Début',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Date de début
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(DateFormat('dd/MM/yyyy').format(_startDate)),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    
                    if (selectedDate != null) {
                      setState(() {
                        _startDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          _startTime.hour,
                          _startTime.minute,
                        );
                        
                        // Si la date de fin est avant la date de début, l'ajuster
                        if (_endDate.isBefore(_startDate)) {
                          _endDate = _startDate;
                        }
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              
              // Heure de début (seulement si ce n'est pas une journée entière)
              if (!_isAllDay)
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(_startTime.format(context)),
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: _startTime,
                      );
                      
                      if (selectedTime != null) {
                        setState(() {
                          _startTime = selectedTime;
                          _startDate = DateTime(
                            _startDate.year,
                            _startDate.month,
                            _startDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                          
                          // Si l'heure de fin est avant l'heure de début le même jour, l'ajuster
                          if (_endDate.isBefore(_startDate)) {
                            _endTime = TimeOfDay(
                              hour: _startTime.hour + 1,
                              minute: _startTime.minute,
                            );
                            _endDate = DateTime(
                              _endDate.year,
                              _endDate.month,
                              _endDate.day,
                              _endTime.hour,
                              _endTime.minute,
                            );
                          }
                        });
                      }
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Date et heure de fin
          Text(
            'Fin',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Date de fin
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(DateFormat('dd/MM/yyyy').format(_endDate)),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: _startDate,
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    
                    if (selectedDate != null) {
                      setState(() {
                        _endDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          _endTime.hour,
                          _endTime.minute,
                        );
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              
              // Heure de fin (seulement si ce n'est pas une journée entière)
              if (!_isAllDay)
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(_endTime.format(context)),
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: _endTime,
                      );
                      
                      if (selectedTime != null) {
                        setState(() {
                          _endTime = selectedTime;
                          
                          // Si on est sur la même date que le début
                          if (_endDate.year == _startDate.year &&
                              _endDate.month == _startDate.month &&
                              _endDate.day == _startDate.day) {
                            
                            // S'assurer que l'heure de fin est après l'heure de début
                            if (selectedTime.hour < _startTime.hour ||
                                (selectedTime.hour == _startTime.hour && selectedTime.minute <= _startTime.minute)) {
                              _endTime = TimeOfDay(
                                hour: _startTime.hour + 1,
                                minute: _startTime.minute,
                              );
                            } else {
                              _endTime = selectedTime;
                            }
                          } else {
                            _endTime = selectedTime;
                          }
                          
                          _endDate = DateTime(
                            _endDate.year,
                            _endDate.month,
                            _endDate.day,
                            _endTime.hour,
                            _endTime.minute,
                          );
                        });
                      }
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Lieu
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Lieu',
              hintText: 'Où aura lieu cet événement ? (optionnel)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 16),
          
          // Type d'événement
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Type d\'événement',
              border: OutlineInputBorder(),
            ),
            value: _type,
            items: _eventTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _type = value;
                });
              }
            },
          ),
          const SizedBox(height: 24),
          
          // Couleur
          Text(
            'Couleur',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _availableColors.map((color) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _color = color;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _color == color ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: _color == color
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          
          // Boutons d'action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bouton d'annulation
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              
              // Bouton de suppression (si modification)
              if (widget.event != null)
                TextButton(
                  onPressed: () {
                    _deleteEvent(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Supprimer'),
                ),
              
              // Bouton de sauvegarde
              ElevatedButton(
                onPressed: () {
                  _saveEvent(context);
                },
                child: Text(widget.event == null ? 'Créer' : 'Enregistrer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Sauvegarde l'événement
  void _saveEvent(BuildContext context) {
    // Validation
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le titre est obligatoire'),
        ),
      );
      return;
    }
    
    // Construire les dates et heures
    DateTime startDateTime;
    DateTime endDateTime;
    
    if (_isAllDay) {
      // Pour les événements sur toute la journée, définir des heures fixes
      startDateTime = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        0, 0,
      );
      
      endDateTime = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        23, 59,
      );
    } else {
      startDateTime = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );
      
      endDateTime = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      );
    }
    
    // Créer ou mettre à jour l'événement
    final now = DateTime.now();
    late Event event;
    
    if (widget.event == null) {
      // Nouvel événement
      event = Event(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        startTime: startDateTime,
        endTime: endDateTime,
        color: _color,
        isAllDay: _isAllDay,
        type: _type,
        location: _locationController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );
    } else {
      // Mise à jour
      event = widget.event!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        startTime: startDateTime,
        endTime: endDateTime,
        color: _color,
        isAllDay: _isAllDay,
        type: _type,
        location: _locationController.text.trim(),
        updatedAt: now,
      );
    }
    
    // Sauvegarder via BLoC
    context.read<PlannerBloc>().add(planner_event.SaveEvent(event: event));
    
    // Fermer le formulaire
    Navigator.of(context).pop();
  }
  
  /// Supprime l'événement
  void _deleteEvent(BuildContext context) {
    if (widget.event == null) return;
    
    // Demander confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'événement'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cet événement ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // Supprimer via BLoC
              context.read<PlannerBloc>().add(planner_event.DeleteEvent(id: widget.event!.id));
              
              // Fermer la boîte de dialogue et le formulaire
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
