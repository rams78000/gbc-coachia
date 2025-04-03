import 'package:equatable/equatable.dart';
import 'message.dart';

/// Conversation entity
class Conversation extends Equatable {
  /// Conversation ID
  final String id;
  
  /// Conversation title
  final String title;
  
  /// Conversation messages
  final List<Message> messages;
  
  /// Last message timestamp
  final DateTime? lastMessageTimestamp;
  
  /// Unread messages count
  final int unreadCount;
  
  /// Conversation created at
  final DateTime createdAt;
  
  /// Conversation updated at
  final DateTime updatedAt;
  
  /// Conversation constructor
  const Conversation({
    required this.id,
    required this.title,
    this.messages = const [],
    this.lastMessageTimestamp,
    this.unreadCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Empty conversation
  static const empty = Conversation(
    id: '',
    title: '',
    messages: [],
    lastMessageTimestamp: null,
    unreadCount: 0,
    createdAt: null,
    updatedAt: null,
  );
  
  /// Copy with method
  Conversation copyWith({
    String? id,
    String? title,
    List<Message>? messages,
    DateTime? lastMessageTimestamp,
    int? unreadCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    title,
    messages,
    lastMessageTimestamp,
    unreadCount,
    createdAt,
    updatedAt,
  ];
}