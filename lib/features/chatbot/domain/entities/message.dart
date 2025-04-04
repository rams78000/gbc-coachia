import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum MessageRole {
  user,
  assistant,
  system,
}

/// Représente les différents types de messages pouvant être affichés dans le chat
enum MessageType {
  text,
  suggestion,
  analysis,
  taskCreation,
  documentGeneration,
  financialAnalysis,
  error,
}

class Message extends Equatable {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final bool isLoading;
  final MessageType type;
  final Map<String, dynamic>? metadata;

  const Message({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isLoading = false,
    this.type = MessageType.text,
    this.metadata,
  });

  @override
  List<Object?> get props => [id, content, role, timestamp, isLoading, type, metadata];

  Message copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    bool? isLoading,
    MessageType? type,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
    );
  }

  // Convertir le rôle en chaîne pour l'API OpenAI
  String get roleString {
    switch (role) {
      case MessageRole.user:
        return 'user';
      case MessageRole.assistant:
        return 'assistant';
      case MessageRole.system:
        return 'system';
    }
  }

  // Créer un message à partir d'une chaîne de rôle
  static MessageRole roleFromString(String roleStr) {
    switch (roleStr.toLowerCase()) {
      case 'user':
        return MessageRole.user;
      case 'assistant':
        return MessageRole.assistant;
      case 'system':
        return MessageRole.system;
      default:
        throw ArgumentError('Invalid message role: $roleStr');
    }
  }

  // Obtenir la couleur associée au type de message
  Color getTypeColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    switch (type) {
      case MessageType.text:
        return isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
      case MessageType.suggestion:
        return isDarkMode ? Colors.blue[900]! : Colors.blue[50]!;
      case MessageType.analysis:
        return isDarkMode ? Colors.purple[900]! : Colors.purple[50]!;
      case MessageType.taskCreation:
        return isDarkMode ? Colors.green[900]! : Colors.green[50]!;
      case MessageType.documentGeneration:
        return isDarkMode ? Colors.orange[900]! : Colors.orange[50]!;
      case MessageType.financialAnalysis:
        return isDarkMode ? Colors.teal[900]! : Colors.teal[50]!;
      case MessageType.error:
        return isDarkMode ? Colors.red[900]! : Colors.red[50]!;
    }
  }

  // Obtenir l'icône associée au type de message
  IconData getTypeIcon() {
    switch (type) {
      case MessageType.text:
        return Icons.chat_bubble_outline;
      case MessageType.suggestion:
        return Icons.lightbulb_outline;
      case MessageType.analysis:
        return Icons.analytics_outlined;
      case MessageType.taskCreation:
        return Icons.add_task;
      case MessageType.documentGeneration:
        return Icons.description_outlined;
      case MessageType.financialAnalysis:
        return Icons.account_balance_wallet_outlined;
      case MessageType.error:
        return Icons.error_outline;
    }
  }

  // Pour la sérialisation vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'role': roleString,
      'timestamp': timestamp.toIso8601String(),
      'type': type.index,
      if (metadata != null) 'metadata': metadata,
    };
  }

  // Pour la désérialisation depuis JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      role: roleFromString(json['role'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] != null 
          ? MessageType.values[json['type'] as int]
          : MessageType.text,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  // Pour l'API OpenAI
  Map<String, dynamic> toOpenAIMessage() {
    return {
      'role': roleString,
      'content': content,
    };
  }
}
