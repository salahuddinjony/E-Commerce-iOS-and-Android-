import 'dart:convert';

String? _asString(dynamic v) {
  if (v == null) return null;
  return v is String ? v : v.toString();
}

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is String) {
    final lower = v.toLowerCase();
    if (lower == 'true') return true;
    if (lower == 'false') return false;
  }
  if (v is num) return v != 0;
  return null;
}

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is String) return int.tryParse(v);
  if (v is double) return v.toInt();
  return null;
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

DateTime? _asDateTime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}

List<String>? _listOfString(dynamic v) {
  if (v == null) return null;
  if (v is List) {
    return v.map((e) => e == null ? '' : e.toString()).where((s) => s.isNotEmpty).toList();
  }
  // single string case
  if (v is String && v.isNotEmpty) return [v];
  return null;
}

class NearestVendorResponse {
  final int? statusCode;
  final String? status;
  final String? message;
  final Meta? meta;
  final List<UserItem>? data;

  NearestVendorResponse({
    this.statusCode,
    this.status,
    this.message,
    this.meta,
    this.data,
  });

  factory NearestVendorResponse.fromJson(Map<String, dynamic> json) {
    return NearestVendorResponse(
      statusCode: _asInt(json['statusCode']),
      status: _asString(json['status']),
      message: _asString(json['message']),
      meta: json['meta'] is Map<String, dynamic> ? Meta.fromJson(json['meta']) : null,
      data: json['data'] is List
          ? (json['data'] as List).map((e) {
              if (e is Map<String, dynamic>) return UserItem.fromJson(e);
              if (e is Map) return UserItem.fromJson(Map<String, dynamic>.from(e));
              return null;
            }).whereType<UserItem>().toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'status': status,
      'message': message,
      'meta': meta?.toJson(),
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }

  static NearestVendorResponse fromRawJson(String str) =>
      NearestVendorResponse.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  Meta({this.page, this.limit, this.total, this.totalPages});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: _asInt(json['page']),
        limit: _asInt(json['limit']),
        total: _asInt(json['total']),
        totalPages: _asInt(json['totalPages']),
      );

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'total': total,
        'totalPages': totalPages,
      };
}

class UserItem {
  final Profile? profile;
  final String? id;
  final String? email;
  final String? phone;
  final bool? isEmailVerified;
  final String? status;
  final bool? isSocial;
  final String? fcmToken;
  final bool? isOnline;
  final String? stripeAccountId;
  final DateTime? lastSeen;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserItem({
    this.profile,
    this.id,
    this.email,
    this.phone,
    this.isEmailVerified,
    this.status,
    this.isSocial,
    this.fcmToken,
    this.isOnline,
    this.stripeAccountId,
    this.lastSeen,
    this.createdAt,
    this.updatedAt,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        profile: json['profile'] is Map<String, dynamic> ? Profile.fromJson(json['profile']) : null,
        id: _asString(json['_id']),
        email: _asString(json['email']),
        phone: _asString(json['phone']),
        isEmailVerified: _asBool(json['isEmailVerified']),
        status: _asString(json['status']),
        isSocial: _asBool(json['isSocial']),
        fcmToken: _asString(json['fcmToken']),
        isOnline: _asBool(json['isOnline']),
        stripeAccountId: _asString(json['stripeAccountId']),
        lastSeen: _asDateTime(json['lastSeen']),
        createdAt: _asDateTime(json['createdAt']),
        updatedAt: _asDateTime(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'profile': profile?.toJson(),
        '_id': id,
        'email': email,
        'phone': phone,
        'isEmailVerified': isEmailVerified,
        'status': status,
        'isSocial': isSocial,
        'fcmToken': fcmToken,
        'isOnline': isOnline,
        'stripeAccountId': stripeAccountId,
        'lastSeen': lastSeen?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class Profile {
  final String? role;
  final ProfileId? id;

  Profile({this.role, this.id});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        role: _asString(json['role']),
        id: json['id'] is Map<String, dynamic> ? ProfileId.fromJson(json['id']) : null,
      );

  Map<String, dynamic> toJson() => {
        'role': role,
        'id': id?.toJson(),
      };
}

class ProfileId {
  final String? id;
  final String? name;
  final String? address;
  final String? description;
  final List<String>? deliveryOption;
  final List<String>? documents;
  final LocationModel? location;
  final String? image;

  ProfileId({
    this.id,
    this.name,
    this.address,
    this.description,
    this.deliveryOption,
    this.documents,
    this.location,
    this.image,
  });

  factory ProfileId.fromJson(Map<String, dynamic> json) {
    // documents in payload may contain backslashes; normalize and filter empties
    final rawDocs = _listOfString(json['documents']);
    final docs = rawDocs
        ?.map((s) => s.replaceAll(r'\', '/').trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // deliveryOption may be string or list
    final delivery = json['deliveryOption'] is List
        ? List<String>.from((json['deliveryOption'] as List).map((e) => e.toString()))
        : (json['deliveryOption'] is String ? [json['deliveryOption'] as String] : null);

    return ProfileId(
      id: _asString(json['_id']) ?? _asString(json['id']),
      name: _asString(json['name']),
      address: _asString(json['address']),
      description: _asString(json['description']),
      deliveryOption: delivery,
      documents: docs,
      location: json['location'] is Map<String, dynamic> ? LocationModel.fromJson(json['location']) : null,
      image: _asString(json['image']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'address': address,
        'description': description,
        'deliveryOption': deliveryOption,
        'documents': documents,
        'location': location?.toJson(),
        'image': image,
      };
}

class LocationModel {
  final String? type;
  final List<double>? coordinates;

  LocationModel({this.type, this.coordinates});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    List<double>? coords;
    if (json['coordinates'] is List) {
      coords = (json['coordinates'] as List).map((e) {
        final d = _asDouble(e);
        return d ?? 0.0;
      }).toList();
    }
    return LocationModel(
      type: _asString(json['type']),
      coordinates: coords,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}