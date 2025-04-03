import 'package:equatable/equatable.dart';

/// Message sender enum
enum MessageSender {
  /// User message
  user,
  
  /// Assistant message
  assistant,
  
  /// System message
  system,
}

/// Message entity
class Message extends Equatable {
  /// Message ID
  final String id;
  
  /// Message content
  final String content;
  
  /// Message sender
  final MessageSender sender;
  
  /// Message timestamp
  final DateTime timestamp;
  
  /// List of attachment URLs
  final List<String> attachments;
  
  /// Is the message read
  final bool isRead;
  
  /// Message created at
  final DateTime createdAt;
  
  /// Message updated at
  final DateTime? updatedAt;
  
  /// Message constructor
  const Message({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.attachments = const [],
    this.isRead = false,
    required this.createdAt,
    this.updatedAt,
  });
  
  /// Empty message
  static const empty = Message(
    id: '',
    content: '',
    sender: MessageSender.user,
    timestamp: null,
    createdAt: null,
  );
  
  /// Copy with method
  Message copyWith({
    String? id,
    String? content,
    MessageSender? sender,
    DateTime? timestamp,
    List<String>? attachments,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      attachments: attachments ?? this.attachments,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    content,
    sender,
    timestamp,
    attachments,
    isRead,
    createdAt,
    updatedAt,
  ];
}