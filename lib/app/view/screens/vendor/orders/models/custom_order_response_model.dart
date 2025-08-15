class CustomOrderResponseModel {
  final int statusCode;
  final String status;
  final String message;
  final OrderData data;

  CustomOrderResponseModel({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory CustomOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomOrderResponseModel(
      statusCode: json['statusCode'] ?? 0,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: OrderData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class OrderData {
  final Meta meta;
  final List<Order> data;

  OrderData({
    required this.meta,
    required this.data,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      meta: Meta.fromJson(json['meta'] ?? {}),
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Order.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }
}

class Order {
  final String id;
  final String orderId;
  final String? vendor;
  final String? client;
  final DateTime? deliveryDate;
  final int price;
  final String currency;
  final int quantity;
  final bool isCustom;
  final List<String> designFiles;
  final String status;
  final String deliveryOption;
  final String summery;
  final String paymentStatus;
  final String shippingAddress;
  final String sessionId;
  final String tnxId;
  final List<ExtensionHistory> extentionHistory;
  final List<dynamic> chatHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.orderId,
    this.vendor,
    this.client,
    this.deliveryDate,
    required this.price,
    required this.currency,
    required this.quantity,
    required this.isCustom,
    required this.designFiles,
    required this.status,
    required this.deliveryOption,
    required this.summery,
    required this.paymentStatus,
    required this.shippingAddress,
    required this.sessionId,
    required this.tnxId,
    required this.extentionHistory,
    required this.chatHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      orderId: json['orderId'] ?? '',
      vendor: json['vendor'],
      client: json['client'],
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      price: json['price'] ?? 0,
      currency: json['currency'] ?? '',
      quantity: json['quantity'] ?? 0,
      isCustom: json['isCustom'] ?? false,
      designFiles: List<String>.from(json['designFiles'] ?? []),
      status: json['status'] ?? '',
      deliveryOption: json['deliveryOption'] ?? '',
      summery: json['summery'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      shippingAddress: json['shippingAddress'] ?? '',
      sessionId: json['sessionId'] ?? '',
      tnxId: json['tnxId'] ?? '',
      extentionHistory: (json['extentionHistory'] as List<dynamic>?)
              ?.map((e) => ExtensionHistory.fromJson(e))
              .toList() ??
          [],
      chatHistory: json['chatHistory'] ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'orderId': orderId,
      'vendor': vendor,
      'client': client,
      'deliveryDate': deliveryDate?.toIso8601String(),
      'price': price,
      'currency': currency,
      'quantity': quantity,
      'isCustom': isCustom,
      'designFiles': designFiles,
      'status': status,
      'deliveryOption': deliveryOption,
      'summery': summery,
      'paymentStatus': paymentStatus,
      'shippingAddress': shippingAddress,
      'sessionId': sessionId,
      'tnxId': tnxId,
      'extentionHistory': extentionHistory.map((e) => e.toJson()).toList(),
      'chatHistory': chatHistory,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ExtensionHistory {
  final DateTime lastDate;
  final DateTime newDate;
  final String reason;
  final String status;

  ExtensionHistory({
    required this.lastDate,
    required this.newDate,
    required this.reason,
    required this.status,
  });

  factory ExtensionHistory.fromJson(Map<String, dynamic> json) {
    return ExtensionHistory(
      lastDate: DateTime.parse(json['lastDate']),
      newDate: DateTime.parse(json['newDate']),
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastDate': lastDate.toIso8601String(),
      'newDate': newDate.toIso8601String(),
      'reason': reason,
      'status': status,
    };
  }
} 