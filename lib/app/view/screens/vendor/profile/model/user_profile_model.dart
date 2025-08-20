import 'dart:convert';

class UserProfileModel {
  final int? statusCode;
  final String? status;
  final String? message;
  final UserProfileData? data;

  UserProfileModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  factory UserProfileModel.fromRawJson(String str) =>
      UserProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        statusCode: json["statusCode"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : UserProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserProfileData {
  final UserProfile? profile;
  final String? id;
  final String? email;
  final String? phone;
  final bool? isEmailVerified;
  final String? status;
  final bool? isSocial;
  final dynamic fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final bool? isOnline;
  final DateTime? lastSeen;
  final dynamic stripeAccountId;

  UserProfileData({
    this.profile,
    this.id,
    this.email,
    this.phone,
    this.isEmailVerified,
    this.status,
    this.isSocial,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isOnline,
    this.lastSeen,
    this.stripeAccountId,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) =>
      UserProfileData(
        profile: json["profile"] == null
            ? null
            : UserProfile.fromJson(json["profile"]),
        id: json["_id"],
        email: json["email"],
        phone: json["phone"],
        isEmailVerified: json["isEmailVerified"],
        status: json["status"],
        isSocial: json["isSocial"],
        fcmToken: json["fcmToken"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        isOnline: json["isOnline"],
        lastSeen: json["lastSeen"] == null
            ? null
            : DateTime.parse(json["lastSeen"]),
        stripeAccountId: json["stripeAccountId"],
      );

  Map<String, dynamic> toJson() => {
        "profile": profile?.toJson(),
        "_id": id,
        "email": email,
        "phone": phone,
        "isEmailVerified": isEmailVerified,
        "status": status,
        "isSocial": isSocial,
        "fcmToken": fcmToken,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "isOnline": isOnline,
        "lastSeen": lastSeen?.toIso8601String(),
        "stripeAccountId": stripeAccountId,
      };
}

class UserProfile {
  final String? role;
  final UserId? id;

  UserProfile({
    this.role,
    this.id,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        role: json["role"],
        id: json["id"] == null ? null : UserId.fromJson(json["id"]),
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "id": id?.toJson(),
      };
}

class UserId {
  final String? id;
  final String? userId;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? gender;
  final String? image;

  UserId({
    this.id,
    this.userId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.gender,
    this.image,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        userId: json["userId"],
        name: json["name"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        gender: json["gender"],
        image: json["image"]?.toString().replaceAll('\\', '/'),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "name": name,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "gender": gender,
        "image": image,
      };
}


