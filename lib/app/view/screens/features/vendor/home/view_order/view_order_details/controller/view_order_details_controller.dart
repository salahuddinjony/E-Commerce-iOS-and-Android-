import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/vendor/home/view_order/view_order_details/controller/mixin_order_details.dart';
import 'package:local/app/view/screens/features/vendor/home/view_order/view_order_details/widgets/extension_request_dialog.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/custom_order_response_model.dart';

class ViewOrderDetailsController extends GetxController with OrderDetailsMixin {
  ViewOrderDetailsController(this.initialOrder);

  final Order initialOrder;

  @override
  Future<void> onInit() async {
    super.onInit();
    order.value = initialOrder;
    setInitialRemainingTime();
    startCountdown();

    // Fetch latest server copy so UI shows current extension status immediately.
    try {
      await refreshOrder(initialOrder.id);
    } catch (_) {
      debugPrint("Failed to refresh order ${initialOrder.id}");
    }
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
            headerForegroundColor: Colors.white,
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

  // /// Called from UI → Opens date picker + dialog
  Future<void> requestExtension(BuildContext context) async {
    if (pendingExtension.value != null) {
      snack(context, "An extension request is already pending.");
      return;
    }

    final currentDate = order.value?.deliveryDate ?? DateTime.now();
    final pickedDate = await _pickDate(context, currentDate);
    if (pickedDate == null) return;

    if (!pickedDate.isAfter(currentDate)) {
      snack(context, "Select a date after ${currentDate.toLocal()}");
      return;
    }

    final confirmed = await showExtensionDialog(
      context,
      pickedDate: pickedDate,
      currentDate: currentDate,
      reasonController: reasonController,
    );

    if (confirmed ?? false) {
      await sendExtensionRequest(context, pickedDate);
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    reasonController.dispose();
    super.onClose();
  }
}
