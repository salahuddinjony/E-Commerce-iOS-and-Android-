class CategoryResponse {
  final int statusCode;
  final String status;
  final String message;
  final List<CategoryData> data;

  CategoryResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      statusCode: json['statusCode'] ?? 0,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((item) => CategoryData.fromJson(item))
              .toList() ??
          [],
    );
  }
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

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: (json['image'] ?? '').replaceAll('\\', '/'), // fix backslashes
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}
