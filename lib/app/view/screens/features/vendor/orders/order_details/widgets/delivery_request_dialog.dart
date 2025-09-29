import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';
import 'package:local/app/view/screens/features/vendor/orders/order_details/widgets/two_buttons_in_row.dart';
import 'package:local/app/view/screens/features/vendor/orders/order_details/widgets/delivery_dialog_header.dart';
import 'package:local/app/view/screens/features/vendor/orders/order_details/widgets/delivery_description_field.dart';
import 'package:local/app/view/screens/features/vendor/orders/order_details/widgets/file_attachment_section.dart';

class DeliveryRequestDialog extends StatelessWidget {
  final orderId;
  DeliveryRequestDialog({super.key, this.orderId});
  final OrdersController controller = Get.find<OrdersController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DeliveryDialogHeader(),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DeliveryDescriptionField(controller: controller),
                    const SizedBox(height: 20),
                    FileAttachmentSection(controller: controller),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Obx(() => twoButtons(
          leftTitle: 'Send Request',
          rightTitle: 'Cancel',
          isLeftLoading: controller.isAcceptLoading.value,
          isRightLoading: false,
          leftOnTap: () => handleSendRequest(context),
          rightOnTap: () => Navigator.of(context).pop(),
        ));
  }

  Future<void> handleSendRequest(BuildContext context) async {
    if (controller.descController.text.trim().isEmpty || controller.selectedImages.isEmpty) {
      toastMessage(message: 'Please enter a description and select images', gravity: ToastGravity.CENTER);
      return;
    }

    controller.isAcceptLoading.value = true;

    try {
      if (await controller.updateOrderToDeliveryRequested(
          orderId, 'delivery-requested')) {
        toastMessage(message: 'Delivery request sent successfully!');
        Navigator.of(context).pop();
        context.pop();
      } else {
        toastMessage(message: 'Failed to send delivery request');
      }
    } finally {
      controller.isAcceptLoading.value = false;
    }
  }
}
