import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class EmptyConversations extends StatelessWidget {
  final controller; 
  const EmptyConversations({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 80.h),
        Icon(
          Icons.chat_bubble_outline,
          size: 72.sp,
          color: AppColors.darkNaturalGray.withValues(alpha: 0.5),
        ),
        SizedBox(height: 24.h),
        Center(
          child: CustomText(
            text: 'No conversations yet',
            font: CustomFont.inter,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.darkNaturalGray,
          ),
        ),
        SizedBox(height: 8.h),
        Center(
          child: CustomText(
            text: 'Start a new conversation to see messages here.',
            font: CustomFont.inter,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.darkNaturalGray.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 24.h),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              await controller.loadConversations();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brightCyan,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Text('Refresh',
                  style: TextStyle(fontSize: 16.sp, color: AppColors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
