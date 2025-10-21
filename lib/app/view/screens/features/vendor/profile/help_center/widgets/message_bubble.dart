import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/features/vendor/profile/help_center/model/support_model.dart';
import 'avatar.dart';

class MessageBubble extends StatelessWidget {
  final SupportMessage message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isVendor = message.sender == 'vendor';
    final isClient = message.sender == 'client';
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: isVendor ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isVendor) Avatar(isVendorOrClient: isVendor || isClient),
          if (!isVendor) SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: isVendor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    gradient: isVendor
                        ? LinearGradient(colors: [AppColors.brightCyan, AppColors.brightCyan.withValues(alpha: 0.8)])
                        : isClient
                            ? LinearGradient(colors: [Colors.orange, Colors.deepOrange])
                            : LinearGradient(colors: [Colors.grey[200]!, Colors.grey[100]!]),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: isVendor ? Radius.circular(16.r) : Radius.circular(4.r),
                      bottomRight: isVendor ? Radius.circular(4.r) : Radius.circular(16.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isVendor
                                ? AppColors.brightCyan
                                : isClient
                                    ? Colors.orange
                                    : Colors.grey)
                            .withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CustomText(
                    text: message.message ?? '',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isVendor ? AppColors.white : AppColors.black,
                    maxLines: 100,
                  ),
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: CustomText(
                    text: message.sentAt?.getDateTime() ?? '',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkNaturalGray.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          if (isVendor) SizedBox(width: 8.w),
          if (isVendor) Avatar(isVendorOrClient: isVendor),
        ],
      ),
    );
  }
}
