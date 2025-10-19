class InitiatePaymentResponse {
  final int statusCode;
  final String status;
  final String message;
  final PaymentData? data;

  InitiatePaymentResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    this.data,
  });

  factory InitiatePaymentResponse.fromJson(Map<String, dynamic> json) {
    return InitiatePaymentResponse(
      statusCode: json['statusCode'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] != null 
          ? PaymentData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class PaymentData {
  final String url;

  PaymentData({required this.url});

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
