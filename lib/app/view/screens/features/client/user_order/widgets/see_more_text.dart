import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class SeeMoreText extends StatelessWidget {
  final String reason;
  final controller;
  SeeMoreText({super.key, required this.reason, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expanded = controller.expanded.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: controller.toggle,
            child: RichText(
              maxLines: expanded ? null : 1,
              overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Reason: ",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: reason,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4.h),
          reason.split('\n').length > 1 || reason.length > 40
              ? GestureDetector(
                  onTap: controller.toggle,
                  child: Text(
                    expanded ? 'Show less' : 'Show more',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: expanded ? Colors.red : AppColors.brightCyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      );
    });
  }
}
