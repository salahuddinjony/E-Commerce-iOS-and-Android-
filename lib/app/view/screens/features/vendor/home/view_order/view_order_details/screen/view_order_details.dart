import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/custom_order_response_model.dart'
    hide ExtensionHistory;
import '../controller/view_order_details_controller.dart';

// new widgets
import '../widgets/order_info_card.dart';
import '../widgets/expiration_alert.dart';
import '../widgets/countdown_row.dart';
import '../widgets/extension_history.dart';

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
        final o = controller.order.value ?? order;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderInfoCard(order: o),
              SizedBox(height: 20.h),
              ExpirationAlert(isNotExpired: controller.isNotExpired),
              SizedBox(height: 20.h),
              CountdownRow(remaining: remaining, controller: controller),
              SizedBox(height: 25.h),
              CustomButton(
                isRadius: true,
                onTap: () => controller.requestExtension(context),
                title: "Extend Delivery Date",
              ),
              SizedBox(height: 20.h),
              if (o.extentionHistory.isNotEmpty)
                ExtensionHistory(order: o, controller: controller),
            ],
          ),
        );
      }),
    );
  }
}
