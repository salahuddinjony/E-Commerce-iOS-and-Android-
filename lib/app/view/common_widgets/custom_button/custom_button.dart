import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final Color fillColor;
  final Color borderColor;
  final Color textColor;
  final bool isRadius;
  final VoidCallback? onTap;
  final String? title;
  final Widget? child;
  final double marginVertical;
  final double marginHorizontal;
  const CustomButton({
    super.key,
    this.height = 48,
    this.width = double.maxFinite,
    required this.onTap,
    this.title,
    this.child,
    this.marginVertical = 0,
    this.marginHorizontal = 0,
    this.fillColor = AppColors.brightCyan,
    this.textColor = AppColors.white,
    this.borderColor = Colors.transparent,
    this.isRadius = false,
  }) : assert(title != null || child != null, 'Either title or child must be provided');



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: marginVertical,
          horizontal: marginHorizontal,
        ),
        alignment: Alignment.center,
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          color: fillColor,
          border: Border.all(color: borderColor),
          borderRadius: isRadius ? BorderRadius.circular(25.r) : BorderRadius.circular(10.r),
        ),
        child: child ??
            CustomText(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
              font: CustomFont.inter,
              textAlign: TextAlign.center,
              text: title!,
            ),
      ),
    );
  }
}
