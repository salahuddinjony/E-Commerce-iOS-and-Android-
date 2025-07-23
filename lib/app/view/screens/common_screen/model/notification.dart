import 'dart:convert';

class NotificationModel {
  int? statusCode;
  String? status;
  String? message;
  List<NotificationList>? data;

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
    data: json["data"] == null ? [] : List<NotificationList>.from(json["data"]!.map((x) => NotificationList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NotificationList {
  Content? content;
  String? id;
  String? consumer;
  bool? isDismissed;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  NotificationList({
    this.content,
    this.id,
    this.consumer,
    this.isDismissed,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory NotificationList.fromRawJson(String str) => NotificationList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
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

class Content {
  Source? source;
  String? title;
  String? message;

  Content({
    this.source,
    this.title,
    this.message,
  });

  factory Content.fromRawJson(String str) => Content.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    source: json["source"] == null ? null : Source.fromJson(json["source"]),
    title: json["title"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "source": source?.toJson(),
    "title": title,
    "message": message,
  };
}

class Source {
  String? type;

  Source({
    this.type,
  });

  factory Source.fromRawJson(String str) => Source.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Source.fromJson(Map<String, dynamic> json) => Source(
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
  };
}
