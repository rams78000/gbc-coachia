import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/planner/domain/entities/task.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_bloc.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_event.dart';
import 'package:uuid/uuid.dart';

/// Widget de formulaire pour ajouter ou modifier une tâche
class TaskFormWidget extends StatefulWidget {
  /// Tâche à modifier (null pour une nouvelle tâche)
  final Task? task;

  const TaskFormWidget({Key? key, this.task}) : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  // Contrôleurs de texte
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _estimatedDurationController;
  
  // Valeurs du formulaire
  late DateTime? _dueDate;
  late int _priority;
  late String _category;
  late TaskStatus _status;
  
  // Liste de catégories disponibles
  final List<String> _categories = [
    'Développement',
    'Marketing',
    'Finance',
    'Administratif',
    'Client',
    'Formation',
    'Personnel',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialisation avec les valeurs de la tâche ou des valeurs par défaut
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _estimatedDurationController = TextEditingController(
      text: widget.task?.estimatedDuration.toString() ?? '60',
    );
    
    _dueDate = widget.task?.dueDate;
    _priority = widget.task?.priority ?? 3;
    _category = widget.task?.category ?? _categories[0];
    _status = widget.task?.status ?? TaskStatus.pending;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedDurationController.dispose();
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
            widget.task == null ? 'Nouvelle tâche' : 'Modifier la tâche',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          
          // Titre de la tâche
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Titre',
              hintText: 'Entrez le titre de la tâche',
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
              hintText: 'Décrivez la tâche (optionnel)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            maxLength: 500,
          ),
          const SizedBox(height: 16),
          
          // Date d'échéance
          Row(
            children: [
              Expanded(
                child: Text(
                  'Date d\'échéance : ${_formatDate(_dueDate)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(_dueDate == null ? 'Définir' : 'Modifier'),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  
                  if (selectedDate != null) {
                    setState(() {
                      _dueDate = selectedDate;
                    });
                  }
                },
              ),
              if (_dueDate != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _dueDate = null;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Priorité
          Text(
            'Priorité : $_priority',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Slider(
            value: _priority.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: _getPriorityLabel(_priority),
            onChanged: (value) {
              setState(() {
                _priority = value.toInt();
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Catégorie
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Catégorie',
              border: OutlineInputBorder(),
            ),
            value: _category,
            items: _categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _category = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          
          // Statut
          if (widget.task != null) ...[
            DropdownButtonFormField<TaskStatus>(
              decoration: const InputDecoration(
                labelText: 'Statut',
                border: OutlineInputBorder(),
              ),
              value: _status,
              items: TaskStatus.values.map((status) {
                return DropdownMenuItem<TaskStatus>(
                  value: status,
                  child: Text(_getStatusLabel(status)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _status = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
          ],
          
          // Durée estimée
          TextFormField(
            controller: _estimatedDurationController,
            decoration: const InputDecoration(
              labelText: 'Durée estimée (minutes)',
              hintText: 'Ex: 60 pour 1 heure',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
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
              if (widget.task != null)
                TextButton(
                  onPressed: () {
                    _deleteTask(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Supprimer'),
                ),
              
              // Bouton de sauvegarde
              ElevatedButton(
                onPressed: () {
                  _saveTask(context);
                },
                child: Text(widget.task == null ? 'Créer' : 'Enregistrer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Obtient le libellé de priorité
  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'Très basse';
      case 2:
        return 'Basse';
      case 3:
        return 'Moyenne';
      case 4:
        return 'Haute';
      case 5:
        return 'Très haute';
      default:
        return 'Inconnue';
    }
  }
  
  /// Obtient le libellé de statut
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
      default:
        return 'Inconnu';
    }
  }
  
  /// Formate une date pour l'affichage
  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Non définie';
    }
    
    // Formater avec jour, mois et année
    return '${date.day}/${date.month}/${date.year}';
  }
  
  /// Sauvegarde la tâche
  void _saveTask(BuildContext context) {
    // Validation
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le titre est obligatoire'),
        ),
      );
      return;
    }
    
    // Récupérer la durée estimée
    int estimatedDuration = 60;
    try {
      estimatedDuration = int.parse(_estimatedDurationController.text.trim());
      if (estimatedDuration <= 0) {
        throw const FormatException('La durée doit être positive');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La durée estimée doit être un nombre entier positif'),
        ),
      );
      return;
    }
    
    // Créer ou mettre à jour la tâche
    final now = DateTime.now();
    late Task task;
    
    if (widget.task == null) {
      // Nouvelle tâche
      task = Task(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
        category: _category,
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
        estimatedDuration: estimatedDuration,
      );
    } else {
      // Mise à jour
      task = widget.task!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
        category: _category,
        status: _status,
        updatedAt: now,
        estimatedDuration: estimatedDuration,
      );
    }
    
    // Sauvegarder via BLoC
    context.read<PlannerBloc>().add(SaveTask(task: task));
    
    // Fermer le formulaire
    Navigator.of(context).pop();
  }
  
  /// Supprime la tâche
  void _deleteTask(BuildContext context) {
    if (widget.task == null) return;
    
    // Demander confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la tâche'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette tâche ?'),
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
              context.read<PlannerBloc>().add(DeleteTask(id: widget.task!.id));
              
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
