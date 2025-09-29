import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget twoButtons({
  required String leftTitle,
  String? rightTitle,
  Color leftColor = Colors.green,
  Color rightColor = Colors.red,
  Icon leftIcon = const Icon(Icons.check_circle_outline, color: Colors.white),
  Icon rightIcon = const Icon(Icons.cancel_outlined, color: Colors.white),
  bool leftButton = true,
  bool rightButton = true,
  double height=40,
  required VoidCallback leftOnTap,
  VoidCallback? rightOnTap,
  bool isLeftLoading = false,
  bool isRightLoading = false,
}) {
  return Row(
    children: [
      if (leftButton)
        Expanded(
          flex: 4,
          child: Container(
            height:height.h,
            decoration: BoxDecoration(
              color: leftColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLeftLoading ? null : leftOnTap,
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLeftLoading)
                        SizedBox(
                          width: 14.w,
                          height: 14.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else
                        Icon(
                          leftIcon.icon,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      SizedBox(width: 6.w),
                      Text(
                        leftTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      if (rightButton) ...[
        SizedBox(width: 20.w),
        Expanded(
          flex: 4,
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: rightColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isRightLoading ? null : rightOnTap,
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isRightLoading)
                        SizedBox(
                          width: 14.w,
                          height: 14.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else
                        Icon(
                           rightIcon.icon,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      SizedBox(width: 6.w),
                      Text(
                        rightTitle ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]
    ],
  );
}
