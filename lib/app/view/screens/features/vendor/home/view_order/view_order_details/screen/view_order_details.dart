import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/custom_order_response_model.dart'
    hide ExtensionHistory;
import '../controller/view_order_details_controller.dart';

// new widgets
import '../widgets/order_info_card.dart';
import '../widgets/expiration_alert.dart';
import '../widgets/countdown_row.dart';
import '../widgets/extension_history.dart';

class ViewOrderDetails extends StatelessWidget {
  Widget _statusMessageCard(String status) {
    String message;
    Color color;
    IconData icon;
    Color iconColor;
    switch (status) {
      case 'completed':
        message = 'This order has been completed.';
        color = Colors.green.shade50;
        icon = Icons.check_circle_rounded;
        iconColor = Colors.green;
        break;
      case 'cancelled':
        message = 'This order has been cancelled.';
        color = Colors.red.shade50;
        icon = Icons.cancel_rounded;
        iconColor = Colors.red;
        break;
      case 'delivered':
      case 'delivery-confirmed':
        message = 'This order has been delivered.';
        color = Colors.blue.shade50;
        icon = Icons.local_shipping_rounded;
        iconColor = Colors.blue;
        break;
      default:
        message = '';
        color = Colors.grey.shade100;
        icon = Icons.info_outline_rounded;
        iconColor = Colors.grey;
    }
    if (message.isEmpty) return SizedBox.shrink();
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28.sp),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

              if (![
                'completed',
                'cancelled',
                'delivered',
              ].contains(o.status)) ...[
                SizedBox(height: 20.h),
                ExpirationAlert(isNotExpired: controller.isNotExpired),
                SizedBox(height: 20.h),
              ],
              _statusMessageCard(o.status),
              if (![
                'completed',
                'cancelled',
                'delivered',
                'delivery-confirmed',
              ].contains(o.status)) ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: CountdownRow(
                            remaining: remaining, controller: controller),
                      ),
                      SizedBox(height: 25.h),
                    ],
                  ),
                ),
              ],

              //product image
              Text("Product Images",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              if (o.designFiles.isNotEmpty)
                SizedBox(
                  height: 100.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: o.designFiles.length,
                    separatorBuilder: (context, index) => SizedBox(width: 10.w),
                    itemBuilder: (context, index) {
                      return CustomNetworkImage(
                        imageUrl: o.designFiles[index],
                        height: 100.h,
                        width: 100.w,
                      );
                    },
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  child: Row(
                    children: [
                      Icon(Icons.image_not_supported_outlined,
                          color: Colors.grey, size: 28.sp),
                      SizedBox(width: 10.w),
                      Text(
                        "No product images available",
                        style: TextStyle(
                            fontSize: 14.5.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              if (![
                'completed',
                'cancelled',
                'delivered',
                'in-progress',
                'delivery-confirmed'
              ].contains(o.status)) ...[
                SizedBox(height: 30.h),
                CustomButton(
                  isRadius: true,
                  onTap: () => controller.requestExtension(context),
                  title: "Extend Delivery Date",
                ),
              ],
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
