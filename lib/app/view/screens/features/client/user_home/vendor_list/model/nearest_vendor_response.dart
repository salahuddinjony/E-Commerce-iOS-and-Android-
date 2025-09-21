class VendorResponse {
  final int? statusCode;
  final String? status;
  final String? message;
  final List<Vendor>? data;

  VendorResponse({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  factory VendorResponse.fromJson(Map<String, dynamic> json) {
    return VendorResponse(
      statusCode: json['statusCode'] as int?,
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Vendor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class Vendor {
  final Location? location;
  final String? id;
  final User? userId;
  final String? name;
  final String? address;
  final String? description;
  final List<String>? deliveryOption;
  final List<String>? documents;
  final String? image;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Vendor({
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

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      id: json['_id'] as String?,
      userId: json['userId'] != null
          ? User.fromJson(json['userId'])
          : null,
      name: json['name'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
      deliveryOption: (json['deliveryOption'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      image: json['image'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location?.toJson(),
      '_id': id,
      'userId': userId?.toJson(),
      'name': name,
      'address': address,
      'description': description,
      'deliveryOption': deliveryOption,
      'documents': documents,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class User {
  final String? id;
  final String? email;
  final String? phone;

  User({
    this.id,
    this.email,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'phone': phone,
    };
  }
}