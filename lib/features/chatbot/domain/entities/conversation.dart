import 'package:equatable/equatable.dart';
import 'message.dart';

class Conversation extends Equatable {
  final String id;
  final String title;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  const Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  @override
  List<Object?> get props => [id, title, messages, createdAt, lastUpdatedAt];

  Conversation copyWith({
    String? id,
    String? title,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  // Ajouter un message à la conversation
  Conversation addMessage(Message message) {
    final newMessages = List<Message>.from(messages)..add(message);
    return copyWith(
      messages: newMessages,
      lastUpdatedAt: DateTime.now(),
    );
  }

  // Mettre à jour un message dans la conversation
  Conversation updateMessage(String messageId, Message updatedMessage) {
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index == -1) return this;

    final newMessages = List<Message>.from(messages);
    newMessages[index] = updatedMessage;
    
    return copyWith(
      messages: newMessages,
      lastUpdatedAt: DateTime.now(),
    );
  }

  // Supprimer un message de la conversation
  Conversation removeMessage(String messageId) {
    final newMessages = messages.where((msg) => msg.id != messageId).toList();
    return copyWith(
      messages: newMessages,
      lastUpdatedAt: DateTime.now(),
    );
  }

  // Pour la sérialisation vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  // Pour la désérialisation depuis JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      title: json['title'] as String,
      messages: (json['messages'] as List)
          .map((m) => Message.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
    );
  }
}
