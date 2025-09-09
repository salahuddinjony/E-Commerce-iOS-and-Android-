import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/category_wise_product/category_product_controller.dart';

Widget buildHeader(
    {required CategoryProductsController controller,
    required String categoryName,
    required String categoryImage,
    required RxList<dynamic> products}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16.r),
    child: Stack(
      children: [
        SizedBox(
          height: 110.h,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: categoryImage.replaceFirst(
              'http://10.10.20.19:5007',
              'https://gmosley-uteehub-backend.onrender.com',
            ),
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: Center(
                child: SizedBox(
                  width: 32.r,
                  height: 32.r,
                  child: const CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: Icon(Icons.broken_image, color: Colors.grey, size: 40.r),
            ),
          ),
        ),
        Container(
          height: 110.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: .55),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          left: 20.w,
          bottom: 12.h,
          right: 20.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  categoryName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 12.w),
              Obx(() {
                final count = controller
                    .filteredProducts.length;
                // final count = products.length; 

                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .85),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '$count item${count == 1 ? '' : 's'}',
                    style: TextStyle(
                      color: AppColors.brightCyan,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    ),
  );
}
