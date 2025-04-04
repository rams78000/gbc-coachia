import 'package:flutter/material.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';
import '../../domain/entities/message.dart';

/// Widget pour afficher la liste des conversations
class ConversationList extends StatelessWidget {
  final List<Conversation> conversations;
  final String? currentConversationId;
  final Function(String) onConversationSelected;
  final VoidCallback onNewConversation;
  
  const ConversationList({
    Key? key,
    required this.conversations,
    this.currentConversationId,
    required this.onConversationSelected,
    required this.onNewConversation,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          
          // Bouton nouvelle conversation
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: ElevatedButton.icon(
              onPressed: onNewConversation,
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle conversation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(44),
              ),
            ),
          ),
          
          const Divider(),
          
          // Liste des conversations
          Expanded(
            child: ListView.builder(
              itemCount: conversations.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final isSelected = conversation.id == currentConversationId;
                
                return _ConversationListTile(
                  conversation: conversation,
                  isSelected: isSelected,
                  onTap: () {
                    onConversationSelected(conversation.id);
                    Navigator.pop(context); // Fermer le drawer
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.psychology_alt,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 12),
              Text(
                'Coach IA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Vos conversations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Posez vos questions et recevez des conseils personnalisés',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// Élément de la liste de conversations
class _ConversationListTile extends StatelessWidget {
  final Conversation conversation;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _ConversationListTile({
    Key? key,
    required this.conversation,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Extraire le dernier message pour afficher un aperçu
    final lastMessage = conversation.messages.isNotEmpty
        ? conversation.messages.last
        : null;
    
    // Extraire le premier message utilisateur pour une icône pertinente
    final firstUserMessage = conversation.messages
        .where((m) => m.role == MessageRole.user)
        .firstOrNull;
    
    final messagePreview = lastMessage != null && lastMessage.role != MessageRole.system
        ? lastMessage.content
        : 'Nouvelle conversation';
    
    final messageType = firstUserMessage?.type ?? MessageType.text;
    
    return ListTile(
      selected: isSelected,
      selectedColor: AppTheme.primaryColor,
      selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
      leading: CircleAvatar(
        backgroundColor: isSelected
            ? AppTheme.primaryColor
            : Colors.grey[300],
        child: Icon(
          _getConversationIcon(messageType),
          color: isSelected ? Colors.white : Colors.grey[700],
          size: 20,
        ),
      ),
      title: Text(
        conversation.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        messagePreview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Text(
        _formatDate(conversation.updatedAt),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
        ),
      ),
      onTap: onTap,
    );
  }
  
  IconData _getConversationIcon(MessageType type) {
    switch (type) {
      case MessageType.suggestion:
        return Icons.lightbulb_outline;
      case MessageType.analysis:
        return Icons.analytics_outlined;
      case MessageType.taskCreation:
        return Icons.task_alt;
      case MessageType.documentGeneration:
        return Icons.description_outlined;
      case MessageType.financialAnalysis:
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.chat_bubble_outline;
    }
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      final weekday = _getWeekdayName(date.weekday);
      return weekday;
    } else {
      return '${date.day}/${date.month}';
    }
  }
  
  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'Lun';
      case 2: return 'Mar';
      case 3: return 'Mer';
      case 4: return 'Jeu';
      case 5: return 'Ven';
      case 6: return 'Sam';
      case 7: return 'Dim';
      default: return '';
    }
  }
}

extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}