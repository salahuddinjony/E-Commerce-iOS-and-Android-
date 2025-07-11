import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorResponse {
  final String? status;
  final int? statusCode;
  final String? message;

  ErrorResponse({
    this.status,
    this.statusCode,
    this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        status: json["status"],
        statusCode: json["statusCode"],
        message: json["message"],
      );
}



class ErrorResponseNew {
  final String message;

  ErrorResponseNew({required this.message});

  factory ErrorResponseNew.fromJson(Map<String, dynamic> json) {
    return ErrorResponseNew(message: json['message'] ?? 'Something went wrong');
  }
}



void snackBar(String message, {bool isError = true}) {
  Get.snackbar(
    isError ? "Error" : "Success",
    message,
    backgroundColor: isError ? Colors.red : Colors.green,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
  );
}
