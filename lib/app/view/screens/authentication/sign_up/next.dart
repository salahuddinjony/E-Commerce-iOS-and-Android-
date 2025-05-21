import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: AppStrings.createAccount,
          iconData: Icons.arrow_back,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100.h,
              ),
              //=======================
              CustomText(
                top: 8.h,
                text: AppStrings.password,
                fontSize: 16.sp,
                bottom: 8.h,
                fontWeight: FontWeight.w500,
                color: AppColors.darkNaturalGray,
              ),
              CustomTextField(
                inputTextStyle: const TextStyle(color: AppColors.black),

                isPassword: true,
                fieldBorderColor: AppColors.borderColor,
                textEditingController: TextEditingController(),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                hintText: "Enter Your Password",
              ),

              //=======================
              CustomText(
                top: 8.h,
                text: AppStrings.confirmPassword,
                fontSize: 16.sp,
                bottom: 8.h,
                fontWeight: FontWeight.w500,
                color: AppColors.darkNaturalGray,
              ),
              CustomTextField(
                inputTextStyle: const TextStyle(color: AppColors.black),

                isPassword: true,
                fieldBorderColor: AppColors.borderColor,
                textEditingController: TextEditingController(),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                hintText: "Enter Your Password",
              ),
              SizedBox(
                height: 12.h,
              ),
              CustomButton(
                onTap: () {
                  context.pushNamed(
                    RoutePath.homeScreen,
                  );
                },
                title: "Submit ",
              )
            ],
          ),
        ));
  }
}
