import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../common_widgets/custom_text/custom_text.dart';

class OtpHeader extends StatelessWidget {
  const OtpHeader({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          top: 26.h,
          text: "Check Your email",
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.darkNaturalGray,
          font: CustomFont.poppins,
        ),
        CustomText(
          textAlign: TextAlign.start,
          maxLines: 3,
          text:
          "We sent a reset link to $email...com enter 4 digit code that mentioned in the email",
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.naturalGray,
          font: CustomFont.inter,
        ),
        SizedBox(
          height: 38.h,
        ),
      ],
    );
  }
}