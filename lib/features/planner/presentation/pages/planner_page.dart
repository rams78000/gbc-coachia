import 'package:flutter/material.dart';

/// Page du planificateur intelligent
class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificateur'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendarHeader(context),
          const Divider(),
          Expanded(
            child: _buildTasksList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_task),
      ),
    );
  }

  Widget _buildCalendarHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Avril 2025',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 16),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                7,
                (index) => _buildDateItem(context, index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(BuildContext context, int index) {
    final isSelected = index == 3; // Exemple: jour actuel
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 50,
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            _getWeekdayName(index),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${index + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekdayName(int index) {
    final weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return weekdays[index % 7];
  }

  Widget _buildTasksList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _buildTaskItem(index);
      },
    );
  }

  Widget _buildTaskItem(int index) {
    // Exemple de priorités différentes
    final priorities = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue];
    final times = ['09:00', '11:30', '13:00', '15:45', '17:30'];
    final titles = [
      'Appel client',
      'Réunion équipe',
      'Pause déjeuner',
      'Revue de projet',
      'Fin de journée'
    ];
    
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          color: priorities[index % priorities.length],
        ),
        title: Text(titles[index % titles.length]),
        subtitle: Text('Avril ${index + 1}, 2025'),
        trailing: Text(
          times[index % times.length],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
