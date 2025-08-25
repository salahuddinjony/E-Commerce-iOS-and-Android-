class CategoryResponse {
  final int statusCode;
  final String status;
  final String message;
  final CategoryWrapper? wrapper;

  CategoryResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.wrapper,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return CategoryResponse(
      statusCode: json['statusCode'] ?? 0,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      wrapper:
          raw is Map<String, dynamic> ? CategoryWrapper.fromJson(raw) : null,
    );
  }
}

class CategoryWrapper {
  final Meta? meta;
  final List<CategoryData> items;

  CategoryWrapper({this.meta, required this.items});

  factory CategoryWrapper.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List?) ?? [];
    return CategoryWrapper(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      items: list
          .map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  Meta({this.page, this.limit, this.total, this.totalPages});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json['page'],
        limit: json['limit'],
        total: json['total'],
        totalPages: json['totalPages'],
      );
}

class CategoryData {
  final String id;
  final String name;
  final String image;
  final String createdAt;
  final String updatedAt;
  final int v;

  CategoryData({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        image: (json['image'] ?? '').replaceAll('\\', '/'),
        createdAt: json['createdAt'] ?? '',
        updatedAt: json['updatedAt'] ?? '',
        v: json['__v'] ?? 0,
      );
}
