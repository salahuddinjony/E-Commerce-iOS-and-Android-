// ...existing code...
import 'dart:convert';

class ConversationResponse {
  final int? statusCode;
  final String? status;
  final String? message;
  final List<Conversation> data;

  ConversationResponse({
    this.statusCode,
    this.status,
    this.message,
    List<Conversation>? data,
  }) : data = data ?? [];

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    return ConversationResponse(
      statusCode: json['statusCode'] is int ? json['statusCode'] as int : int.tryParse('${json['statusCode']}'),
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Conversation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'status': status,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class Conversation {
  final String id;
  final List<Member> members;
  final String? latestMessage;
  final List<UnreadCount> unreadCounts;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Conversation({
    String? id,
    List<Member>? members,
    this.latestMessage,
    List<UnreadCount>? unreadCounts,
    this.createdAt,
    this.updatedAt,
    this.v,
  })  : id = id ?? '',
        members = members ?? [],
        unreadCounts = unreadCounts ?? [];

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: (json['_id'] as String?) ?? '',
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      latestMessage: (json['latestmessage'] as String?) ?? '',
      unreadCounts: (json['unreadCounts'] as List<dynamic>?)
              ?.map((e) => UnreadCount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] is int ? json['__v'] as int : int.tryParse('${json['__v']}'),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'members': members.map((m) => m.toJson()).toList(),
        'latestmessage': latestMessage,
        'unreadCounts': unreadCounts.map((u) => u.toJson()).toList(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
      };
}

class Member {
  final Profile? profile;
  final String id;

  Member({this.profile, String? id}) : id = id ?? '';

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      profile: json['profile'] != null ? Profile.fromJson(json['profile'] as Map<String, dynamic>) : null,
      id: (json['_id'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'profile': profile?.toJson(),
        '_id': id,
      };
}

class Profile {
  final String? role;
  final ProfileId? id;

  Profile({this.role, this.id});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      role: json['role'] as String?,
      id: json['id'] != null ? ProfileId.fromJson(json['id'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'id': id?.toJson(),
      };
}

class ProfileId {
  final String id;
  final String? name;
  final String? image;

  ProfileId({String? id, this.name, this.image}) : id = id ?? '';

  factory ProfileId.fromJson(Map<String, dynamic> json) {
    return ProfileId(
      id: (json['_id'] as String?) ?? '',
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'image': image,
      };
}

class UnreadCount {
  final String userId;
  final int count;
  final String id;

  UnreadCount({String? userId, int? count, String? id})
      : userId = userId ?? '',
        count = count ?? 0,
        id = id ?? '';

  factory UnreadCount.fromJson(Map<String, dynamic> json) {
    return UnreadCount(
      userId: (json['userId'] as String?) ?? '',
      count: json['count'] is int ? json['count'] as int : int.tryParse('${json['count']}') ?? 0,
      id: (json['_id'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'count': count,
        '_id': id,
      };
}
// ...existing code...