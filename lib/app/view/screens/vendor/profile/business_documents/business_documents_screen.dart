import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class BusinessDocumentsScreen extends StatelessWidget {
  const BusinessDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Business Documents ",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "1. Upload Business License & Tax Info",
              font: CustomFont.poppins,
              fontWeight: FontWeight.w400,
              fontSize: 18.sp,
              color: AppColors.darkNaturalGray,
            ),
            SizedBox(height: 21.h,),
            CustomText(
              text: "2. Bank Account Details for Payouts",
              font: CustomFont.poppins,
              fontWeight: FontWeight.w400,
              fontSize: 18.sp,
              color: AppColors.darkNaturalGray,
            ),

            SizedBox(height: 21.h,),
            CustomText(
              text: "3. Withdrawal History & Earnings Report",
              font: CustomFont.poppins,
              fontWeight: FontWeight.w400,
              fontSize: 18.sp,
              color: AppColors.darkNaturalGray,
            ),
          ],
        ),
      ),
    );
  }
}
