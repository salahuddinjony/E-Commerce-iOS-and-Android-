import 'package:meta/meta.dart';

@immutable
class MessagesResponse {
  final int statusCode;
  final String status;
  final String message;
  final List<ChatMessage> data;

  const MessagesResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {
    return MessagesResponse(
      statusCode: json['statusCode'] is int ? json['statusCode'] as int : int.tryParse('${json['statusCode']}') ?? 0,
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: (json['data'] is List)
          ? List<ChatMessage>.from((json['data'] as List).map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)))
          : <ChatMessage>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'status': status,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

@immutable
class ChatMessage {
  final String id; // maps to _id
  final String conversationId;
  final Sender? sender; // senderId object
  // Raw sender id when the server returns a string or nested object containing an id
  final String? senderId;
  final String text;
  final List<String> attachment;
  final List<SeenBy> seenBy;
  final String? replyTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v; // __v

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.text,
    required this.attachment,
    required this.seenBy,
    required this.replyTo,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.senderId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic v) {
      if (v is String) {
        return DateTime.tryParse(v) ?? DateTime.now();
      } else if (v is int) {
        return DateTime.fromMillisecondsSinceEpoch(v);
      } else {
        return DateTime.now();
      }
    }

    // try to extract a raw sender id when available (string or nested _id)
    String? parseSenderId(dynamic s) {
      try {
        if (s == null) return null;
        if (s is String) return s;
        if (s is Map) {
          if (s.containsKey('_id')) return s['_id']?.toString();
          if (s.containsKey('id')) return s['id']?.toString();
          if (s.containsKey('user')) return s['user']?.toString();
        }
      } catch (_) {}
      return null;
    }

    final senderIdFromSenderIdField = parseSenderId(json['senderId']);
    final senderIdFromSenderField = parseSenderId(json['sender']);

    return ChatMessage(
      id: json['_id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      sender: json['senderId'] is Map
          ? Sender.fromJson(json['senderId'] as Map<String, dynamic>)
          : (json['sender'] is Map ? Sender.fromJson(json['sender'] as Map<String, dynamic>) : null),
      text: json['text']?.toString() ?? '',
      attachment: (json['attachment'] is List) ? List<String>.from((json['attachment'] as List).map((e) => e?.toString() ?? '')) : <String>[],
      seenBy: (json['seenBy'] is List) ? List<SeenBy>.from((json['seenBy'] as List).map((e) => SeenBy.fromJson(e as Map<String, dynamic>))) : <SeenBy>[],
      replyTo: json['replyTo']?.toString(),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      v: (json['__v'] is int) ? json['__v'] as int : int.tryParse('${json['__v']}') ?? 0,
      senderId: senderIdFromSenderIdField ?? senderIdFromSenderField,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'conversationId': conversationId,
        'senderId': sender?.toJson(),
        'text': text,
        'attachment': attachment,
        'seenBy': seenBy.map((e) => e.toJson()).toList(),
        'replyTo': replyTo,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
      };
}

@immutable
class Sender {
  final Profile? profile;

  const Sender({required this.profile});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      profile: json['profile'] is Map ? Profile.fromJson(json['profile'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'profile': profile?.toJson(),
      };
}

@immutable
class Profile {
  final String role;
  final ProfileId? id;

  const Profile({required this.role, required this.id});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      role: json['role']?.toString() ?? '',
      id: json['id'] is Map ? ProfileId.fromJson(json['id'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'id': id?.toJson(),
      };
}

@immutable
class ProfileId {
  final String name;
  final String image;

  const ProfileId({required this.name, required this.image});

  factory ProfileId.fromJson(Map<String, dynamic> json) {
    return ProfileId(
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
      };
}

@immutable
class SeenBy {
  final String id; // _id of seen entry
  final String user;
  final DateTime? seenAt;

  const SeenBy({required this.id, required this.user, required this.seenAt});

  factory SeenBy.fromJson(Map<String, dynamic> json) {
    DateTime? parseNullableDate(dynamic v) {
      if (v is String) return DateTime.tryParse(v);
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return null;
    }

    return SeenBy(
      id: json['_id']?.toString() ?? '',
      user: json['user']?.toString() ?? '',
      seenAt: parseNullableDate(json['seenAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user,
        'seenAt': seenAt?.toIso8601String(),
      };
}