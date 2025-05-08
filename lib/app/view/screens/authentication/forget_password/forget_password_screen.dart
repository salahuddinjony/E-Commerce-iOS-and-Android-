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

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: AppStrings.forgotPassword,
          iconData: Icons.arrow_back,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              CustomText(
                textAlign: TextAlign.start ,
                maxLines: 2,
                text: AppStrings.pleaseEnterYourEmailToReset,
                font: CustomFont.inter,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.naturalGray,
              ),
              SizedBox(
                height: 100.h,
              ),
              CustomFromCard(
                  hinText: AppStrings.enterYourEmail,
                  title: AppStrings.yourEmail,
                  controller: TextEditingController(),
                  validator: (v) {}),
              SizedBox(
                height: 12.h,
              ),
              CustomButton(
                onTap: () {
                  context.pushNamed(
                    RoutePath.resetPasswordScreen,
                  );
                },
                title: AppStrings.resetPassword,
              )
            ],
          ),
        ));
  }
}
