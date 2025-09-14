import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/custom_order_response_model.dart';

mixin OrderDetailsMixin {
  final Rxn<Order> order = Rxn<Order>();
  final reasonController = TextEditingController();
  bool isNotExpired = true;
  final Rx<Duration> remainingTime = const Duration().obs;
  final Rxn<Duration> pendingExtension = Rxn<Duration>();
  Timer? timer;

  void setInitialRemainingTime() {
    final deliveryDate = order.value?.deliveryDate;
    if (deliveryDate != null) {
      final diff = deliveryDate.difference(DateTime.now());
      remainingTime.value = diff.isNegative ? Duration.zero : diff;
      isNotExpired = !diff.isNegative;
    }
  }

  void startCountdown() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.value.inSeconds <= 0) {
        timer?.cancel();
      } else {
        remainingTime.value -= const Duration(seconds: 1);
      }
    });
  }

// Send extension request to server
  Future<void> sendExtensionRequest(
      BuildContext context, DateTime pickedDate) async {
    final currentDelivery = order.value?.deliveryDate;
    if (currentDelivery == null) {
      snack(context, "No delivery date found.");
      return;
    }

    final orderId = order.value?.id;
    if (orderId == null) {
      snack(context, "Order ID missing.");
      return;
    }

    final body = {
      "lastDate": currentDelivery.toUtc().toIso8601String(),
      "newDate": pickedDate.toIso8601String(),
      "reason": reasonController.text.isEmpty ? null : reasonController.text,
    };

    snack(context, "Sending extension request...");
    final res = await ApiClient.patchData(
      ApiUrl.orderDateExtension(orderId: orderId),
      jsonEncode(body),
    );

    if (res.statusCode == 200) {
      // Keep pendingExtension locally as duration until server returns updated order
      pendingExtension.value =
          pickedDate.difference(currentDelivery); // store added duration

      // Immediately refresh the order from server so UI shows latest extentionHistory/status
      await refreshOrder(orderId);

      snack(context, "Extension request sent successfully.");
    } else {
      snack(context, extractError(res.body));
    }
  }

  // Refresh order details from server
  Future<void> refreshOrder(String orderId) async {
    debugPrint("Refreshing order $orderId from server...");
    try {
      final path = ApiUrl.getOrderDetails(orderId: orderId);
      final res = await ApiClient.getData(path);

      if (res.statusCode == 200) {
        dynamic body = res.body;

        // If body is a String, try to decode JSON; otherwise assume it's already decoded.
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            debugPrint("Failed to jsonDecode body: $e");
            // fallback: treat original string as error case
            return;
          }
        }

        // Normalize payload: support several shapes:
        // 1) { data: { ... } }
        // 2) { data: { order: { ... } } }
        // 3) { order: { ... } }
        // 4) { ... } (already the order payload)
        dynamic payload = body;
        if (body is Map) {
          if (body['data'] != null) {
            payload = body['data'];
            if (payload is Map && payload['order'] != null) payload = payload['order'];
          } else if (body['order'] != null) {
            payload = body['order'];
          }
        }

        // After normalization, ensure payload is a Map suitable for Order.fromJson
        if (payload is! Map) {
          debugPrint("Unexpected payload type: ${payload.runtimeType}");
          return;
        }

        final updatedOrder = Order.fromJson(payload as Map<String, dynamic>);
        order.value = updatedOrder;

        // Ensure GetX reactivity notices the update
        order.refresh();

        // recompute remaining time & expiration flag
        setInitialRemainingTime();

        // reset/start countdown to reflect new time
        startCountdown();

        // compute pendingExtension based on latest extentionHistory entry if pending
        if (updatedOrder.extentionHistory.isNotEmpty) {
          final ext = updatedOrder.extentionHistory.last;
          final status = (ext.status ?? '').toLowerCase();
          if (status == 'pending') {
            try {
              pendingExtension.value = ext.newDate.difference(ext.lastDate);
            } catch (_) {
              pendingExtension.value = null;
            }
          } else {
            pendingExtension.value = null;
          }
        } else {
          pendingExtension.value = null;
        }
      } else {
        debugPrint("Failed to refresh order: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Error refreshing order: $e");
    }
  }

  void snack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }

  String extractError(dynamic body) {
    try {
      if (body is Map && body["error"] != null) return body["error"];
      if (body is Map && body["message"] != null) return body["message"];
      if (body is String) {
        final decoded = jsonDecode(body);
        return decoded["error"] ?? decoded["message"] ?? "Request failed.";
      }
    } catch (_) {}
    return "Request failed.";
  }
}
