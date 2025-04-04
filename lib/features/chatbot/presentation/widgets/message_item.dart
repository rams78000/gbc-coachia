import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/message.dart';

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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser 
              ? Color(0xFFB87333) // Couleur cuivre/bronze pour l'utilisateur
              : Color(0xFFFFD700).withOpacity(0.2), // Couleur or pour l'assistant (atténuée)
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
            if (message.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Text(
                message.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isUser ? Colors.white : theme.textTheme.bodyMedium?.color,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isUser ? Colors.white70 : theme.textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
