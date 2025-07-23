import 'dart:convert';

class AboutUsModel {
  int? statusCode;
  String? status;
  String? message;
  AboutUsData? data;

  AboutUsModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  factory AboutUsModel.fromRawJson(String str) => AboutUsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
    statusCode: json["statusCode"],
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : AboutUsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class AboutUsData {
  String? id;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  AboutUsData({
    this.id,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory AboutUsData.fromRawJson(String str) => AboutUsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AboutUsData.fromJson(Map<String, dynamic> json) => AboutUsData(
    id: json["_id"],
    description: json["description"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "description": description,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
