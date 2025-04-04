import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';
import '../../domain/entities/message.dart';

/// Widget pour afficher une bulle de message
class MessageBubble extends StatelessWidget {
  final Message message;
  
  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final isSystem = message.role == MessageRole.system;
    
    if (isSystem) {
      return _buildSystemMessage(context);
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(context),
          
          const SizedBox(width: 8),
          
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? AppTheme.primaryColor 
                        : message.getTypeColor(context),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.type != MessageType.text && !isUser)
                        _buildTypeHeader(context),
                        
                      Text(
                        message.content,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                      
                      if (message.metadata != null && message.metadata!.isNotEmpty)
                        _buildMetadata(context),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _formatTime(message.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          if (isUser) _buildAvatar(context),
        ],
      ),
    );
  }
  
  Widget _buildSystemMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            message.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[800],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  
  Widget _buildAvatar(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser ? Colors.blue[800] : AppTheme.primaryColor,
      child: Icon(
        isUser ? Icons.person : Icons.psychology_alt,
        size: 18,
        color: Colors.white,
      ),
    );
  }
  
  Widget _buildTypeHeader(BuildContext context) {
    String title;
    IconData icon = message.getTypeIcon();
    
    switch (message.type) {
      case MessageType.suggestion:
        title = 'Suggestion';
        break;
      case MessageType.analysis:
        title = 'Analyse';
        break;
      case MessageType.taskCreation:
        title = 'Création de tâche';
        break;
      case MessageType.documentGeneration:
        title = 'Génération de document';
        break;
      case MessageType.financialAnalysis:
        title = 'Analyse financière';
        break;
      default:
        return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.black54,
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMetadata(BuildContext context) {
    // Dans une implémentation réelle, cela afficherait des données supplémentaires
    // basées sur le type de message (visualisations, boutons d'action, etc.)
    return const SizedBox.shrink();
  }
  
  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
}

/// Widget pour afficher un indicateur de chargement de message
class MessageTypingIndicator extends StatelessWidget {
  const MessageTypingIndicator({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(
              Icons.psychology_alt,
              size: 18,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(width: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: [
                _buildDot(context, 0),
                _buildDot(context, 1),
                _buildDot(context, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDot(BuildContext context, int index) {
    return AnimatedBuilder(
      animation: _getAnimation(index),
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: Colors.grey[600],
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
  
  // Simuler une animation pour les dots
  Animation<double> _getAnimation(int index) {
    return AlwaysStoppedAnimation(1.0);
  }
}