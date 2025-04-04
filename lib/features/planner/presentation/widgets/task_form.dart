import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';

/// Widget de formulaire pour créer ou modifier une tâche
class TaskForm extends StatefulWidget {
  /// Tâche à modifier (null pour une nouvelle tâche)
  final Task? task;
  
  /// Callback appelé lorsque la tâche est enregistrée
  final Function(Task) onSave;
  
  /// Constructeur
  const TaskForm({
    Key? key,
    this.task,
    required this.onSave,
  }) : super(key: key);
  
  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  
  late DateTime _dueDate;
  late TaskPriority _priority;
  late TaskCategory _category;
  late int _estimatedDuration;
  late TaskStatus _status;
  
  @override
  void initState() {
    super.initState();
    
    final task = widget.task;
    
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    
    _dueDate = task?.dueDate ?? DateTime.now();
    _priority = task?.priority ?? TaskPriority.medium;
    _category = task?.category ?? TaskCategory.work;
    _estimatedDuration = task?.estimatedDuration ?? 30;
    _status = task?.status ?? TaskStatus.pending;
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.task != null;
    
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
              hintText: 'Entrez le titre de la tâche',
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
          
          // Date d'échéance
          InkWell(
            onTap: _selectDueDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date d\'échéance *',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('dd/MM/yyyy').format(_dueDate)),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Priorité
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Priorité *',
              prefixIcon: Icon(Icons.priority_high),
            ),
            child: DropdownButton<TaskPriority>(
              value: _priority,
              isExpanded: true,
              underline: const SizedBox(),
              onChanged: (TaskPriority? newValue) {
                if (newValue != null) {
                  setState(() {
                    _priority = newValue;
                  });
                }
              },
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem<TaskPriority>(
                  value: priority,
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _getPriorityColor(priority),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(_getPriorityLabel(priority)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Catégorie
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Catégorie *',
              prefixIcon: Icon(Icons.category),
            ),
            child: DropdownButton<TaskCategory>(
              value: _category,
              isExpanded: true,
              underline: const SizedBox(),
              onChanged: (TaskCategory? newValue) {
                if (newValue != null) {
                  setState(() {
                    _category = newValue;
                  });
                }
              },
              items: TaskCategory.values.map((category) {
                return DropdownMenuItem<TaskCategory>(
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
          
          const SizedBox(height: 16),
          
          // Durée estimée
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Durée estimée (minutes) *',
              prefixIcon: Icon(Icons.timer),
            ),
            child: Slider(
              value: _estimatedDuration.toDouble(),
              min: 5,
              max: 240,
              divisions: 47,
              label: '$_estimatedDuration min',
              onChanged: (double value) {
                setState(() {
                  _estimatedDuration = value.toInt();
                });
              },
            ),
          ),
          
          // Afficher la valeur de durée
          Align(
            alignment: Alignment.center,
            child: Text('$_estimatedDuration minutes'),
          ),
          
          const SizedBox(height: 16),
          
          // Statut (pour l'édition uniquement)
          if (isEditing) ...[
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Statut *',
                prefixIcon: Icon(Icons.pending_actions),
              ),
              child: DropdownButton<TaskStatus>(
                value: _status,
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: (TaskStatus? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _status = newValue;
                    });
                  }
                },
                items: TaskStatus.values.map((status) {
                  return DropdownMenuItem<TaskStatus>(
                    value: status,
                    child: Row(
                      children: [
                        Icon(_getStatusIcon(status)),
                        const SizedBox(width: 8),
                        Text(_getStatusLabel(status)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
          
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
                onPressed: _saveTask,
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'Mettre à jour' : 'Créer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Sélectionne une date d'échéance
  Future<void> _selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }
  
  /// Enregistre la tâche
  void _saveTask() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedTask = Task(
        id: widget.task?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        estimatedDuration: _estimatedDuration,
        priority: _priority,
        category: _category,
        status: _status,
      );
      
      widget.onSave(updatedTask);
      Navigator.of(context).pop();
    }
  }
  
  /// Obtient la couleur pour une priorité
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.veryLow:
        return Colors.grey;
      case TaskPriority.low:
        return Colors.blue;
      case TaskPriority.medium:
        return Colors.green;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.veryHigh:
        return Colors.red;
    }
  }
  
  /// Obtient le libellé pour une priorité
  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.veryLow:
        return 'Très basse (P1)';
      case TaskPriority.low:
        return 'Basse (P2)';
      case TaskPriority.medium:
        return 'Moyenne (P3)';
      case TaskPriority.high:
        return 'Haute (P4)';
      case TaskPriority.veryHigh:
        return 'Très haute (P5)';
    }
  }
  
  /// Obtient l'icône pour une catégorie
  IconData _getCategoryIcon(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return Icons.work;
      case TaskCategory.personal:
        return Icons.person;
      case TaskCategory.admin:
        return Icons.admin_panel_settings;
      case TaskCategory.learning:
        return Icons.school;
      case TaskCategory.health:
        return Icons.favorite;
      case TaskCategory.meeting:
        return Icons.people;
      case TaskCategory.other:
        return Icons.more_horiz;
    }
  }
  
  /// Obtient le libellé pour une catégorie
  String _getCategoryLabel(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return 'Travail';
      case TaskCategory.personal:
        return 'Personnel';
      case TaskCategory.admin:
        return 'Administratif';
      case TaskCategory.learning:
        return 'Apprentissage';
      case TaskCategory.health:
        return 'Santé';
      case TaskCategory.meeting:
        return 'Réunion';
      case TaskCategory.other:
        return 'Autre';
    }
  }
  
  /// Obtient l'icône pour un statut
  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.pending;
      case TaskStatus.inProgress:
        return Icons.play_circle;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.cancelled:
        return Icons.cancel;
    }
  }
  
  /// Obtient le libellé pour un statut
  String _getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'En attente';
      case TaskStatus.inProgress:
        return 'En cours';
      case TaskStatus.completed:
        return 'Terminée';
      case TaskStatus.cancelled:
        return 'Annulée';
    }
  }
}
