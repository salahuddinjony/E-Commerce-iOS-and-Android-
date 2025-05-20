import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/route_path.dart';
import '../../../common_widgets/custom_rich_text/custom_rich_text.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
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
              maxLines: 3,
              text:
                  "We sent a reset link to contact@dscode...com enter 5 digit code that mentioned in the email",
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.naturalGray,
              font: CustomFont.inter,
            ),
            SizedBox(
              height: 38.h,
            ),

            ///: <<<<<<====== OTP Pin Code Field ======>>>>>>>>
            PinCodeTextField(
              textStyle: TextStyle(color: AppColors.black, fontSize: 24.sp),
              keyboardType: TextInputType.number,
              autoDisposeControllers: false,
              cursorColor: AppColors.black,
              appContext: context,
              controller: TextEditingController(),
              onCompleted: (value) {},
              validator: (value) {
                if (value == null || value.length != 4) {
                  return "Please enter a 4-digit OTP code";
                }
                return null;
              },
              autoFocus: true,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                fieldHeight: 49.h,
                fieldWidth: 40.w,
                borderWidth: 1.5,
                borderRadius: BorderRadius.circular(12.r),
                // <-- Added border radius
                activeColor: AppColors.brightCyan,
                inactiveColor: AppColors.brightCyan,
                selectedColor: AppColors.brightCyan,
              ),
              length: 4,
              enableActiveFill: false,
              onChanged: (value) {},
            ),

            SizedBox(
              height: 26.h,
            ),
            CustomButton(
              onTap: () {
                context.pushNamed(
                  RoutePath.resetPasswordScreen,
                );
              },
              textColor: AppColors.white,
              title: AppStrings.verifyCode,
            ),
            SizedBox(
              height: 36.h,
            ),
            CustomRichText(
                firstText: AppStrings.haveEntGotTheEmail,
                secondText: AppStrings.resendEmail,
                onTapAction: () {})
          ],
        ),
      ),
    );
  }
}
