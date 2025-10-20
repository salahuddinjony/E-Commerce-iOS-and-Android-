import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/services/api_check.dart';
import 'package:local/app/utils/app_constants/app_constants.dart'; // added

mixin MixinCreateOrder {
  final items = 1.obs;
  final size = ''.obs;
  final color = ''.obs;
  final RxString selectedDelivery = ''.obs;

  // Custome Oerder info
  final TextEditingController priceController =
      TextEditingController();

  final TextEditingController quantityController =
      TextEditingController();
  final TextEditingController deliveryDate =
      TextEditingController();
  final TextEditingController summeryController =
      TextEditingController();

  Future<bool> createOrder({
    required String vendorId,
    required int price,
    required String ProductId,
    required int quantity,
    required String shippingAddress,
    required String sessionId,
  }) async {
    final clientId = await SharePrefsHelper.getString(AppConstants.userId);

    if (clientId.isEmpty) {
      debugPrint('Error: Client ID not found');
      return false;
    }
    final int totalPrice = price * quantity;

    try {
      final orderData = {
        "vendor": vendorId,
        "client": clientId,
        "price": totalPrice,
        "products": [
          {"productId": ProductId, "quantity": quantity}
        ],
        "paymentStatus": "paid",
        "shippingAddress": shippingAddress,
        "sessionId": sessionId
      };

      debugPrint('=== Creating General Order ===');
      debugPrint('Endpoint: ${ApiUrl.createGeneralOrder}');
      debugPrint('Payload: ${jsonEncode(orderData)}');

      final response = await ApiClient.postData(
        ApiUrl.createGeneralOrder,
        jsonEncode(orderData),
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('✅ Order created successfully');
        return true;
      } else {
        debugPrint('❌ Failed to create order: ${response.statusCode}');
        debugPrint('Error details: ${response.body}');
        ApiChecker.checkApi(response);
        return false;
      }
    } catch (e, st) {
      debugPrint('❌ Error creating order: $e');
      debugPrint('Stack trace: $st');
      rethrow;
    }
  }

  Future<bool> customOrder({
    required clientId,
    required String shippingAddress,
    required dynamic designFiles,
  }) async {
    final vendorId = await SharePrefsHelper.getString(AppConstants.userId);

    try {
      final orderData = {
        "vendor": vendorId,
        "client": clientId,
        "deliveryDate": deliveryDate.text.trim(),
        "price": int.parse(priceController.text.trim()),
        "currency": "USD",
        "quantity": quantityController.text.trim(),
        "isCustom": true,
        "deliveryOption": selectedDelivery.value,
        "summery": summeryController.text.trim(),
        "shippingAddress": shippingAddress,
      };

      debugPrint('createOrder payload: ${jsonEncode(orderData)}');

      // Normalize localImage: accept File, String (path), XFile, or List of those
      final List<File> files = [];
      if (designFiles == null) {
        // no files
      } else if (designFiles is List) {
        for (final item in designFiles) {
          if (item == null) continue;
          if (item is File) {
            files.add(item);
          } else if (item is XFile) {
            files.add(File(item.path));
          } else if (item is String) {
            files.add(File(item));
          } else {
            try {
              files.add(File(item.toString()));
            } catch (e) {
              // ignore invalid item
            }
          }
        }
      } else {
        if (designFiles is File) {
          files.add(designFiles);
        } else if (designFiles is XFile) {
          files.add(File(designFiles.path));
        } else if (designFiles is String) {
          files.add(File(designFiles));
        } else {
          try {
            files.add(File(designFiles.toString()));
          } catch (e) {
            // ignore
          }
        }
      }

      // Build multipart body: attach each file as 'designFiles' (server expects this key)
      final multipart = <MultipartBody>[];
      for (final f in files) {
        try {
          multipart.add(MultipartBody('designFiles', f));
        } catch (e) {
          debugPrint('Skipping file for multipart due to error: $e');
        }
      }
      debugPrint('Attaching ${multipart.length} files to order request');

      // JSON-encode the body before sending
      final response = await ApiClient.postMultipartData(
        ApiUrl.createCustomOrder,
        orderData,
        multipartBody: multipart,
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
