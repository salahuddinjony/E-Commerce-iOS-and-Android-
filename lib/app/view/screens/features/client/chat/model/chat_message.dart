import 'package:meta/meta.dart';

@immutable
class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final List<String> attachment;
  final int createdAt;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.attachment,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      attachment: (json['attachment'] is List) ? List<String>.from(json['attachment']) : <String>[],
      createdAt: (json['createdAt'] is int) ? json['createdAt'] as int : DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderId': senderId,
        'text': text,
        'attachment': attachment,
        'createdAt': createdAt,
      };
}