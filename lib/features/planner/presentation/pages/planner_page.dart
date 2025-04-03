import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/models/task.dart';

/// Planner page for task and calendar management
class PlannerPage extends StatefulWidget {
  /// Constructor
  const PlannerPage({Key? key}) : super(key: key);

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  int _selectedViewIndex = 0;
  final List<String> _viewOptions = ['Jour', 'Semaine', 'Mois'];

  // Mock tasks for demo
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Réunion avec client',
      description: 'Présentation du projet et discussion des prochaines étapes',
      dueDate: DateTime.now().add(const Duration(hours: 3)),
      priority: TaskPriority.high,
      tags: ['Client', 'Projet A'],
    ),
    Task(
      id: '2',
      title: 'Finaliser proposition commerciale',
      description: 'Revoir les tarifs et conditions du contrat',
      dueDate: DateTime.now().add(const Duration(hours: 1)),
      priority: TaskPriority.medium,
      tags: ['Administratif', 'Projet B'],
    ),
    Task(
      id: '3',
      title: 'Appel fournisseur',
      description: 'Suivi de commande et délais de livraison',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.low,
      tags: ['Fournisseur', 'Logistique'],
    ),
    Task(
      id: '4',
      title: 'Veille concurrentielle',
      description: 'Analyser les nouveaux produits des concurrents',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: TaskPriority.medium,
      tags: ['Marketing', 'Stratégie'],
    ),
    Task(
      id: '5',
      title: 'Formation en ligne',
      description: 'Suivre le module 3 du cours sur le marketing digital',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: TaskPriority.low,
      tags: ['Formation', 'Développement'],
    ),
  ];

  // For form
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  TimeOfDay _dueTime = TimeOfDay.now();
  TaskPriority _priority = TaskPriority.medium;
  bool _isAllDay = false;
  Task? _selectedTask;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _changeView(int index) {
    setState(() {
      _selectedViewIndex = index;
    });
  }

  void _showAddTaskDialog() {
    _resetFormFields();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une tâche'),
        content: _buildTaskForm(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _addTask();
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    _selectedTask = task;
    _titleController.text = task.title;
    _descriptionController.text = task.description ?? '';
    _dueDate = task.dueDate;
    _dueTime = TimeOfDay.fromDateTime(task.dueDate);
    _priority = task.priority;
    _isAllDay = task.isAllDay;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la tâche'),
        content: _buildTaskForm(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _updateTask();
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _resetFormFields() {
    _selectedTask = null;
    _titleController.clear();
    _descriptionController.clear();
    _dueDate = DateTime.now();
    _dueTime = TimeOfDay.now();
    _priority = TaskPriority.medium;
    _isAllDay = false;
  }

  Widget _buildTaskForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _titleController,
            label: 'Titre',
            hint: 'Entrez le titre de la tâche',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Le titre est requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Entrez la description (optionnel)',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _dueDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _dueDate = date;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('dd/MM/yyyy').format(_dueDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Heure',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _isAllDay
                          ? null
                          : () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _dueTime,
                              );
                              if (time != null) {
                                setState(() {
                                  _dueTime = time;
                                });
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: _isAllDay ? Colors.grey.shade100 : null,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _isAllDay
                                  ? 'Toute la journée'
                                  : _dueTime.format(context),
                              style: TextStyle(
                                fontSize: 16,
                                color: _isAllDay ? Colors.grey : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _isAllDay,
                onChanged: (value) {
                  setState(() {
                    _isAllDay = value ?? false;
                  });
                },
              ),
              const Text('Toute la journée'),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Priorité',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPriorityOption(
                    label: 'Faible',
                    value: TaskPriority.low,
                    color: AppColors.lowPriority,
                  ),
                  const SizedBox(width: 8),
                  _buildPriorityOption(
                    label: 'Moyenne',
                    value: TaskPriority.medium,
                    color: AppColors.mediumPriority,
                  ),
                  const SizedBox(width: 8),
                  _buildPriorityOption(
                    label: 'Haute',
                    value: TaskPriority.high,
                    color: AppColors.highPriority,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityOption({
    required String label,
    required TaskPriority value,
    required Color color,
  }) {
    final isSelected = _priority == value;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _priority = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 4,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? color.withOpacity(0.1) : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? color : null,
                fontWeight: isSelected ? FontWeight.bold : null,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addTask() {
    // Create a combined date and time
    final DateTime combinedDateTime = DateTime(
      _dueDate.year,
      _dueDate.month,
      _dueDate.day,
      _isAllDay ? 0 : _dueTime.hour,
      _isAllDay ? 0 : _dueTime.minute,
    );

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      dueDate: combinedDateTime,
      priority: _priority,
      isAllDay: _isAllDay,
      tags: [],
    );

    setState(() {
      _tasks.add(newTask);
      // Sort tasks by date
      _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tâche ajoutée avec succès')),
    );
  }

  void _updateTask() {
    if (_selectedTask == null) return;

    // Create a combined date and time
    final DateTime combinedDateTime = DateTime(
      _dueDate.year,
      _dueDate.month,
      _dueDate.day,
      _isAllDay ? 0 : _dueTime.hour,
      _isAllDay ? 0 : _dueTime.minute,
    );

    final updatedTask = _selectedTask!.copyWith(
      title: _titleController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      dueDate: combinedDateTime,
      priority: _priority,
      isAllDay: _isAllDay,
    );

    setState(() {
      final index = _tasks.indexWhere((task) => task.id == _selectedTask!.id);
      if (index >= 0) {
        _tasks[index] = updatedTask;
        // Sort tasks by date
        _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tâche mise à jour avec succès')),
    );
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la tâche'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette tâche ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _tasks.removeWhere((t) => t.id == task.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tâche supprimée')),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificateur'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tâches'),
            Tab(text: 'Calendrier'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tasks tab
          _buildTasksTab(),

          // Calendar tab
          _buildCalendarTab(),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    // Group tasks by day
    final Map<String, List<Task>> groupedTasks = {};
    
    for (final task in _tasks) {
      final dateKey = DateFormat('yyyy-MM-dd').format(task.dueDate);
      if (!groupedTasks.containsKey(dateKey)) {
        groupedTasks[dateKey] = [];
      }
      groupedTasks[dateKey]!.add(task);
    }

    // Sort keys by date
    final sortedKeys = groupedTasks.keys.toList()
      ..sort((a, b) {
        final dateA = DateTime.parse(a);
        final dateB = DateTime.parse(b);
        return dateA.compareTo(dateB);
      });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final dateKey = sortedKeys[index];
        final tasks = groupedTasks[dateKey]!;
        final date = DateTime.parse(dateKey);
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(date),
            const SizedBox(height: 8),
            ...tasks.map((task) => _buildTaskCard(task)).toList(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(date.year, date.month, date.day);
    
    String headerText;
    if (taskDate.isAtSameMomentAs(today)) {
      headerText = 'Aujourd\'hui';
    } else if (taskDate.isAtSameMomentAs(tomorrow)) {
      headerText = 'Demain';
    } else {
      headerText = DateFormat('EEEE d MMMM', 'fr_FR').format(date);
      // Capitalize first letter
      headerText = headerText[0].toUpperCase() + headerText.substring(1);
    }
    
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        headerText,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    final Color priorityColor = _getPriorityColor(task.priority);
    final formattedTime = task.isAllDay
        ? 'Toute la journée'
        : DateFormat('HH:mm').format(task.dueDate);
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () => _showEditTaskDialog(task),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 70,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          _showTaskOptions(task);
                        },
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  if (task.description != null && task.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getPriorityText(task.priority),
                          style: TextStyle(
                            fontSize: 12,
                            color: priorityColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (task.tags.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            children: task.tags
                                .take(2)
                                .map(
                                  (tag) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          Checkbox(
            value: task.status == TaskStatus.completed,
            activeColor: priorityColor,
            onChanged: (value) {
              setState(() {
                final index = _tasks.indexWhere((t) => t.id == task.id);
                if (index >= 0) {
                  _tasks[index] = task.copyWith(
                    status: value == true ? TaskStatus.completed : TaskStatus.pending,
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void _showTaskOptions(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Modifier'),
            onTap: () {
              Navigator.pop(context);
              _showEditTaskDialog(task);
            },
          ),
          ListTile(
            leading: const Icon(Icons.content_copy),
            title: const Text('Dupliquer'),
            onTap: () {
              Navigator.pop(context);
              final newTask = task.copyWith(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: '${task.title} (copie)',
              );
              setState(() {
                _tasks.add(newTask);
                _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tâche dupliquée')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _deleteTask(task);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    return Column(
      children: [
        // Calendar view picker
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Date picker
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      _selectDate(date);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('d MMMM yyyy', 'fr_FR').format(_selectedDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              
              // View toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: List.generate(
                    _viewOptions.length,
                    (index) => GestureDetector(
                      onTap: () => _changeView(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedViewIndex == index
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _viewOptions[index],
                          style: TextStyle(
                            color: _selectedViewIndex == index
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Calendar view
        Expanded(
          child: _buildCalendarView(),
        ),
      ],
    );
  }

  Widget _buildCalendarView() {
    switch (_selectedViewIndex) {
      case 0:
        return _buildDayView();
      case 1:
        return _buildWeekView();
      case 2:
        return _buildMonthView();
      default:
        return _buildDayView();
    }
  }

  Widget _buildDayView() {
    // Filter tasks for the selected date
    final tasksForDay = _tasks.where((task) {
      final taskDate = DateTime(
        task.dueDate.year,
        task.dueDate.month,
        task.dueDate.day,
      );
      final selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      return taskDate.isAtSameMomentAs(selectedDate);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE', 'fr_FR').format(_selectedDate).capitalize(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: tasksForDay.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 80,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Pas de tâches pour cette journée',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          label: 'Ajouter une tâche',
                          icon: Icons.add,
                          onPressed: _showAddTaskDialog,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: tasksForDay.length,
                    itemBuilder: (context, index) {
                      return _buildTaskCard(tasksForDay[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView() {
    // For demo, just show a simple week view
    return const Center(
      child: Text('Vue semaine à implémenter'),
    );
  }

  Widget _buildMonthView() {
    // For demo, just show a simple month view
    return const Center(
      child: Text('Vue mois à implémenter'),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.lowPriority;
      case TaskPriority.medium:
        return AppColors.mediumPriority;
      case TaskPriority.high:
        return AppColors.highPriority;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Faible';
      case TaskPriority.medium:
        return 'Moyenne';
      case TaskPriority.high:
        return 'Haute';
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
