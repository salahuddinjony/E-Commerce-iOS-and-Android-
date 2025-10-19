import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/features/vendor/profile/help_center/model/support_model.dart';

class ChatHeader extends StatelessWidget {
  final SupportThread thread;
  const ChatHeader({super.key, required this.thread});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.brightCyan.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.brightCyan,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.support_agent,
              color: AppColors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: thread.latestSubject ?? 'Support Chat',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: thread.isDismissed == false ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    CustomText(
                      text: thread.isDismissed == false ? 'Active' : 'Closed',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkNaturalGray,
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.access_time, size: 12.sp, color: AppColors.darkNaturalGray),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: thread.updatedAt?.getDateTime() ?? '',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkNaturalGray,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
