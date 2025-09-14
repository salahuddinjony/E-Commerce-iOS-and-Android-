import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart'; // <--- added for debugPrint
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:local/app/view/screens/features/client/chat/inbox/controller/conversation_controller.dart';
import 'package:local/app/view/screens/features/client/chat/model/chat_message.dart';
import 'package:local/app/view/screens/features/client/chat/repositories/chat_repository.dart'
    show ChatRepository;
import 'package:local/app/view/screens/features/client/chat/inbox/controller/conversation_controller.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  final String conversationId;
  final String userId;
  final ChatRepository _repo;
  late final types.User user;

  ChatController({
    required this.conversationId,
    required this.userId,
    ChatRepository? repository,
  }) : _repo = repository ?? ChatRepository() {
    user = types.User(id: userId, firstName: 'Me');
  }

  final messages = RxList<types.Message>(<types.Message>[]);
  final isTyping = false.obs;

  StreamSubscription<ChatMessage>? _msgSub;
  StreamSubscription<Map<String, dynamic>>? _typingSub;

  @override
  void onInit() {
    super.onInit();
    // connect to socket and join room
    _repo.connect('https://gmosley-uteehub-backend.onrender.com');

    // load history first (if available) so UI shows past messages
    _repo.fetchMessages(conversationId).then((history) {
      // map history messages to flutter_chat_types messages
      // ensure createdAt is milliseconds since epoch
      for (final h in history.reversed) {
        final authorId = h.senderId ?? 'unknown';
        final createdAtMs = (h.createdAt != null
                ? (h.createdAt is int
                    ? h.createdAt
                    : (h.createdAt is DateTime
                        ? (h.createdAt as DateTime).millisecondsSinceEpoch
                        : null))
                : null) ??
            DateTime.now().millisecondsSinceEpoch;

        final msg = types.TextMessage(
          author: types.User(id: authorId),
          createdAt: createdAtMs,
          id: h.id.isNotEmpty ? h.id : const Uuid().v4(),
          text: h.text ?? '',
        );
        // newest first expected by UI, but we're iterating reversed to keep chronology
        messages.insert(0, msg);
      }
    }).catchError((e) {
      debugPrint('history load error: $e');
    }).whenComplete(() {
      // now join socket to receive live messages
      _repo.joinChat(roomId: conversationId, userId: userId);
    });

    _msgSub = _repo.onMessage.listen((chatMsg) {
      // Ignore server echoes of our own messages (and also skip duplicates by id)
      if (chatMsg.senderId == userId) return;
      if (chatMsg.id.isNotEmpty && messages.any((m) => m.id == chatMsg.id)) return;

      final msg = types.TextMessage(
        author: types.User(id: chatMsg.senderId ?? 'unknown'),
        createdAt: chatMsg.createdAt,
        id: chatMsg.id.isNotEmpty ? chatMsg.id : const Uuid().v4(),
        text: chatMsg.text ?? '',
      );
      // newest first
      messages.insert(0, msg);

      // update inbox preview for this conversation
      _updateConversationLastMessage(chatMsg.text ?? '', chatMsg.createdAt);
    });

    _typingSub = _repo.onTyping.listen((data) {
      // server sends typing/stop-typing payloads; adapt if needed
      final event = data['event']?.toString() ?? '';
      final sender =
          data['senderId']?.toString() ?? data['userId']?.toString() ?? '';
      if (sender == userId) return; // ignore own typing
      if (data['type'] == 'start' || event == 'typing') {
        isTyping.value = true;
      } else if (data['type'] == 'stop' || event == 'stop-typing') {
        isTyping.value = false;
      } else {
        // some servers emit typing as { conversationId, senderId }
        if (data.containsKey('senderId')) isTyping.value = true;
      }
    });
  }

  @override
  void onClose() {
    _msgSub?.cancel();
    _typingSub?.cancel();
    _repo.stopTyping(conversationId: conversationId, senderId: userId);
    // keep socket alive if other parts use it; otherwise disconnect:
    // _repo.disconnect();
    super.onClose();
  }

  void handleSendPressed(types.PartialText partial) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: partial.text,
    );
    messages.insert(0, textMessage);

    // update inbox preview optimistically
    _updateConversationLastMessage(partial.text, textMessage.createdAt);

    // emit typing, send message, stop typing
    _repo.startTyping(conversationId: conversationId, senderId: userId);
    _repo.sendMessage(
      conversationId: conversationId,
      senderId: userId,
      text: partial.text,
      attachment: [],
    );
    _repo.stopTyping(conversationId: conversationId, senderId: userId);
  }

  void _updateConversationLastMessage(String text, int? createdAt) {
    try {
      if (!Get.isRegistered<ConversationController>()) return;
      final convCtrl = Get.find<ConversationController>();
      final idx = convCtrl.conversationList.indexWhere((c) => c.id == conversationId);
      if (idx == -1) return;
      final convo = convCtrl.conversationList[idx];

      // Try to assign fields (works if model fields are mutable)
      try {
        (convo as dynamic).latestMessage = text;
        (convo as dynamic).updatedAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;
        // reassign to trigger RxList change
        convCtrl.conversationList[idx] = convo;
        return;
      } catch (_) {}

      // If fields are immutable/no setters, just trigger UI refresh as a fallback
      convCtrl.conversationList.refresh();
    } catch (e) {
      print('[ChatController] _updateConversationLastMessage error: $e');
    }
  }

  /// Call while editing to send typing events (debounce outside for live typing)
  void sendTypingStart() =>
      _repo.startTyping(conversationId: conversationId, senderId: userId);

  void sendTypingStop() =>
      _repo.stopTyping(conversationId: conversationId, senderId: userId);
}
