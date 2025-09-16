import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:local/app/view/screens/features/client/chat/inbox_screen/controller/conversation_controller.dart';
import 'package:local/app/view/screens/features/client/chat/inbox_screen/chat_screen/model/chat_message.dart';
import 'package:local/app/view/screens/features/client/chat/socket_io/repositories/chat_repository.dart'
    show ChatRepository;
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  final String conversationId;
  final String userId;
  final String userRole;
  final ChatRepository repo;
  late final types.User user;

  ChatController({
    required this.conversationId,
    required this.userId,
    required this.userRole,
    ChatRepository? repository,
  }) : repo = repository ?? ChatRepository() {
    // Use role as the author.id so side/layout decisions can be made by role.
    user = types.User(id: userRole, firstName: 'Me');
  }
  
  final messages = RxList<types.Message>(<types.Message>[]);
  final isTyping = false.obs;
  // new loading flag to indicate initial history fetch
  final isLoading = true.obs;

  StreamSubscription<ChatMessage>? msgSub;
  StreamSubscription<Map<String, dynamic>>? typingSub;

  // Helper: determine role for a sender object (history/incoming)
  String _roleForSender(dynamic sender, {String fallbackRole = 'other'}) {
    try {
      // If sender is ChatMessage
      if (sender is ChatMessage) {
        final r = sender.sender?.profile?.role;
        if (r != null && r.isNotEmpty) return r;
        // fallback: if sender information missing but senderId equals current user id? (rare)
      }

      // If sender is Sender model
      if (sender is Sender) {
        final r = sender.profile?.role;
        if (r != null && r.isNotEmpty) return r;
      }

      // If it's a Map coming from repo or socket
      if (sender is Map) {
        final role = (sender['profile'] is Map)
            ? (sender['profile']['role']?.toString())
            : (sender['role']?.toString());
        if (role != null && role.isNotEmpty) return role;
      }

      // Some payload shapes use nested fields like senderId.profile.role
      try {
        final r = (sender as dynamic).sender?.profile?.role ??
            (sender as dynamic).senderId?.profile?.role ??
            (sender as dynamic).profile?.role ??
            (sender as dynamic).role;
        if (r != null && r.toString().isNotEmpty) return r.toString();
      } catch (_) {}
    } catch (_) {}

    return fallbackRole;
  }

  // Public helper UI can call to know which side a message should render on.
  // Returns true when message should appear on the "right" (same role as current user).
  bool isMessageRight(types.Message message) {
    try {
      final meta =
          (message as dynamic).metadata as Map<String, dynamic>? ?? {};
      final role = meta['role']?.toString();
      if (role != null && role.isNotEmpty) return role == userRole;
    } catch (_) {}
    // fallback to author id (we store role as author.id now)
    return message.author.id == userRole;
  }

  @override
  void onInit() {
    super.onInit();

    // connect to socket and join room
    repo.connect('https://gmosley-uteehub-backend.onrender.com');

    // load history first (if available) so UI shows past messages

    // setup user on socket
    repo.setupUser(userId);
    
    isLoading.value = true;
    repo.fetchMessages(conversationId).then((history) {

      // map history messages to flutter_chat_types messages
      // ensure createdAt is milliseconds since epoch
      
      for (final h in history.reversed) {
        // determine role for this history message (fall back to 'other' or current userRole)
        final senderRole = _roleForSender(h, fallbackRole: h.sender != null && (h.sender?.profile?.role == userRole) ? userRole : 'other');

        // Use senderRole as author.id so alignment can be decided by role reliably.
        final msg = types.TextMessage(
          author: types.User(
            id: senderRole,
            firstName: h.sender?.profile?.id?.name ?? '',
          ),
          createdAt:DateTime.now().millisecondsSinceEpoch,
          id: h.id.isNotEmpty ? h.id : const Uuid().v4(),
          text: h.text,
          metadata: {'role': senderRole},
        );

        // newest first expected by UI, but we're iterating reversed to keep chronology
        messages.insert(0, msg);
      }
    }).catchError((e) {
      debugPrint('history load error: $e');
    }).whenComplete(() {
      // now join socket to receive live messages
      repo.joinChat(roomId: conversationId, userId: userId);
      // initial load finished (either success or error)
      isLoading.value = false;
    });

    msgSub = repo.onMessage.listen((chatMsg) {
        // Ignore server echoes of messages we just sent: if the incoming chatMsg
        // reports a sender id that matches our userId, it's likely the same
        // message we optimistically added locally. Filtering avoids duplicate
        // display and flicker.
        final incomingSenderId = extractSenderId(chatMsg);
        if (incomingSenderId != null && incomingSenderId == userId) {
          // We sent this message — server echo. Ignore.
          return;
        }
      // chatMsg is ChatMessage from repository
      // determine incoming sender role
      final incomingRole = _roleForSender(chatMsg, fallbackRole: chatMsg.sender != null && (chatMsg.sender?.profile?.role == userRole) ? userRole : 'other');

      // Avoid duplicates
      if (chatMsg.id.isNotEmpty && messages.any((m) => m.id == chatMsg.id)) return;

      final msg = types.TextMessage(
        // Use role as author id for consistent side calculation
        author: types.User(
          id: incomingRole,
          firstName: chatMsg.sender?.profile?.id?.name ?? '',
        ),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: chatMsg.id.isNotEmpty ? chatMsg.id : const Uuid().v4(),
        text: chatMsg.text,
        metadata: {'role': incomingRole},
      );

      // newest first
      messages.insert(0, msg);

      // update inbox preview for this conversation
      updateConversationLastMessage(chatMsg.text,(chatMsg.createdAt).millisecondsSinceEpoch);
    });

    typingSub = repo.onTyping.listen((data) {
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
    msgSub?.cancel();
    typingSub?.cancel();
    repo.stopTyping(conversationId: conversationId, senderId: userId);
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
      metadata: {'role': userRole},
    );
    messages.insert(0, textMessage);

    // update inbox preview optimistically
    updateConversationLastMessage(partial.text, textMessage.createdAt);

    // emit typing, send message, stop typing
    repo.startTyping(conversationId: conversationId, senderId: userId);
    repo.sendMessage(
      conversationId: conversationId,
      senderId: userId,
      text: partial.text,
      attachment: [],
    );
    repo.stopTyping(conversationId: conversationId, senderId: userId);
  }

  void updateConversationLastMessage(String text, int? createdAt) {
    try {
      if (!Get.isRegistered<ConversationController>()) return;
      final convCtrl = Get.find<ConversationController>();
      final idx =
          convCtrl.conversationList.indexWhere((c) => c.id == conversationId);
      if (idx == -1) return;
      final convo = convCtrl.conversationList[idx];

      // Try to assign fields (works if model fields are mutable)
      try {
        (convo as dynamic).latestMessage = text;
        (convo as dynamic).updatedAt =
            createdAt ?? DateTime.now().millisecondsSinceEpoch;
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
      repo.startTyping(conversationId: conversationId, senderId: userId);

  void sendTypingStop() =>
      repo.stopTyping(conversationId: conversationId, senderId: userId);

  /// Extracts the senderId from a ChatMessage, handling possible nulls.
  String? extractSenderId(ChatMessage chatMsg) {
    try {
      // Prefer raw senderId parsed from the payload (covers string ids)
      if (chatMsg.senderId != null && chatMsg.senderId!.isNotEmpty) return chatMsg.senderId;

      // Fallback to nested sender.profile.id when available
      if (chatMsg.sender != null && chatMsg.sender?.profile?.id != null) {
        return chatMsg.sender?.profile?.id?.toString();
      }
    } catch (_) {}
    return null;
  }
}
