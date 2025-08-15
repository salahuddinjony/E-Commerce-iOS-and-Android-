class GeneralOrderResponseModel {
  final int statusCode;
  final String status;
  final String message;
  final GeneralOrderData data;

  GeneralOrderResponseModel({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory GeneralOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return GeneralOrderResponseModel(
      statusCode: json['statusCode'] ?? 0,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: GeneralOrderData.fromJson(json['data'] ?? {}),
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

class GeneralOrderData {
  final Meta meta;
  final List<GeneralOrder> data;

  GeneralOrderData({
    required this.meta,
    required this.data,
  });

  factory GeneralOrderData.fromJson(Map<String, dynamic> json) {
    return GeneralOrderData(
      meta: Meta.fromJson(json['meta'] ?? {}),
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => GeneralOrder.fromJson(e))
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

class GeneralOrder {
  final String id;
  final Vendor vendor;
  final Client client;
  final int price;
  final String currency;
  final List<Product> products;
  final String status;
  final String paymentStatus;
  final String shippingAddress;
  final String sessionId;
  final String tnxId;
  final DateTime createdAt;
  final DateTime updatedAt;

  GeneralOrder({
    required this.id,
    required this.vendor,
    required this.client,
    required this.price,
    required this.currency,
    required this.products,
    required this.status,
    required this.paymentStatus,
    required this.shippingAddress,
    required this.sessionId,
    required this.tnxId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GeneralOrder.fromJson(Map<String, dynamic> json) {
    return GeneralOrder(
      id: json['_id'] ?? '',
      vendor: Vendor.fromJson(json['vendor'] ?? {}),
      client: Client.fromJson(json['client'] ?? {}),
      price: json['price'] ?? 0,
      currency: json['currency'] ?? '',
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e))
              .toList() ??
          [],
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      shippingAddress: json['shippingAddress'] ?? '',
      sessionId: json['sessionId'] ?? '',
      tnxId: json['tnxId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vendor': vendor.toJson(),
      'client': client.toJson(),
      'price': price,
      'currency': currency,
      'products': products.map((e) => e.toJson()).toList(),
      'status': status,
      'paymentStatus': paymentStatus,
      'shippingAddress': shippingAddress,
      'sessionId': sessionId,
      'tnxId': tnxId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper getters for easier access
  String get vendorName => vendor.profile.id.name;
  String? get vendorImage => vendor.profile.id.image;
  String get clientName => client.profile.id.name;
  String? get clientImage => client.profile.id.image;
  int get totalQuantity => products.fold(0, (sum, product) => sum + product.quantity);
}

class Vendor {
  final Profile profile;
  final String id;
  final String email;
  final String phone;

  Vendor({
    required this.profile,
    required this.id,
    required this.email,
    required this.phone,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      profile: Profile.fromJson(json['profile'] ?? {}),
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile': profile.toJson(),
      '_id': id,
      'email': email,
      'phone': phone,
    };
  }
}

class Client {
  final Profile profile;
  final String id;
  final String email;
  final String phone;

  Client({
    required this.profile,
    required this.id,
    required this.email,
    required this.phone,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      profile: Profile.fromJson(json['profile'] ?? {}),
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile': profile.toJson(),
      '_id': id,
      'email': email,
      'phone': phone,
    };
  }
}

class Profile {
  final String role;
  final ProfileId id;

  Profile({
    required this.role,
    required this.id,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      role: json['role'] ?? '',
      id: ProfileId.fromJson(json['id'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'id': id.toJson(),
    };
  }
}

class ProfileId {
  final String name;
  final String? image;
  final String? gender;

  ProfileId({
    required this.name,
    this.image,
    this.gender,
  });

  factory ProfileId.fromJson(Map<String, dynamic> json) {
    return ProfileId(
      name: json['name'] ?? '',
      image: json['image'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'gender': gender,
    };
  }
}

class Product {
  final String? productId;
  final int quantity;
  final String id;

  Product({
    this.productId,
    required this.quantity,
    required this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      quantity: json['quantity'] ?? 0,
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      '_id': id,
    };
  }
} 