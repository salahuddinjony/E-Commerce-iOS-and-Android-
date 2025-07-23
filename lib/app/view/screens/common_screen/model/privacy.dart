import 'dart:convert';

class PrivacyModel {
  int? statusCode;
  String? status;
  String? message;
  Data? data;

  PrivacyModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  factory PrivacyModel.fromRawJson(String str) => PrivacyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrivacyModel.fromJson(Map<String, dynamic> json) => PrivacyModel(
    statusCode: json["statusCode"],
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? id;
  String? privacyPolicy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
    this.id,
    this.privacyPolicy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    privacyPolicy: json["privacyPolicy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "privacyPolicy": privacyPolicy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
