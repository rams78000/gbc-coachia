import 'package:equatable/equatable.dart';

enum MessageRole {
  user,
  assistant,
  system,
}

class Message extends Equatable {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final bool isLoading;

  const Message({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [id, content, role, timestamp, isLoading];

  Message copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    bool? isLoading,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
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

  // Pour la sérialisation vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'role': roleString,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Pour la désérialisation depuis JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      role: roleFromString(json['role'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
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
