import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class InboxLoader extends StatelessWidget {
  const InboxLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 8.h),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.darkNaturalGray.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: AppColors.darkNaturalGray.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: AppColors.darkNaturalGray.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
