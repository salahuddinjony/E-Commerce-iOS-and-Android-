import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class CreateSupportButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CreateSupportButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      color: AppColors.white,
      child: SafeArea(
        top: false,
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.brightCyan, AppColors.brightCyan.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 0),
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, color: AppColors.white, size: 17.sp),
                SizedBox(width: 8.w),
                Text(
                  'Create New Support',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
