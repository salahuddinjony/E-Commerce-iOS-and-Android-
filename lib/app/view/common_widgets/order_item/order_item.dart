import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class OrderItem extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productMaterial;
  final String productPrice;
  final VoidCallback onTap;
  const OrderItem({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.productMaterial,
    required this.productPrice, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              imageUrl: imageUrl,
              height: 140.h,
              width: 187.w,
              boxShape: BoxShape.rectangle, // Assuming you want rectangular image
            ),
            CustomText(
              top: 5.h,
              text: productName,
              fontSize: 18.sp,
              color: AppColors.darkNaturalGray,
              fontWeight: FontWeight.w500,
              font: CustomFont.poppins,
            ),
            CustomText(
              top: 5.h,
              text: productMaterial,
              fontSize: 14.sp,
              color: AppColors.naturalGray,
              fontWeight: FontWeight.w400,
              font: CustomFont.poppins,
            ),
            CustomText(
              top: 5.h,
              text: productPrice,
              fontSize: 16.sp,
              color: AppColors.naturalGray,
              fontWeight: FontWeight.w500,
              font: CustomFont.poppins,
            ),
          ],
        ),
      ),
    );
  }
}