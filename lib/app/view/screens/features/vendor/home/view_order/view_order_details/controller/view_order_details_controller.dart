import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/vendor/home/view_order/view_order_details/widgets/extension_request_dialog.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/custom_order_response_model.dart';

class ViewOrderDetailsController extends GetxController {
  ViewOrderDetailsController(this.initialOrder);

  final Order initialOrder;
  final Rx<Duration> remainingTime = const Duration().obs;
  final Rxn<Duration> pendingExtension = Rxn<Duration>();
  final Rxn<Order> order = Rxn<Order>();
  final reasonController = TextEditingController();
  bool isNotExpired = true;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    order.value = initialOrder;
    _setInitialRemainingTime();
    _startCountdown();
  }

  void _setInitialRemainingTime() {
    final deliveryDate = order.value?.deliveryDate;
    if (deliveryDate != null) {
      final diff = deliveryDate.difference(DateTime.now());
      remainingTime.value = diff.isNegative ? Duration.zero : diff;
      isNotExpired = !diff.isNegative;
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.value.inSeconds <= 0) {
        _timer?.cancel();
      } else {
        remainingTime.value -= const Duration(seconds: 1);
      }
    });
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  Future<DateTime?> _pickDate(BuildContext context, DateTime initialDate) {
    final firstDate = initialDate.add(const Duration(days: 1));
    final lastDate = initialDate.add(const Duration(days: 30));
    return showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: "Select New Delivery Date",
      builder: (context, child) => Theme(
        data: ThemeData(
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: AppColors.brightCyan,
            backgroundColor: Colors.white,
            headerForegroundColor:Colors.white,
           
          ),
        ),
        child: child ?? const SizedBox.shrink(),
      ),

      );
  
  }
  String formatDuration(Duration d) {
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    return "$days day(s), $hours hour(s), $minutes min, $seconds sec";
  }

  /// Called from UI → Opens date picker + dialog
  Future<void> requestExtension(BuildContext context) async {
    if (pendingExtension.value != null) {
      _snack(context, "An extension request is already pending.");
      return;
    }

    final currentDate = order.value?.deliveryDate ?? DateTime.now();
    final pickedDate = await _pickDate(context, currentDate);
    if (pickedDate == null) return;

    if (!pickedDate.isAfter(currentDate)) {
      _snack(context, "Select a date after ${currentDate.toLocal()}");
      return;
    }

    final confirmed = await showExtensionDialog(
      context,
      pickedDate: pickedDate,
      currentDate: currentDate,
      reasonController: reasonController,
    );

    if (confirmed ?? false) {
      await _sendExtensionRequest(context, pickedDate);
    }
  }

  // void cancelExtensionRequest(BuildContext context) {
  //   pendingExtension.value = null;
  //   _snack(context, "Extension request cancelled.");
  // }

  Future<void> _sendExtensionRequest(
      BuildContext context, DateTime pickedDate) async {
    final currentDelivery = order.value?.deliveryDate;
    if (currentDelivery == null) {
      _snack(context, "No delivery date found.");
      return;
    }

    final orderId = order.value?.id;
    if (orderId == null) {
      _snack(context, "Order ID missing.");
      return;
    }

    final body = {
      "lastDate": currentDelivery.toUtc().toIso8601String(),
      "newDate": pickedDate.toIso8601String(),
      "reason": reasonController.text.isEmpty ? null : reasonController.text,
    };

    _snack(context, "Sending extension request...");
    final res = await ApiClient.patchData(
      ApiUrl.orderDateExtension(orderId: orderId),
      jsonEncode(body),
    );

    if (res.statusCode == 200) {
      pendingExtension.value =
          pickedDate.difference(currentDelivery); // store added duration
      _snack(context, "Extension request sent successfully.");
    } else {
      _snack(context, _extractError(res.body));
    }
  }

  void _snack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _extractError(dynamic body) {
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

  @override
  void onClose() {
    _timer?.cancel();
    reasonController.dispose();
    super.onClose();
  }
}
