import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/global/helper/validators/validators.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';

import '../../../../common_widgets/loading_button/loading_button.dart';

class NextScreen extends StatefulWidget {
  const NextScreen({super.key});

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  final AuthController controller = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // 🔑 Form key added
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),

                /// Password Field
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
                    textEditingController:
                        controller.businessPasswordController,
                    prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                    hintText: "Enter Your Password",
                    validator: Validators.passwordValidator),

                SizedBox(height: 20.h),

                /// Confirm Password Field
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
                  textEditingController:
                      controller.businessConfirmPasswordController,
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  hintText: "Confirm Your Password",
                  validator: (value) {
                    return Validators.confirmPasswordValidator(
                        value, controller.businessPasswordController.text);
                  },
                ),

                SizedBox(height: 30.h),

                /// Password Rules
                Text(
                  "Password Requirements:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: AppColors.darkNaturalGray,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "• Minimum 8-12 characters\n"
                  "• At least one uppercase letter (A-Z)\n"
                  "• At least one special character (!, @, #, \$, etc.)\n"
                  "• At least one number (0-9)",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.darkNaturalGray,
                  ),
                ),

                SizedBox(height: 30.h),

                /// Submit Button
                LoadingButton(
                  isLoading: controller.isVendorLoading,
                  title: "Submit",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.vendorSIgnUp(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
