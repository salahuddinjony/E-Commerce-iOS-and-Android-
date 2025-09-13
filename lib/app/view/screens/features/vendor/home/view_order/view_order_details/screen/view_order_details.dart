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

              controller.isNotExpired
                  ? SizedBox.shrink()
                  : Center(
                      child: Card(
                        elevation: 1,
                        color: Colors.red[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.red,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "The delivery date has passed!",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
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

              // if (controller.pendingExtension.value != null) ...[
              //   Card(
              //     color: Colors.yellow[100],
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       side: const BorderSide(color: Colors.orange, width: 1.5),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(16),
              //       child: Row(
              //         children: [
              //           Expanded(
              //             child: Text(
              //               "Extension request:\n${controller.formatDuration(controller.pendingExtension.value!)}\nPending review.",
              //               style: const TextStyle(fontSize: 14),
              //             ),
              //           ),
              //           // TextButton(
              //           //   onPressed: () =>
              //           //       controller.cancelExtensionRequest(context),
              //           //   child: const Text("Cancel Request",
              //           //       style: TextStyle(color: Colors.red)),
              //           // )
              //         ],
              //       ),
              //     ),
              //   ),
              //   SizedBox(height: 25.h),
              // ],

              CustomButton(
                isRadius: true,
                onTap: () => controller.requestExtension(context),
                title: "Extend Delivery Date",
              ),

              SizedBox(height: 20.h),

              // Show extension history AFTER the Extend Delivery Date button
              if (order.extentionHistory.isNotEmpty) ...[
                (() {
                  final ext = order.extentionHistory.last;
                  final status = (ext.status ?? '').toLowerCase();
                  Color bg;
                  Color border;
                  IconData icon;
                  if (status == 'pending') {
                    bg = Colors.orange[50]!;
                    border = Colors.orange;
                    icon = Icons.hourglass_top;
                  } else if (status == 'approved' ||
                      status == 'accepted' ||
                      status == 'approved_by_admin') {
                    bg = Colors.green[50]!;
                    border = Colors.green;
                    icon = Icons.check_circle;
                  } else if (status == 'rejected' || status == 'declined') {
                    bg = Colors.red[50]!;
                    border = Colors.red;
                    icon = Icons.cancel;
                  } else {
                    bg = Colors.grey[50]!;
                    border = AppColors.brightCyan;
                    icon = Icons.history;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Prominent banner when the last extension is pending
                      if (status == 'pending' || controller.pendingExtension.value != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Card(
                            color: Colors.orange[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                  color: Colors.orange.shade400, width: 1.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 14),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(Icons.send,
                                        color: Colors.orange.shade800),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Extension sent",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          "You have sent an extension request. It is currently pending review.",
                                          style: TextStyle(fontSize: 13.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // History title (single latest entry)
                      Text(
                        "Extension History",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10.h),

                      // Show ONLY the last extension entry
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Card(
                          elevation: 1,
                          color: bg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: border, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(icon, color: border),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Previous: ${ext.lastDate.formatDate()}",
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        "New: ${ext.newDate.formatDate()}",
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        "+${controller.formatDuration(ext.newDate.difference(ext.lastDate))}",
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      if ((ext.reason ?? '').isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "Reason: ${ext.reason}",
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.black87),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                // Status chip
                                Column(
                                  children: [
                                    Chip(
                                      label: Text(
                                        ext.status?.toUpperCase() ?? '',
                                        style: TextStyle(
                                            fontSize: 11.sp, color: border),
                                      ),
                                      backgroundColor: border.withOpacity(0.12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  );
                })(),
              ],
            ],
          ),
        );
      }),
    );
  }
}

