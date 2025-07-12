import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_strings/app_strings.dart';
import '../../../../common_widgets/custom_text/custom_text.dart';

class ResetHeader extends StatelessWidget {
  const ResetHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 26.h,
        ),
        CustomText(
          textAlign: TextAlign.start,
          text: AppStrings.setANewPassword,
          font: CustomFont.poppins,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.darkNaturalGray,
        ),
        CustomText(
          top: 5,
          maxLines: 2,
          textAlign: TextAlign.start,
          text: AppStrings.createANewPassword,
          font: CustomFont.inter,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.naturalGray,
        ),
        SizedBox(
          height: 100.h,
        ),
      ],
    );
  }
}