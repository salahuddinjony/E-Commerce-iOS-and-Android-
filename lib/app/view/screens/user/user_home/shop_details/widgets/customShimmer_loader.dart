import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerLoader extends StatelessWidget {
  final bool isCircleLoader;
  const CustomShimmerLoader({super.key, this.isCircleLoader = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isCircleLoader ? 58.h : 120.h, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal, 
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: isCircleLoader
                ? Container(
                    margin: EdgeInsets.only(right: 20.w),
                    width: 58.w,
                    height: 58.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(right: 20.w, bottom: 10.h),
                    width: 100.w, 
                    height: 120.h,
                    color: Colors.white,
                  ),
          );
        },
      ),
    );
  }
}
