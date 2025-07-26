import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';

import '../../../../../core/route_path.dart';
import '../../../../../core/routes.dart';
import '../../../../../global/helper/validators/validators.dart';

class ClientSignUpForm extends StatelessWidget {
  final AuthController controller;

  ClientSignUpForm({super.key, required this.controller});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: AppStrings.name,
            fontSize: 16.sp,
            bottom: 8.h,
            fontWeight: FontWeight.w500,
            color: AppColors.darkNaturalGray,
          ),
          CustomTextField(
            inputTextStyle: const TextStyle(color: AppColors.black),
            fieldBorderColor: AppColors.borderColor,
            textEditingController: controller.nameController,
            prefixIcon: const Icon(Icons.person),
            hintText: "Enter Your Name",
            validator: Validators.nameValidator,
          ),
          CustomText(
            top: 8.h,
            text: 'E-mail/phone number',
            fontSize: 16.sp,
            bottom: 8.h,
            fontWeight: FontWeight.w500,
            color: AppColors.darkNaturalGray,
          ),
          CustomTextField(
            inputTextStyle: const TextStyle(color: AppColors.black),
            fieldBorderColor: AppColors.borderColor,
            textEditingController: controller.clientEmailController,
            prefixIcon: const Icon(Icons.email),
            hintText: "Enter Your E-mail or Phone Number",
            validator: Validators.emailValidator,
          ),
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
            textEditingController: controller.clientPasswordController,
            prefixIcon: const Icon(Icons.lock),
            hintText: "Enter Your Password",
            validator: Validators.passwordValidator,
          ),
          SizedBox(height: 8.h),
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
            textEditingController: controller.clientConfirmPasswordController,
            prefixIcon: const Icon(Icons.lock),
            hintText: "Enter Your Confirm Password",
            validator: (value) {
              return Validators.confirmPasswordValidator(
                  value, controller.clientPasswordController.text);
            },
          ),
          SizedBox(height: 8.h),
          Text(
            "• Minimum 8-12 characters\n"
            "• At least one uppercase letter (A-Z)\n"
            "• Special characters (!, @, #, \$, etc.)\n"
            "• At least one number (0-9)",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.darkNaturalGray,
            ),
          ),
          SizedBox(height: 20.h),
          CustomButton(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                AppRouter.route.pushNamed(RoutePath.userHomeScreen);
              }
            },
            title: AppStrings.continues,
          )
        ],
      ),
    );
  }
}
