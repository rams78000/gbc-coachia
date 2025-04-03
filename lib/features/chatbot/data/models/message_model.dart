import '../../domain/entities/message.dart';

/// Message model for API communication
class MessageModel extends Message {
  /// Create a message model
  const MessageModel({
    required String id,
    required String content,
    required DateTime timestamp,
    required bool isUserMessage,
  }) : super(
          id: id,
          content: content,
          timestamp: timestamp,
          isUserMessage: isUserMessage,
        );

  /// Create from JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUserMessage: json['is_user_message'] as bool,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'is_user_message': isUserMessage,
    };
  }
}
