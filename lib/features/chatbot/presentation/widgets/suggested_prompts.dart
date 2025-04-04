import 'package:flutter/material.dart';

class SuggestedPrompt {
  final String text;
  final IconData icon;
  final String category;

  const SuggestedPrompt({
    required this.text,
    required this.icon,
    required this.category,
  });
}

class SuggestedPromptsWidget extends StatelessWidget {
  final Function(String) onPromptSelected;

  const SuggestedPromptsWidget({
    Key? key,
    required this.onPromptSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Questions suggérées',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: _getSuggestedPrompts()
                .map((prompt) => _buildPromptCard(context, prompt))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPromptCard(BuildContext context, SuggestedPrompt prompt) {
    final theme = Theme.of(context);
    final colorsByCategory = {
      'finance': Colors.green,
      'planning': Colors.blue,
      'business': Colors.purple,
      'productivity': Colors.orange,
      'analysis': Colors.teal,
    };
    
    final color = colorsByCategory[prompt.category] ?? theme.colorScheme.primary;
    
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => onPromptSelected(prompt.text),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    prompt.icon,
                    color: color,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Text(
                    prompt.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<SuggestedPrompt> _getSuggestedPrompts() {
    return const [
      SuggestedPrompt(
        text: 'Quel est mon solde actuel et quelles sont mes dépenses ce mois-ci ?',
        icon: Icons.account_balance_wallet,
        category: 'finance',
      ),
      SuggestedPrompt(
        text: 'Peux-tu m\'aider à planifier ma semaine de travail ?',
        icon: Icons.event,
        category: 'planning',
      ),
      SuggestedPrompt(
        text: 'Quelles sont les stratégies pour améliorer mon flux de trésorerie ?',
        icon: Icons.trending_up,
        category: 'business',
      ),
      SuggestedPrompt(
        text: 'Comment puis-je mieux gérer mon temps en tant que freelance ?',
        icon: Icons.access_time,
        category: 'productivity',
      ),
      SuggestedPrompt(
        text: 'Analyse mes revenus et dépenses des 6 derniers mois',
        icon: Icons.insights,
        category: 'analysis',
      ),
      SuggestedPrompt(
        text: 'Crée un événement pour une réunion client lundi prochain à 10h',
        icon: Icons.add_alert,
        category: 'planning',
      ),
      SuggestedPrompt(
        text: 'Quels documents dois-je conserver pour ma déclaration fiscale ?',
        icon: Icons.folder,
        category: 'business',
      ),
      SuggestedPrompt(
        text: 'Comment puis-je optimiser mes tarifs en tant que freelance ?',
        icon: Icons.attach_money,
        category: 'finance',
      ),
    ];
  }
}
