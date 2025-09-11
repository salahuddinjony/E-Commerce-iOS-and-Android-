import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/features/client/user_order/controller/user_order_controller.dart';
import 'package:local/app/view/screens/features/client/user_order/widgets/status_action_button.dart';
import 'package:local/app/view/screens/features/client/user_order/widgets/status_card.dart';

class ExtendRequestCard extends StatelessWidget {
  final String imagePath;
  final String orderId;
  final String lastDate;
  final String proposeDate;
  final String status;
  final int requestedDays;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final UserOrderController controller;

  const ExtendRequestCard({
    Key? key,
    required this.imagePath,
    required this.orderId,
    required this.lastDate,
    required this.proposeDate,
    required this.requestedDays,
    required this.status,
    this.onAccept,
    this.onCancel,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyleTitle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14.sp,
      color: Colors.black,
    );

    final textStyleSubtitle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
      color: Colors.grey[600],
    );

    final textStyleDescription = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
      color: Colors.grey[700],
      height: 1.3,
    );

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl: imagePath,
            height: 127,
            width: 119,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(orderId, style: textStyleTitle),
                    SizedBox(width: 6.w),
                    Text("Last Date: " + lastDate, style: textStyleSubtitle),
                  ],
                ),
                SizedBox(height: 6.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.orange.shade200, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          color: Colors.orange.shade700, size: 18.sp),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          "Proposed Date: $proposeDate  (+$requestedDays days)",
                          style: textStyleDescription.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                status.toLowerCase() == 'pending'
                    ? Row(
                        children: [
                          Expanded(
                              child: StatusActionButton(
                            label: 'Accept',
                            onClick: onAccept,
                            controller: controller,
                          )),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: StatusActionButton(
                              label: 'Cancel',
                              onClick: onCancel,
                              controller: controller,
                            ),
                          ),
                        ],
                      )
                    : StatusCard(
                        isApproved: status.toLowerCase() == 'approved',
                        requestedDays: requestedDays,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
