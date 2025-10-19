import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const EmptyState({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.brightCyan.withOpacity(0.1),
                        AppColors.brightCyan.withOpacity(0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.support_agent,
                    size: 80.sp,
                    color: AppColors.brightCyan,
                  ),
                ),
                SizedBox(height: 24.h),
                CustomText(
                  text: 'No Support History',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: 'Create a support ticket to get started',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkNaturalGray,
                ),
              ],
            ),
          ),
        ),
        // You can pass your custom create support button here
        // Example: CreateSupportButton(onPressed: onCreate),
      ],
    );
  }
}
