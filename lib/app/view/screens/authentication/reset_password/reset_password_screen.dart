import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: AppStrings.resetPassword,
          iconData: Icons.arrow_back,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 26.h,
                ),
                CustomText(
                  textAlign: TextAlign.start ,
                  text: AppStrings.setANewPassword,
                  font: CustomFont.poppins,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkNaturalGray,
                ),

                CustomText(
                  top: 5,
                  maxLines: 2,
                  textAlign: TextAlign.start ,
                  text: AppStrings.createANewPassword,
                  font: CustomFont.inter,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.naturalGray,
                ),
                SizedBox(
                  height: 100.h,
                ),
                CustomFromCard(
                  isPassword: true,
                    hinText: AppStrings.enterYourNewPassword,
                    title: AppStrings.password,
                    controller: TextEditingController(),
                    validator: (v) {}),
                SizedBox(
                  height: 12.h,
                ),

                CustomFromCard(
                  isPassword: true,
                    hinText: AppStrings.reEnterPassword,
                    title: AppStrings.confirmPassword,
                    controller: TextEditingController(),
                    validator: (v) {}),
                SizedBox(
                  height: 12.h,
                ),
                CustomButton(
                  onTap: () {
                    context.goNamed(
                      RoutePath.signInScreen,
                    );
                  },
                  title: AppStrings.updatePassword,
                )
              ],
            ),
          ),
        ));
  }
}
