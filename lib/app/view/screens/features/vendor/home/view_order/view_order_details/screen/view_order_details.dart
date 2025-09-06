import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/features/vendor/home/view_order/view_order_details/widgets/count_down_box.dart';
import 'package:local/app/view/screens/features/vendor/home/view_order/view_order_details/widgets/order_filed.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/custom_order_response_model.dart';
import '../controller/view_order_details_controller.dart';

class ViewOrderDetails extends StatelessWidget {
  final Order order;

  ViewOrderDetails({super.key, required this.order}) {
    final tag = 'order_${order.id}';
    if (!Get.isRegistered<ViewOrderDetailsController>(tag: tag)) {
      controller = Get.put(ViewOrderDetailsController(order), tag: tag);
    } else {
      controller = Get.find<ViewOrderDetailsController>(tag: tag);
    }
  }

  late final ViewOrderDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        appBarContent: "Order Request",
        iconData: Icons.arrow_back,
      ),
      body: Obx(() {
        final remaining = controller.remainingTime.value;
        // final days = remaining.inDays;
        // final hours = remaining.inHours % 24;
        // final minutes = remaining.inMinutes % 60;
        // final seconds = remaining.inSeconds % 60;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order details card
              Card(
                elevation: 1,
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: AppColors.brightCyan,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderField(label: "Order ID", value: order.id.toString()),
                      OrderField(
                          label: "Client", value: (order.client).toString()),
                      OrderField(label: "Status", value: order.status),
                      OrderField(
                          label: "Price",
                          value: '\$' + (order.price).toStringAsFixed(0)),
                      OrderField(
                          label: "Created",
                          value:
                              order.createdAt.toIso8601String().getDateTime()),
                      OrderField(
                          label: "Delivery Date",
                          value: order.deliveryDate!.formatDate()),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Countdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CountdownBox(
                      number: controller.twoDigits(remaining.inDays),
                      label: 'Days'),
                  CountdownBox(
                      number: controller.twoDigits(remaining.inHours % 24),
                      label: 'Hours'),
                  CountdownBox(
                      number: controller.twoDigits(remaining.inMinutes % 60),
                      label: 'Min'),
                  CountdownBox(
                      number: controller.twoDigits(remaining.inSeconds % 60),
                      label: 'Sec'),
                ],
              ),
              SizedBox(height: 25.h),

              if (controller.pendingExtension.value != null) ...[
                Card(
                  color: Colors.yellow[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.orange, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Extension request:\n${controller.formatDuration(controller.pendingExtension.value!)}\nPending review.",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              controller.cancelExtensionRequest(context),
                          child: const Text("Cancel Request",
                              style: TextStyle(color: Colors.red)),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
              ],

              CustomButton(
                isRadius: true,
                onTap: () => controller.requestExtension(context),
                title: "Extend Delivery Date",
              ),
            ],
          ),
        );
      }),
    );
  }
}
