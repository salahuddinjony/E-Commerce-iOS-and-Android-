import 'dart:convert';

class UserProfileModel {
  final int? statusCode;
  final String? status;
  final String? message;
  final Meta? meta;
  final List<UserProfileData>? data;

  UserProfileModel({
    this.statusCode,
    this.status,
    this.message,
    this.meta,
    this.data,
  });

  factory UserProfileModel.fromRawJson(String str) =>
      UserProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        statusCode: json["statusCode"],
        status: json["status"],
        message: json["message"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null
            ? null
            : List<UserProfileData>.from(
                json["data"].map((x) => UserProfileData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "status": status,
        "message": message,
        "meta": meta?.toJson(),
        "data": data?.map((x) => x.toJson()).toList(),
      };
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  Meta({this.page, this.limit, this.total, this.totalPages});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
        "totalPages": totalPages,
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
  final Location? location;
  final String? address;
  final String? description;
  final List<String>? deliveryOption;
  final List<String>? documents;

  UserId({
    this.id,
    this.userId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.gender,
    this.image,
    this.location,
    this.address,
    this.description,
    this.deliveryOption,
    this.documents,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        userId: json["userId"],
        name: json["name"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"].toString()),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"].toString()),
        v: json["__v"],
        gender: json["gender"],
        image: json["image"]?.toString().replaceAll('\\', '/'),
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        address: json["address"],
        description: json["description"],
        deliveryOption: json["deliveryOption"] == null
            ? null
            : List<String>.from(json["deliveryOption"].map((x) => x.toString())),
        documents: json["documents"] == null
            ? null
            : List<String>.from(json["documents"].map((x) => x.toString().replaceAll('\\', '/'))),
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
        "location": location?.toJson(),
        "address": address,
        "description": description,
        "deliveryOption": deliveryOption,
        "documents": documents,
      };
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? null
            : List<double>.from(json["coordinates"].map((x) => x is num ? x.toDouble() : double.tryParse(x.toString()))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates,
      };
}


