import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class Avatar extends StatelessWidget {
  final bool isVendorOrClient;
  const Avatar({super.key, required this.isVendorOrClient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isVendorOrClient
              ? [AppColors.brightCyan, AppColors.brightCyan.withValues(alpha:0.7)]
              : [Colors.orange, Colors.deepOrange],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: (isVendorOrClient ? AppColors.brightCyan : Colors.orange).withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isVendorOrClient ? Icons.person : Icons.support_agent,
        color: AppColors.white,
        size: 18.sp,
      ),
    );
  }
}
