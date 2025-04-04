import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/planner/domain/entities/optimized_plan.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_bloc.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_event.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_state.dart';
import 'package:intl/intl.dart';

/// Widget pour afficher et gérer le plan optimisé
class OptimizedPlanWidget extends StatelessWidget {
  const OptimizedPlanWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlannerBloc, PlannerState>(
      builder: (context, state) {
        // Si aucun plan n'est généré, afficher un écran d'introduction
        if (state.optimizedPlan == null) {
          return _buildIntroScreen(context);
        }

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildPlanDisplay(context, state.optimizedPlan!);
      },
    );
  }

  /// Construit l'écran d'introduction pour générer un plan
  Widget _buildIntroScreen(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome,
              size: 80,
              color: Color(0xFFB87333), // Couleur cuivre/bronze
            ),
            const SizedBox(height: 24),
            Text(
              'Planification AI',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Notre IA peut vous aider à optimiser votre journée en organisant vos tâches et événements pour maximiser votre productivité.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.smart_toy),
              label: const Text('Générer un plan optimisé'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                // Générer un plan pour aujourd'hui
                context.read<PlannerBloc>().add(
                  GenerateOptimizedPlan(date: DateTime.now()),
                );
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              child: const Text('En savoir plus'),
              onPressed: () {
                // TODO: Afficher des informations sur la planification AI
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Planification AI'),
                    content: const SingleChildScrollView(
                      child: Text(
                        'La planification AI utilise des algorithmes avancés pour analyser vos tâches, '
                        'leur priorité, et vos événements déjà programmés afin de créer un emploi du temps '
                        'optimal qui respecte vos contraintes de temps.\n\n'
                        'L\'IA prend en compte les facteurs suivants :\n'
                        '• Priorité des tâches\n'
                        '• Échéances\n'
                        '• Durées estimées\n'
                        '• Pauses nécessaires\n'
                        '• Événements déjà planifiés\n\n'
                        'Le plan généré inclut également des statistiques de productivité et des '
                        'recommandations pour améliorer votre journée de travail.',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Construit l'affichage du plan optimisé
  Widget _buildPlanDisplay(BuildContext context, OptimizedPlan plan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec la date et le score
          _buildPlanHeader(context, plan),
          
          const SizedBox(height: 24),
          
          // Chronologie du plan
          _buildTimeline(context, plan),
          
          const SizedBox(height: 32),
          
          // Statistiques de productivité
          _buildStatistics(context, plan),
          
          const SizedBox(height: 24),
          
          // Commentaires de l'IA
          _buildAIComments(context, plan),
          
          const SizedBox(height: 32),
          
          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Regénérer'),
                onPressed: () {
                  context.read<PlannerBloc>().add(
                    GenerateOptimizedPlan(date: plan.date),
                  );
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Appliquer ce plan'),
                onPressed: () {
                  // TODO: Implémenter l'application du plan (conversion en événements)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Plan appliqué ! Les événements ont été créés dans votre calendrier.'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit l'en-tête du plan avec la date et le score
  Widget _buildPlanHeader(BuildContext context, OptimizedPlan plan) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plan optimisé',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(plan.date),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getScoreColor(plan.efficiencyScore).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Column(
            children: [
              Text(
                '${plan.efficiencyScore}%',
                style: TextStyle(
                  color: _getScoreColor(plan.efficiencyScore),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Efficacité',
                style: TextStyle(
                  color: _getScoreColor(plan.efficiencyScore),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construit la chronologie des créneaux
  Widget _buildTimeline(BuildContext context, OptimizedPlan plan) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: plan.timeSlots.length,
      itemBuilder: (context, index) {
        final slot = plan.timeSlots[index];
        
        // Déterminer la couleur du créneau
        Color slotColor;
        IconData slotIcon;
        
        switch (slot.type) {
          case 'task':
            slotColor = Colors.blue;
            slotIcon = Icons.assignment;
            break;
          case 'event':
            slotColor = slot.event?.color ?? Colors.purple;
            slotIcon = Icons.event;
            break;
          case 'break':
            slotColor = Colors.green;
            slotIcon = Icons.coffee;
            break;
          case 'free':
          default:
            slotColor = Colors.grey;
            slotIcon = Icons.access_time;
            break;
        }
        
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ligne de temps
              SizedBox(
                width: 70,
                child: Column(
                  children: [
                    Text(
                      DateFormat('HH:mm').format(slot.startTime),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 2,
                        color: slotColor.withOpacity(0.5),
                        margin: const EdgeInsets.symmetric(horizontal: 34),
                      ),
                    ),
                    if (index == plan.timeSlots.length - 1)
                      Text(
                        DateFormat('HH:mm').format(slot.endTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                  ],
                ),
              ),
              
              // Contenu du créneau
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: slotColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: slotColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(slotIcon, color: slotColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            slot.type == 'task' && slot.task != null
                                ? slot.task!.title
                                : slot.type == 'event' && slot.event != null
                                    ? slot.event!.title
                                    : slot.type == 'break'
                                        ? 'Pause'
                                        : 'Temps libre',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: slotColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${slot.endTime.difference(slot.startTime).inMinutes} min',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      if ((slot.type == 'task' && slot.task?.description.isNotEmpty == true) ||
                          (slot.type == 'event' && slot.event?.description.isNotEmpty == true)) ...[
                        const SizedBox(height: 8),
                        Text(
                          slot.type == 'task' ? slot.task!.description : slot.event!.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      if (slot.type == 'break') ...[
                        const SizedBox(height: 8),
                        Text(
                          'Prenez une pause pour recharger votre énergie et votre concentration.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      if (slot.type == 'event' && slot.event?.location.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              slot.event!.location,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Construit la section des statistiques
  Widget _buildStatistics(BuildContext context, OptimizedPlan plan) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiques de productivité',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.timer,
                    '${_formatDuration(plan.focusedWorkTime)}',
                    'Travail focalisé',
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.coffee,
                    '${_formatDuration(plan.breakTime)}',
                    'Pauses',
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.priority_high,
                    '${plan.priorityTasksIncluded}',
                    'Tâches prioritaires',
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit un élément statistique
  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  /// Construit la section des commentaires de l'IA
  Widget _buildAIComments(BuildContext context, OptimizedPlan plan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB87333).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFB87333).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.smart_toy,
                color: Color(0xFFB87333),
              ),
              const SizedBox(width: 8),
              Text(
                'Recommandations de l\'IA',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFB87333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            plan.aiComments,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Retourne la couleur associée à un score d'efficacité
  Color _getScoreColor(int score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  /// Formate une durée en minutes en un texte lisible
  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      
      if (remainingMinutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h${remainingMinutes}';
      }
    }
  }
}
