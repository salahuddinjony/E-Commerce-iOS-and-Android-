import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/common_widgets/loading_button/loading_button.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import 'package:local/app/view/screens/authentication/reset_password/widgets/reset_header.dart';

import '../../../../global/helper/validators/validators.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final AuthController controller = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

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
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ResetHeader(),
                  CustomFromCard(
                      isPassword: true,
                      hinText: AppStrings.enterYourNewPassword,
                      title: AppStrings.password,
                      controller: controller.passWordController,
                      validator: Validators.passwordValidator),
                  SizedBox(
                    height: 12.h,
                  ),
                  CustomFromCard(
                    isPassword: true,
                    hinText: AppStrings.reEnterPassword,
                    title: AppStrings.confirmPassword,
                    controller: controller.confirmPasswordController,
                    validator: (value) {
                      return Validators.confirmPasswordValidator(
                          value, controller.passWordController.text);
                    },
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  LoadingButton(
                    isLoading: controller.isResetLoading,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        controller.resetPassword();
                      }
                    },
                    title: AppStrings.updatePassword,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
