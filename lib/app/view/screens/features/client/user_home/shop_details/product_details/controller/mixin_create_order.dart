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

  // Custome Oerder info
  final TextEditingController priceController =
      TextEditingController(text: "10");

  final TextEditingController quantityController =
      TextEditingController(text: "1");
  final TextEditingController deliveryOptionController =
      TextEditingController(text: "courier");
  final TextEditingController deliveryDate =
      TextEditingController(text: "2024-12-31");
  final TextEditingController summeryController =
      TextEditingController(text: "I would like a custom design with my logo.");

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

  Future<bool> customOrder({
    required vendorId,
    required String shippingAddress,
    required dynamic localImage,
  }) async {
    final clientId = await SharePrefsHelper.getString(AppConstants.userId);

    try {
      final orderData = {
        "vendor": vendorId,
        "client": clientId,
        "deliveryDate": deliveryDate.text.trim(),
        "price": int.parse(priceController.text.trim()),
        "currency": "USD",
        "quantity": quantityController.text.trim(),
        "isCustom": true,
        "deliveryOption": deliveryOptionController.text.trim(),
        "summery": summeryController.text.trim(),
        "shippingAddress": shippingAddress,
      };

      debugPrint('createOrder payload: ${jsonEncode(orderData)}');

      // Normalize localImage: accept File, String (path), XFile, or List of those
      final List<File> files = [];
      if (localImage == null) {
        // no files
      } else if (localImage is List) {
        for (final item in localImage) {
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
        if (localImage is File) {
          files.add(localImage);
        } else if (localImage is XFile) {
          files.add(File(localImage.path));
        } else if (localImage is String) {
          files.add(File(localImage));
        } else {
          try {
            files.add(File(localImage.toString()));
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
