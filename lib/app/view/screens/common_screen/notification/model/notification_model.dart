import 'dart:convert';

class NotificationModel {
  int? statusCode;
  String? status;
  String? message;
  List<NotificationData>? data;

  NotificationModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  factory NotificationModel.fromRawJson(String str) => NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    statusCode: json["statusCode"],
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<NotificationData>.from(json["data"]!.map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NotificationData {
  NotificationContent? content;
  String? id;
  String? consumer;
  bool? isDismissed;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  NotificationData({
    this.content,
    this.id,
    this.consumer,
    this.isDismissed,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory NotificationData.fromRawJson(String str) => NotificationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    content: json["content"] == null ? null : NotificationContent.fromJson(json["content"]),
    id: json["_id"],
    consumer: json["consumer"],
    isDismissed: json["isDismissed"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "content": content?.toJson(),
    "_id": id,
    "consumer": consumer,
    "isDismissed": isDismissed,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class NotificationContent {
  NotificationSource? source;
  String? title;
  String? message;

  NotificationContent({
    this.source,
    this.title,
    this.message,
  });

  factory NotificationContent.fromRawJson(String str) => NotificationContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationContent.fromJson(Map<String, dynamic> json) => NotificationContent(
    source: json["source"] == null ? null : NotificationSource.fromJson(json["source"]),
    title: json["title"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "source": source?.toJson(),
    "title": title,
    "message": message,
  };
}

class NotificationSource {
  String? type;

  NotificationSource({
    this.type,
  });

  factory NotificationSource.fromRawJson(String str) => NotificationSource.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationSource.fromJson(Map<String, dynamic> json) => NotificationSource(
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
  };
}

// Response models for dismiss and clear operations
class NotificationDismissResponse {
  int? statusCode;
  String? status;
  String? message;

  NotificationDismissResponse({
    this.statusCode,
    this.status,
    this.message,
  });

  factory NotificationDismissResponse.fromRawJson(String str) => NotificationDismissResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationDismissResponse.fromJson(Map<String, dynamic> json) => NotificationDismissResponse(
    statusCode: json["statusCode"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "message": message,
  };
}

class NotificationClearResponse {
  int? statusCode;
  String? status;
  String? message;

  NotificationClearResponse({
    this.statusCode,
    this.status,
    this.message,
  });

  factory NotificationClearResponse.fromRawJson(String str) => NotificationClearResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationClearResponse.fromJson(Map<String, dynamic> json) => NotificationClearResponse(
    statusCode: json["statusCode"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "message": message,
  };
}
