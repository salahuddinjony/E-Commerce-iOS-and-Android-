import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class ViewMapButton extends StatelessWidget {
  const ViewMapButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, bottom: 0.h),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            RoutePath.mapPickerScreen,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.brightCyan.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.brightCyan,
              width: 1.2,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.map_outlined,
                color: AppColors.brightCyan,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                decoration: TextDecoration.none,
                textAlign: TextAlign.start,
                text: "View Map",
                fontWeight: FontWeight.w500,
                font: CustomFont.poppins,
                fontSize: 16.sp,
                color: AppColors.brightCyan,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
