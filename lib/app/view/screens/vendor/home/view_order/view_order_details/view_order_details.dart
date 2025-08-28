import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/vendor/orders/models/custom_order_response_model.dart';
import 'view_order_details_controller.dart';

class ViewOrderDetails extends StatelessWidget {
  final Order order;

  ViewOrderDetails({super.key, required this.order}) {
    // Unique controller per order (tag uses order id)
    controller = Get.put(
      ViewOrderDetailsController(order),
      tag: 'order_${order.id}',
    );
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
                elevation: 0,
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderField(label: "Order ID", value: order.id.toString()),
                      OrderField(label: "Client", value: (order.client).toString()),
                      OrderField(label: "Status", value: order.status),
                      OrderField(label: "Price", value: '\$'+(order.price).toStringAsFixed(0)),
                      OrderField(label: "Created", value: order.createdAt.toIso8601String().getDateTime()),
                      OrderField(label: "Delivery Date", value: order.deliveryDate!.formatDate()), 
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Countdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CountdownBox(number: controller.twoDigits(remaining.inDays), label: 'Days'),
                  CountdownBox(number: controller.twoDigits(remaining.inHours % 24), label: 'Hours'),
                  CountdownBox(number: controller.twoDigits(remaining.inMinutes % 60), label: 'Min'),
                  CountdownBox(number: controller.twoDigits(remaining.inSeconds % 60), label: 'Sec'),
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
                          onPressed: () => controller.cancelExtensionRequest(context),
                          child: const Text("Cancel Request", style: TextStyle(color: Colors.red)),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
              ],

              CustomButton(
                isRadius: true,
                onTap: () => controller.pickAndRequestExtension(context),
                title: "Extend Delivery Date",
              ),
            ],
          ),
        );
      }),
    );
  }
}

class CountdownBox extends StatelessWidget {
  final String number;
  final String label;

  const CountdownBox({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}

class OrderField extends StatelessWidget {
  final String label;
  final String value;
  const OrderField({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
          ),
            const Text(": ", style: TextStyle(color: Colors.black54)),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
