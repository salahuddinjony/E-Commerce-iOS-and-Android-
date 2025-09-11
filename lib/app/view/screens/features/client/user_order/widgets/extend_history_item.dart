import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/client/user_order/controller/user_order_controller.dart';
import 'package:local/app/view/screens/features/client/user_order/widgets/see_more_text.dart';
import 'status_dot.dart';
import 'days_badge.dart';
import 'package:get/get.dart';

// class ExtendHistoryItemController extends GetxController {
//   final RxBool expanded = false.obs;
//   void toggle() => expanded.value = !expanded.value;
// }

class ExtendHistoryItem extends StatelessWidget {
  final dynamic item;
  final bool isLatest;

  ExtendHistoryItem({Key? key, required this.item, this.isLatest = false})
      : super(key: key);
      
  UserOrderController get controller {
    if (Get.isRegistered<UserOrderController>(tag: "extnd_${item.hashCode}")) {
      return Get.find<UserOrderController>(tag: "extnd_${item.hashCode}");
    } else {
      return Get.put(UserOrderController(), tag: "extnd_${item.hashCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastDateRaw = controller.field(item, 'lastDate');
    final newDateRaw = controller.field(item, 'newDate');
    final reasonRaw = controller.field(item, 'reason');
    final statusRaw = controller.field(item, 'status');

    final lastDate = controller.formatDate(lastDateRaw);
    final newDate = controller.formatDate(newDateRaw);
    final reason = reasonRaw?.toString() ?? '';
    final status = statusRaw?.toString() ?? '';
    final meta = controller.statusMeta(status);
    final color = meta['color'] as Color;
    final icon = meta['icon'] as IconData;

    return Row(
      crossAxisAlignment:
          isLatest ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // dot + connector spacing
        Container(
          width: 56.w,
          alignment: isLatest ? Alignment.topCenter : Alignment.center,
          child: Column(
            mainAxisAlignment:
                isLatest ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              StatusDot(color: color, icon: icon, isLatest: isLatest),
            ],
          ),
        ),

        // content card
        Expanded(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            shadowColor: Colors.black.withValues(alpha: .5),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header row with status chip and newDate
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        newDate.split(' ').first,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // from -> to row with subtle divider
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14.sp,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          'From: ${lastDate.split(' ').first}  ',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_right_alt,
                        size: 18.sp,
                        color: Colors.grey[600],
                      ),
                      Flexible(
                        child: Text(
                          'To: ${newDate.split(' ').first}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // reason text
                  if (reason.isNotEmpty)
                    SeeMoreText(controller: controller, reason: reason),
                  SizedBox(height: 10.h),

                  // footer row with extra meta (days extended)
                  Row(
                    children: [
                      if (lastDateRaw is DateTime && newDateRaw is DateTime)
                        DaysBadge(
                            days: newDateRaw.difference(lastDateRaw).inDays),
                      Spacer(),
                      if (isLatest)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.brightCyan.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'CURRENT',
                            style: TextStyle(
                              color: AppColors.brightCyan,
                              fontWeight: FontWeight.w700,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
