import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/planner_bloc.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({Key? key}) : super(key: key);

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  final CalendarController _calendarController = CalendarController();

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Planner'),
        actions: [
          PopupMenuButton<CalendarView>(
            icon: const Icon(Icons.view_agenda_outlined),
            tooltip: 'Change view',
            onSelected: (view) {
              context.read<PlannerBloc>().add(ChangeCalendarView(view));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: CalendarView.day,
                child: Text('Day View'),
              ),
              const PopupMenuItem(
                value: CalendarView.week,
                child: Text('Week View'),
              ),
              const PopupMenuItem(
                value: CalendarView.month,
                child: Text('Month View'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<PlannerBloc, PlannerState>(
        listener: (context, state) {
          if (state is PlannerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is PlannerInitial || state is PlannerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlannerLoaded) {
            return Column(
              children: [
                Expanded(
                  child: _buildCalendar(context, state),
                ),
                AppCard(
                  child: Padding(
                    padding: EdgeInsets.all(AppTheme.spacing(2)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upcoming Tasks',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: AppTheme.spacing(2)),
                        _buildTaskList(context, state),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, PlannerLoaded state) {
    final CalendarView calendarView = state.currentView;
    final List<Task> tasks = state.tasks;
    
    return SfCalendar(
      controller: _calendarController,
      view: _getCalendarView(calendarView),
      firstDayOfWeek: 1, // Monday
      showNavigationArrow: true,
      todayHighlightColor: AppColors.primary,
      selectionDecoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      headerHeight: 50,
      viewHeaderHeight: 40,
      dataSource: _TaskDataSource(_getCalendarAppointments(tasks)),
      onTap: (details) {
        if (details.targetElement == CalendarElement.calendarCell && 
            details.appointments == null) {
          _showAddTaskDialog(
            context,
            initialDate: details.date,
          );
        } else if (details.targetElement == CalendarElement.appointment) {
          final Task task = tasks.firstWhere(
            (t) => t.id == details.appointments!.first.id,
          );
          _showTaskDetailsDialog(context, task);
        }
      },
      timeSlotViewSettings: const TimeSlotViewSettings(
        timeFormat: 'HH:mm',
        startHour: 8,
        endHour: 20,
      ),
      monthViewSettings: const MonthViewSettings(
        showAgenda: true,
        agendaViewHeight: 200,
      ),
    );
  }

  CalendarView _getCalendarView(CalendarView view) {
    switch (view) {
      case CalendarView.day:
        return CalendarView.day;
      case CalendarView.week:
        return CalendarView.week;
      case CalendarView.month:
        return CalendarView.month;
      default:
        return CalendarView.week;
    }
  }

  List<Appointment> _getCalendarAppointments(List<Task> tasks) {
    return tasks.map((task) {
      // Skip tasks without due dates
      if (task.dueDate == null) return null;
      
      final DateTime startTime = task.dueDate!;
      DateTime endTime;
      
      if (task.isAllDay) {
        endTime = startTime;
      } else {
        // Default task duration is 1 hour if not all-day
        endTime = startTime.add(const Duration(hours: 1));
      }

      Color taskColor;
      switch (task.priority) {
        case TaskPriority.high:
          taskColor = Colors.red;
          break;
        case TaskPriority.medium:
          taskColor = AppColors.primary;
          break;
        case TaskPriority.low:
          taskColor = Colors.green;
          break;
      }
      
      return Appointment(
        id: task.id,
        subject: task.title,
        startTime: startTime,
        endTime: endTime,
        color: taskColor,
        isAllDay: task.isAllDay,
        notes: task.description,
      );
    }).whereType<Appointment>().toList();
  }

  Widget _buildTaskList(BuildContext context, PlannerLoaded state) {
    final now = DateTime.now();
    final upcomingTasks = state.tasks.where((task) {
      return task.dueDate != null && 
             task.dueDate!.isAfter(now) && 
             !task.isCompleted;
    }).toList();
    
    upcomingTasks.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    
    if (upcomingTasks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text('No upcoming tasks'),
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: upcomingTasks.length > 3 ? 3 : upcomingTasks.length,
      itemBuilder: (context, index) {
        final task = upcomingTasks[index];
        return _buildTaskItem(context, task);
      },
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    final priorityColors = {
      TaskPriority.high: Colors.red,
      TaskPriority.medium: AppColors.primary,
      TaskPriority.low: Colors.green,
    };
    
    final priorityText = {
      TaskPriority.high: 'High',
      TaskPriority.medium: 'Medium',
      TaskPriority.low: 'Low',
    };
    
    return InkWell(
      onTap: () => _showTaskDetailsDialog(context, task),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppTheme.spacing(1)),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              activeColor: AppColors.primary,
              onChanged: (value) {
                context.read<PlannerBloc>().add(
                  CompleteTask(
                    taskId: task.id,
                    isCompleted: value ?? false,
                  ),
                );
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (task.dueDate != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.isAllDay
                              ? DateFormat('MMM dd, yyyy').format(task.dueDate!)
                              : DateFormat('MMM dd, yyyy - HH:mm').format(task.dueDate!),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: priorityColors[task.priority]!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: priorityColors[task.priority]!.withOpacity(0.3),
                ),
              ),
              child: Text(
                priorityText[task.priority]!,
                style: TextStyle(
                  fontSize: 12,
                  color: priorityColors[task.priority],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(
    BuildContext context, {
    DateTime? initialDate,
  }) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    
    DateTime? selectedDate = initialDate;
    TimeOfDay? selectedTime = initialDate != null 
        ? TimeOfDay(hour: initialDate.hour, minute: initialDate.minute)
        : null;
    
    bool isAllDay = false;
    TaskPriority priority = TaskPriority.medium;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add New Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: titleController,
                    label: 'Title',
                    hint: 'Enter task title',
                    autofocus: true,
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  AppTextField(
                    controller: descriptionController,
                    label: 'Description',
                    hint: 'Enter task description',
                    maxLines: 3,
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: AppTheme.spacing(1)),
                            InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ?? DateTime.now(),
                                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.textSecondary.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectedDate != null
                                          ? DateFormat('MMM dd, yyyy').format(selectedDate!)
                                          : 'Select date',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppTheme.spacing(2)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: AppTheme.spacing(1)),
                            InkWell(
                              onTap: isAllDay ? null : () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime ?? TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    selectedTime = time;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isAllDay
                                        ? Colors.grey.withOpacity(0.3)
                                        : AppColors.textSecondary.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: isAllDay ? Colors.grey.withOpacity(0.1) : null,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time, 
                                      size: 18,
                                      color: isAllDay ? Colors.grey : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isAllDay
                                          ? 'All day'
                                          : selectedTime != null
                                              ? selectedTime!.format(context)
                                              : 'Select time',
                                      style: isAllDay
                                          ? const TextStyle(color: Colors.grey)
                                          : null,
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
                  SizedBox(height: AppTheme.spacing(2)),
                  Row(
                    children: [
                      Checkbox(
                        value: isAllDay,
                        onChanged: (value) {
                          setState(() {
                            isAllDay = value ?? false;
                          });
                        },
                      ),
                      const Text('All day'),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  Text(
                    'Priority',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(1)),
                  SegmentedButton<TaskPriority>(
                    segments: const [
                      ButtonSegment(
                        value: TaskPriority.low,
                        label: Text('Low'),
                      ),
                      ButtonSegment(
                        value: TaskPriority.medium,
                        label: Text('Medium'),
                      ),
                      ButtonSegment(
                        value: TaskPriority.high,
                        label: Text('High'),
                      ),
                    ],
                    selected: {priority},
                    onSelectionChanged: (selected) {
                      setState(() {
                        priority = selected.first;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              AppButton(
                text: 'Save',
                type: AppButtonType.primary,
                fullWidth: false,
                onPressed: () {
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')),
                    );
                    return;
                  }

                  DateTime? dueDate;
                  if (selectedDate != null) {
                    if (isAllDay) {
                      dueDate = selectedDate;
                    } else if (selectedTime != null) {
                      dueDate = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                    }
                  }

                  context.read<PlannerBloc>().add(AddTask(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim().isNotEmpty
                        ? descriptionController.text.trim()
                        : null,
                    dueDate: dueDate,
                    isAllDay: isAllDay,
                    priority: priority,
                  ));

                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTaskDetailsDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description ?? '');
    
    DateTime? selectedDate = task.dueDate;
    TimeOfDay? selectedTime = task.dueDate != null 
        ? TimeOfDay(hour: task.dueDate!.hour, minute: task.dueDate!.minute)
        : null;
    
    bool isAllDay = task.isAllDay;
    TaskPriority priority = task.priority;
    bool isCompleted = task.isCompleted;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Task Details'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isCompleted,
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              setState(() {
                                isCompleted = value ?? false;
                              });
                            },
                          ),
                          const Text('Completed'),
                        ],
                      ),
                    ],
                  ),
                  AppTextField(
                    controller: titleController,
                    label: 'Title',
                    hint: 'Enter task title',
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  AppTextField(
                    controller: descriptionController,
                    label: 'Description',
                    hint: 'Enter task description',
                    maxLines: 3,
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: AppTheme.spacing(1)),
                            InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ?? DateTime.now(),
                                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.textSecondary.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectedDate != null
                                          ? DateFormat('MMM dd, yyyy').format(selectedDate!)
                                          : 'Select date',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppTheme.spacing(2)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: AppTheme.spacing(1)),
                            InkWell(
                              onTap: isAllDay ? null : () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime ?? TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    selectedTime = time;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isAllDay
                                        ? Colors.grey.withOpacity(0.3)
                                        : AppColors.textSecondary.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: isAllDay ? Colors.grey.withOpacity(0.1) : null,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time, 
                                      size: 18,
                                      color: isAllDay ? Colors.grey : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isAllDay
                                          ? 'All day'
                                          : selectedTime != null
                                              ? selectedTime!.format(context)
                                              : 'Select time',
                                      style: isAllDay
                                          ? const TextStyle(color: Colors.grey)
                                          : null,
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
                  SizedBox(height: AppTheme.spacing(2)),
                  Row(
                    children: [
                      Checkbox(
                        value: isAllDay,
                        onChanged: (value) {
                          setState(() {
                            isAllDay = value ?? false;
                          });
                        },
                      ),
                      const Text('All day'),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  Text(
                    'Priority',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(1)),
                  SegmentedButton<TaskPriority>(
                    segments: const [
                      ButtonSegment(
                        value: TaskPriority.low,
                        label: Text('Low'),
                      ),
                      ButtonSegment(
                        value: TaskPriority.medium,
                        label: Text('Medium'),
                      ),
                      ButtonSegment(
                        value: TaskPriority.high,
                        label: Text('High'),
                      ),
                    ],
                    selected: {priority},
                    onSelectionChanged: (selected) {
                      setState(() {
                        priority = selected.first;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Task'),
                      content: const Text('Are you sure you want to delete this task?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<PlannerBloc>().add(DeleteTask(task.id));
                            Navigator.pop(context); // Close delete dialog
                            Navigator.pop(context); // Close details dialog
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
              AppButton(
                text: 'Save',
                type: AppButtonType.primary,
                fullWidth: false,
                onPressed: () {
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')),
                    );
                    return;
                  }

                  DateTime? dueDate;
                  if (selectedDate != null) {
                    if (isAllDay) {
                      dueDate = selectedDate;
                    } else if (selectedTime != null) {
                      dueDate = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                    }
                  }

                  final updatedTask = task.copyWith(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim().isNotEmpty
                        ? descriptionController.text.trim()
                        : null,
                    dueDate: dueDate,
                    isAllDay: isAllDay,
                    priority: priority,
                    isCompleted: isCompleted,
                  );

                  context.read<PlannerBloc>().add(UpdateTask(updatedTask));
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TaskDataSource extends CalendarDataSource {
  _TaskDataSource(List<Appointment> source) {
    appointments = source;
  }
}
