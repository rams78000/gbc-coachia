import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/event.dart';

/// Widget de formulaire pour créer ou modifier un événement
class EventForm extends StatefulWidget {
  /// Événement à modifier (null pour un nouvel événement)
  final Event? event;
  
  /// Callback appelé lorsque l'événement est enregistré
  final Function(Event) onSave;
  
  /// Constructeur
  const EventForm({
    Key? key,
    this.event,
    required this.onSave,
  }) : super(key: key);
  
  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  late EventCategory _category;
  
  @override
  void initState() {
    super.initState();
    
    final event = widget.event;
    
    _titleController = TextEditingController(text: event?.title ?? '');
    _descriptionController = TextEditingController(text: event?.description ?? '');
    _locationController = TextEditingController(text: event?.location ?? '');
    
    if (event != null) {
      _startDate = event.start;
      _startTime = TimeOfDay(hour: event.start.hour, minute: event.start.minute);
      _endDate = event.end;
      _endTime = TimeOfDay(hour: event.end.hour, minute: event.end.minute);
      _category = event.category;
    } else {
      final now = DateTime.now();
      _startDate = now;
      _startTime = TimeOfDay(hour: now.hour, minute: (now.minute ~/ 15) * 15);
      
      final endTime = now.add(const Duration(hours: 1));
      _endDate = endTime;
      _endTime = TimeOfDay(hour: endTime.hour, minute: (endTime.minute ~/ 15) * 15);
      _category = EventCategory.work;
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
    final theme = Theme.of(context);
    final isEditing = widget.event != null;
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Titre *',
              hintText: 'Entrez le titre de l\'événement',
              prefixIcon: Icon(Icons.title),
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
              labelText: 'Description',
              hintText: 'Entrez une description (optionnel)',
              prefixIcon: Icon(Icons.description),
            ),
            minLines: 2,
            maxLines: 4,
          ),
          
          const SizedBox(height: 16),
          
          // Lieu
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Lieu',
              hintText: 'Entrez le lieu de l\'événement (optionnel)',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Date et heure de début
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _selectStartDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date de début *',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd/MM/yyyy').format(_startDate)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: _selectStartTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Heure de début *',
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatTimeOfDay(_startTime)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Date et heure de fin
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _selectEndDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date de fin *',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd/MM/yyyy').format(_endDate)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: _selectEndTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Heure de fin *',
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatTimeOfDay(_endTime)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Afficher la durée calculée
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Durée: ${_calculateDuration()}',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Catégorie
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Catégorie *',
              prefixIcon: Icon(Icons.category),
            ),
            child: DropdownButton<EventCategory>(
              value: _category,
              isExpanded: true,
              underline: const SizedBox(),
              onChanged: (EventCategory? newValue) {
                if (newValue != null) {
                  setState(() {
                    _category = newValue;
                  });
                }
              },
              items: EventCategory.values.map((category) {
                return DropdownMenuItem<EventCategory>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon(category)),
                      const SizedBox(width: 8),
                      Text(_getCategoryLabel(category)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Boutons d'action
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Annuler'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _validateAndSave,
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'Mettre à jour' : 'Créer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Sélectionne la date de début
  Future<void> _selectStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
        // Si la date de fin est antérieure à la date de début, ajuster la date de fin
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      });
    }
  }
  
  /// Sélectionne l'heure de début
  Future<void> _selectStartTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: child!,
        );
      },
    );
    
    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
        
        // Si le début est après la fin sur la même date, ajuster l'heure de fin
        if (_startDate.year == _endDate.year &&
            _startDate.month == _endDate.month &&
            _startDate.day == _endDate.day) {
          if (_startTime.hour > _endTime.hour ||
              (_startTime.hour == _endTime.hour && _startTime.minute >= _endTime.minute)) {
            _endTime = TimeOfDay(
              hour: (_startTime.hour + 1) % 24,
              minute: _startTime.minute,
            );
          }
        }
      });
    }
  }
  
  /// Sélectionne la date de fin
  Future<void> _selectEndDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate.isBefore(_startDate) ? _startDate : _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (pickedDate != null) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }
  
  /// Sélectionne l'heure de fin
  Future<void> _selectEndTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: child!,
        );
      },
    );
    
    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }
  
  /// Formate une TimeOfDay en chaîne
  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat('HH:mm').format(dateTime);
  }
  
  /// Calcule et formate la durée de l'événement
  String _calculateDuration() {
    final start = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    
    final end = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day,
      _endTime.hour,
      _endTime.minute,
    );
    
    final duration = end.difference(start);
    
    if (duration.isNegative) {
      return 'Erreur: La fin est avant le début';
    }
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '$hours h ${minutes > 0 ? '$minutes min' : ''}';
    } else {
      return '$minutes min';
    }
  }
  
  /// Valide et enregistre l'événement
  void _validateAndSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // Vérifier que la date de fin n'est pas avant la date de début
      final start = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );
      
      final end = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      );
      
      if (end.isBefore(start)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La date de fin doit être après la date de début'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final updatedEvent = Event(
        id: widget.event?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        start: start,
        end: end,
        category: _category,
      );
      
      widget.onSave(updatedEvent);
      Navigator.of(context).pop();
    }
  }
  
  /// Obtient l'icône pour une catégorie
  IconData _getCategoryIcon(EventCategory category) {
    switch (category) {
      case EventCategory.meeting:
        return Icons.people;
      case EventCategory.work:
        return Icons.work;
      case EventCategory.personal:
        return Icons.person;
      case EventCategory.health:
        return Icons.favorite;
      case EventCategory.social:
        return Icons.celebration;
      case EventCategory.learning:
        return Icons.school;
      case EventCategory.other:
        return Icons.more_horiz;
    }
  }
  
  /// Obtient le libellé pour une catégorie
  String _getCategoryLabel(EventCategory category) {
    switch (category) {
      case EventCategory.meeting:
        return 'Réunion';
      case EventCategory.work:
        return 'Travail';
      case EventCategory.personal:
        return 'Personnel';
      case EventCategory.health:
        return 'Santé';
      case EventCategory.social:
        return 'Social';
      case EventCategory.learning:
        return 'Apprentissage';
      case EventCategory.other:
        return 'Autre';
    }
  }
}
