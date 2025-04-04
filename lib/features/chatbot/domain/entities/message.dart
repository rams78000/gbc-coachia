import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Types de messages possibles
enum MessageType {
  text,
  suggestion,
  analysis,
  taskCreation,
  documentGeneration,
  financialAnalysis,
}

/// Rôles possibles des messages (utilisateur ou IA)
enum MessageRole {
  user,
  assistant,
  system,
}

/// Entité représentant un message dans la conversation
class Message extends Equatable {
  final String id;
  final String content;
  final MessageRole role;
  final MessageType type;
  final DateTime timestamp;
  final String? category;
  final Map<String, dynamic>? metadata;
  
  /// Constructeur principal
  const Message({
    required this.id,
    required this.content,
    required this.role,
    this.type = MessageType.text,
    required this.timestamp,
    this.category,
    this.metadata,
  });
  
  /// Constructeur pour créer un message utilisateur
  factory Message.user({
    required String id,
    required String content,
    MessageType type = MessageType.text,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id,
      content: content,
      role: MessageRole.user,
      type: type,
      timestamp: DateTime.now(),
      category: category,
      metadata: metadata,
    );
  }
  
  /// Constructeur pour créer un message assistant (IA)
  factory Message.assistant({
    required String id,
    required String content,
    MessageType type = MessageType.text,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id,
      content: content,
      role: MessageRole.assistant,
      type: type,
      timestamp: DateTime.now(),
      category: category,
      metadata: metadata,
    );
  }
  
  /// Constructeur pour créer un message système
  factory Message.system({
    required String id,
    required String content,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id,
      content: content,
      role: MessageRole.system,
      type: MessageType.text,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }
  
  /// Retourne une copie du message avec de nouvelles valeurs
  Message copyWith({
    String? id,
    String? content,
    MessageRole? role,
    MessageType? type,
    DateTime? timestamp,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      metadata: metadata ?? this.metadata,
    );
  }
  
  /// Obtient une couleur pour le message en fonction de son type
  Color getTypeColor(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (type) {
      case MessageType.text:
        return role == MessageRole.user 
            ? theme.primaryColor 
            : theme.cardColor;
      case MessageType.suggestion:
        return Colors.blue.shade100;
      case MessageType.analysis:
        return Colors.purple.shade100;
      case MessageType.taskCreation:
        return Colors.green.shade100;
      case MessageType.documentGeneration:
        return Colors.orange.shade100;
      case MessageType.financialAnalysis:
        return Colors.cyan.shade100;
    }
  }
  
  /// Obtient une icône pour le message en fonction de son type
  IconData getTypeIcon() {
    switch (type) {
      case MessageType.text:
        return Icons.chat_bubble_outline;
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
    }
  }
  
  @override
  List<Object?> get props => [id, content, role, type, timestamp, category, metadata];
}

/// Entité représentant une conversation complète
class Conversation extends Equatable {
  final String id;
  final String title;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Constructeur pour créer une nouvelle conversation
  factory Conversation.create({
    required String id,
    required String title,
  }) {
    final now = DateTime.now();
    return Conversation(
      id: id,
      title: title,
      messages: [],
      createdAt: now,
      updatedAt: now,
    );
  }
  
  /// Ajoute un message à la conversation
  Conversation addMessage(Message message) {
    return copyWith(
      messages: [...messages, message],
      updatedAt: DateTime.now(),
    );
  }
  
  /// Retourne une copie de la conversation avec de nouvelles valeurs
  Conversation copyWith({
    String? id,
    String? title,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [id, title, messages, createdAt, updatedAt];
}