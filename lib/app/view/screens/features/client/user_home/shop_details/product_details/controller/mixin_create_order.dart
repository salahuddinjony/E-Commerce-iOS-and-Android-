import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/services/api_check.dart';
import 'package:local/app/utils/app_constants/app_constants.dart'; // added

mixin MixinCreateOrder {
  final items = 1.obs;
  final size = ''.obs;
  final color = ''.obs;

  Future<bool> createOrder(
      {required vendorId,
      required int price,
      required String ProductId,
      required int quantity,
      required String shippingAddress,
      required String sessionId}) async {
    final clientId = await SharePrefsHelper.getString(AppConstants.userId);

    try {
      final orderData = {
        "vendor": vendorId,
        "client": clientId,
        "price": price,
        "products": [
          {"productId": ProductId, "quantity": quantity}
        ],
        "paymentStatus": "paid",
        "shippingAddress": shippingAddress,
        "sessionId": sessionId
      };

      debugPrint('createOrder payload: ${jsonEncode(orderData)}');

      // JSON-encode the body before sending
      final response = await ApiClient.postData(
        ApiUrl.createGeneralOrder,
        jsonEncode(orderData),
      );

      debugPrint(
          "createOrder response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('Order created successfully');
        return true;
      } else {
        // let ApiChecker surface errors (401/403/others)
        ApiChecker.checkApi(response);
        debugPrint('Failed to create order: ${response.statusCode}');
        return false;
      }
    } catch (e, st) {
      debugPrint('Error creating order: $e\n$st');
      rethrow;
    } finally {
      // cleanup if needed
    }
  }
}
