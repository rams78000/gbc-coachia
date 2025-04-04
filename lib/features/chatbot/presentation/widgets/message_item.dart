import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/message.dart';
import 'function_result_message.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  
  const MessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.role == MessageRole.user;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: isUser 
            ? _buildUserMessage(context, theme)
            : _buildAssistantMessage(context, theme),
      ),
    );
  }
  
  Widget _buildUserMessage(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB87333), // Couleur cuivre/bronze pour l'utilisateur
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person,
                size: 12,
                color: Colors.white70,
              ),
              const SizedBox(width: 4),
              Text(
                'Vous',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAssistantMessage(BuildContext context, ThemeData theme) {
    if (message.isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFD700).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('GBC CoachIA réfléchit...'),
              ],
            ),
          ),
        ),
      );
    }
    
    // Détecter si le message est un résultat de fonction ou un message spécial
    try {
      // Si le message semble être un résultat de fonction ou un message formaté,
      // on utilise le widget dédié
      return FunctionResultMessage(message: message);
    } catch (e) {
      // En cas d'erreur, on affiche le message normalement
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.smart_toy,
                size: 12,
                color: Color(0xFFB87333),
              ),
              const SizedBox(width: 4),
              Text(
                'GBC CoachIA',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFB87333),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
