import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/view/screens/features/client/chat/inbox_screen/chat_screen/model/chat_message.dart';
import 'package:local/app/view/screens/features/client/chat/socket_io/socket/socket_service.dart';

class ChatRepository {
  final SocketService _socket;

  ChatRepository({SocketService? socket}) : _socket = socket ?? SocketService();

  void connect(String url) => _socket.connect(url);

  void disconnect() => _socket.disconnect();

void setupUser(String userId) => _socket.setupUser(userId);

  void joinChat({required String roomId, required String userId}) =>
      _socket.joinChat(roomId: roomId, userId: userId);

  void leaveChat({required String roomId, required String userId}) =>
      _socket.leaveChat(roomId: roomId, userId: userId);

  Stream<ChatMessage> get onMessage => _socket.onMessage.map((m) => ChatMessage.fromJson(m));

  Stream<Map<String, dynamic>> get onTyping => _socket.onTyping;

  void startTyping({required String conversationId, required String senderId}) =>
      _socket.startTyping(conversationId: conversationId, senderId: senderId);

  void stopTyping({required String conversationId, required String senderId}) =>
      _socket.stopTyping(conversationId: conversationId, senderId: senderId);

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    List<String>? attachment,
  }) async {
    _socket.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      text: text,
      attachment: attachment,
    );
  }

  // New: fetch messages REST fallback / initial history load
  Future<List<ChatMessage>> fetchMessages(String conversationId) async {
    try {
      final resp = await ApiClient.getData(ApiUrl.getMessages(conversationId: conversationId));
      if (resp.statusCode == 200) {
        final raw = resp.body;
        if (raw is Map && raw['data'] is List) {
          final list = (raw['data'] as List)
              .map((e) => ChatMessage.fromJson(e))
              .toList(growable: false);
          return list;
        }
      } else {
        debugPrint('fetchMessages failed: ${resp.statusText}');
      }
    } catch (e) {
      debugPrint('fetchMessages error: $e');
    }
    return <ChatMessage>[];
  }
}