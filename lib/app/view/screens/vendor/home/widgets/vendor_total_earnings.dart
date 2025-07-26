import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../common_widgets/custom_button/custom_button.dart';
import '../../../../common_widgets/custom_text/custom_text.dart';

class VendorTotalEarnings extends StatelessWidget {
  const VendorTotalEarnings({
    super.key, required this.amount, required this.onTap,
  });

  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 87.w, vertical: 30.h),
      decoration: BoxDecoration(
          color: AppColors.brightCyan,
          borderRadius:
          BorderRadius.all(Radius.circular(21.r))),
      child: Column(
        children: [
          CustomText(
            font: CustomFont.poppins,
            color: AppColors.white,
            text: 'Total Earnings',
            fontWeight: FontWeight.w600,
            fontSize: 24.sp,
          ),
          CustomText(
            font: CustomFont.poppins,
            color: AppColors.white,
            text: amount,
            fontWeight: FontWeight.w600,
            fontSize: 30.sp,
            bottom: 10.h,
          ),
          CustomButton(
            borderColor: AppColors.white,
            onTap:onTap,
            title: "Withdraw",
          )
        ],
      ),
    );
  }
}