import 'dart:convert';

class TermsModel {
  int? statusCode;
  String? status;
  String? message;
  Data? data;

  TermsModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  factory TermsModel.fromRawJson(String str) => TermsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TermsModel.fromJson(Map<String, dynamic> json) => TermsModel(
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
  String? termsCondition;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
    this.id,
    this.termsCondition,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    termsCondition: json["termsCondition"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "termsCondition": termsCondition,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
