import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class MessageCard extends StatelessWidget {
  final String imageUrl;
  final String senderName;
  final String message;
  final VoidCallback onTap;

  const MessageCard({
    super.key,
    required this.imageUrl,
    required this.senderName,
    required this.message, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              spreadRadius: 2, // Spread the shadow
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 2), // Shadow offset
            ),
          ],
        ),
        child:
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              imageUrl: imageUrl,
              height: 40,
              boxShape: BoxShape.circle,
              width: 40,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: senderName,
                  font: CustomFont.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkNaturalGray,
                  bottom: 6.h,
                ),
                CustomText(
                  text: message,
                  font: CustomFont.inter,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.naturalGray,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}