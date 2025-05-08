import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

// Custom Google Auth Button Widget
class CustomAuthContainer extends StatelessWidget {
  final String buttonText;
  final Widget image;
  final void Function() onPressed;

  const CustomAuthContainer({
    super.key,
    required this.buttonText,
    required this.onPressed, required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,  // Handle the onPressed event
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.googleAuthButton, // Button color
          borderRadius: BorderRadius.all(Radius.circular(40.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            SizedBox(width: 8.w), // Space between the icon and text
            CustomText(
              text: buttonText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.darkNaturalGray,
            ),
          ],
        ),
      ),
    );
  }
}
