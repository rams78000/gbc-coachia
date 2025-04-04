import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/conversation.dart';

class ConversationListItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  
  const ConversationListItem({
    Key? key,
    required this.conversation,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Formatage de la date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(
      conversation.updatedAt.year,
      conversation.updatedAt.month,
      conversation.updatedAt.day,
    );
    
    String formattedDate;
    if (date == today) {
      formattedDate = "Aujourd'hui";
    } else if (date == yesterday) {
      formattedDate = "Hier";
    } else if (now.difference(date).inDays < 7) {
      formattedDate = DateFormat('EEEE', 'fr_FR').format(conversation.updatedAt);
      // Capitaliser la première lettre
      formattedDate = formattedDate[0].toUpperCase() + formattedDate.substring(1);
    } else {
      formattedDate = DateFormat('d MMM', 'fr_FR').format(conversation.updatedAt);
    }
    
    final time = DateFormat('HH:mm').format(conversation.updatedAt);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB87333).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.chat,
                    color: Color(0xFFB87333),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getLastMessagePreview(conversation),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _getLastMessagePreview(Conversation conversation) {
    if (conversation.messages.isEmpty) {
      return 'Aucun message';
    }
    
    return conversation.messages.last.content.length > 50
        ? '${conversation.messages.last.content.substring(0, 50)}...'
        : conversation.messages.last.content;
  }
  
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la conversation'),
        content: Text('Êtes-vous sûr de vouloir supprimer la conversation "${conversation.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
