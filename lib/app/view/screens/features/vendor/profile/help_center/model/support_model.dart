class SupportModel {
  int? statusCode;
  String? status;
  String? message;
  SupportThread? data;

  SupportModel({this.statusCode, this.status, this.message, this.data});

  SupportModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? SupportThread.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SupportThread {
  User? user;
  String? id;
  List<SupportMessage>? messages;
  String? latestSubject;
  bool? isDismissed;
  String? createdAt;
  String? updatedAt;
  int? v;

  SupportThread({
    this.user,
    this.id,
    this.messages,
    this.latestSubject,
    this.isDismissed,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  SupportThread.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    id = json['_id'];
    if (json['messages'] != null) {
      messages = <SupportMessage>[];
      json['messages'].forEach((v) {
        messages!.add(SupportMessage.fromJson(v));
      });
    }
    latestSubject = json['latestSubject'];
    isDismissed = json['isDismissed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['_id'] = id;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    data['latestSubject'] = latestSubject;
    data['isDismissed'] = isDismissed;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}

class User {
  String? id;
  String? fullName;
  String? email;
  String? role;

  User({this.id, this.fullName, this.email, this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['email'] = email;
    data['role'] = role;
    return data;
  }
}

class SupportMessage {
  String? sender;
  String? message;
  String? sentAt;

  SupportMessage({this.sender, this.message, this.sentAt});

  SupportMessage.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    message = json['message'];
    sentAt = json['sentAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['message'] = message;
    data['sentAt'] = sentAt;
    return data;
  }
}
