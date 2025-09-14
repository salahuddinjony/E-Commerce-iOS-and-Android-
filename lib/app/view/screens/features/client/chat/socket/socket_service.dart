import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Lightweight SocketService used by UI and repositories.
/// - Connects to server
/// - Emits join/typing/send-message events
/// - Exposes streams for incoming messages and typing events
class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  IO.Socket? _socket;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onMessage => _messageController.stream;
  Stream<Map<String, dynamic>> get onTyping => _typingController.stream;

  void connect(String url) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.on('connect', (_) => print('[SocketService] connected'));
    _socket!.on('disconnect', (_) => print('[SocketService] disconnected'));
    _socket!.on('connect_error', (err) => print('[SocketService] connect_error: $err'));

    // Incoming message events: adapt if your backend uses different event names.
    _socket!.on('message', (data) {
      if (data is Map) _messageController.add(Map<String, dynamic>.from(data));
    });
    _socket!.on('receive-message', (data) {
      if (data is Map) _messageController.add(Map<String, dynamic>.from(data));
    });

    // Typing events
    _socket!.on('typing', (data) {
      if (data is Map) _typingController.add(Map<String, dynamic>.from(data));
    });
    _socket!.on('stop-typing', (data) {
      if (data is Map) _typingController.add(Map<String, dynamic>.from(data));
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  /// Generic emitter used by repositories for custom events (fixes emitRaw missing error).
  void emitRaw(String event, [dynamic data]) {
    if (_socket == null) {
      print('[SocketService] emitRaw: socket is null, event=$event');
      return;
    }
    try {
      _socket!.emit(event, data);
    } catch (e) {
      print('[SocketService] emitRaw error: $e');
    }
  }
  void leaveChat({required String roomId, required String userId}) {
    emitRaw('leave-chat', {'roomId': roomId, 'userId': userId});
  }

  void joinChat({required String roomId, required String userId}) {
    emitRaw('join-chat', {'roomId': roomId, 'userId': userId});
  }

  void startTyping({required String conversationId, required String senderId}) {
    emitRaw('typing', {'conversationId': conversationId, 'senderId': senderId});
  }

  void stopTyping({required String conversationId, required String senderId}) {
    emitRaw('stop-typing', {'conversationId': conversationId, 'senderId': senderId});
  }

  void sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    List<String>? attachment,
  }) {
    final payload = {
      'conversationId': conversationId,
      'senderId': senderId,
      'text': text,
      'attachment': attachment ?? [],
    };
    emitRaw('send-message', payload);
  }

  void dispose() {
    _messageController.close();
    _typingController.close();
    disconnect();
  }
}