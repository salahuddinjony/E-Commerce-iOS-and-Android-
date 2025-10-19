import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class ErrorWidgetCustom extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorWidgetCustom({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onRetry,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60.sp,
              color: Colors.red,
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: message,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: 'Tap to retry',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.darkNaturalGray,
            ),
          ],
        ),
      ),
    );
  }
}
