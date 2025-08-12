class ProductResponse {
  final Meta meta;
  final List<ProductItem> data;

  ProductResponse({required this.meta, required this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      meta: Meta.fromJson(json['meta']),
      data: (json['data'] as List)
          .map((item) => ProductItem.fromJson(item))
          .toList(),
    );
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
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }
}

class ProductItem {
  final String id;
  final String name;
  final String category;
  final bool isFeatured;
  final num price;
  final String currency;
  final int quantity;
  final List<String> size;
  final List<String> images;
  final List<String> colors;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.isFeatured,
    required this.price,
    required this.currency,
    required this.quantity,
    required this.size,
    required this.images,
    required this.colors,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['_id'],
      name: json['name'],
      category: json['category'],
      isFeatured: json['isFeatured'],
      price: json['price'],
      currency: json['currency'],
      quantity: json['quantity'],
      size: List<String>.from(json['size']),
      images: (json['images'] as List).map((image) => image.toString().replaceAll('\\', '/')).toList(),
      colors: List<String>.from(json['colors']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}