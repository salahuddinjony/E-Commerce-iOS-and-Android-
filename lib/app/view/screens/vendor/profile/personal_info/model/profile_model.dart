import 'dart:convert';

class ProfileModel {
  int? statusCode;
  String? status;
  String? message;
  ProfileData? data;

  ProfileModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  factory ProfileModel.fromRawJson(String str) => ProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    statusCode: json["statusCode"],
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class ProfileData {
  Profile? profile;
  dynamic stripeAccountId;
  String? id;
  String? email;
  String? phone;
  bool? isEmailVerified;
  String? status;
  bool? isSocial;
  dynamic fcmToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? isOnline;
  DateTime? lastSeen;

  ProfileData({
    this.profile,
    this.stripeAccountId,
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
  });

  factory ProfileData.fromRawJson(String str) => ProfileData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
    stripeAccountId: json["stripeAccountId"],
    id: json["_id"],
    email: json["email"],
    phone: json["phone"],
    isEmailVerified: json["isEmailVerified"],
    status: json["status"],
    isSocial: json["isSocial"],
    fcmToken: json["fcmToken"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isOnline: json["isOnline"],
    lastSeen: json["lastSeen"] == null ? null : DateTime.parse(json["lastSeen"]),
  );

  Map<String, dynamic> toJson() => {
    "profile": profile?.toJson(),
    "stripeAccountId": stripeAccountId,
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
  };
}

class Profile {
  String? role;
  Id? id;

  Profile({
    this.role,
    this.id,
  });

  factory Profile.fromRawJson(String str) => Profile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    role: json["role"],
    id: json["id"] == null ? null : Id.fromJson(json["id"]),
  );

  Map<String, dynamic> toJson() => {
    "role": role,
    "id": id?.toJson(),
  };
}

class Id {
  Location? location;
  String? id;
  String? userId;
  String? name;
  String? address;
  String? description;
  List<String>? deliveryOption;
  List<String>? documents;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Id({
    this.location,
    this.id,
    this.userId,
    this.name,
    this.address,
    this.description,
    this.deliveryOption,
    this.documents,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Id.fromRawJson(String str) => Id.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    id: json["_id"],
    userId: json["userId"],
    name: json["name"],
    address: json["address"],
    description: json["description"],
    deliveryOption: json["deliveryOption"] == null ? [] : List<String>.from(json["deliveryOption"]!.map((x) => x)),
    documents: json["documents"] == null ? [] : List<String>.from(json["documents"]!.map((x) => x)),
    image: json["image"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "_id": id,
    "userId": userId,
    "name": name,
    "address": address,
    "description": description,
    "deliveryOption": deliveryOption == null ? [] : List<dynamic>.from(deliveryOption!.map((x) => x)),
    "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x)),
    "image": image,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromRawJson(String str) => Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}
