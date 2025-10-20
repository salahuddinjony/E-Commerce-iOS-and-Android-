import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class StatussCard extends StatelessWidget {
  final String title;
  final String value;
  final Color tealColor;
  final IconData icon;
  final VoidCallback onTap;
  final bool loading;
  final String status;

  // Added optional fixed size controls
  final double cardWidth;
  final double cardHeight;

  const StatussCard({
    super.key,
    required this.title,
    required this.value,
    required this.tealColor,
    required this.icon,
    required this.onTap,
    this.cardWidth = 140, // smaller default for small screens
    this.cardHeight = 150, // smaller default for small screens
    required this.loading,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth.w,
        height: cardHeight.h,
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: tealColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22.sp),
            SizedBox(height: 6.h),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: 6.h),
            loading
              ? Shimmer.fromColors(
                  baseColor: Colors.white.withOpacity(0.3),
                  highlightColor: Colors.white,
                  child: Container(
                    width: 40.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                )
              : Text(
                  value.padLeft(2, '0'),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
            Spacer(),
            OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                minimumSize: Size(0, 28.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('view order', style: TextStyle(color: Colors.white, fontSize: 10.sp)),
                  SizedBox(width: 2.w),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 12.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
