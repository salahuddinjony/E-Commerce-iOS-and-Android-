import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import 'package:local/app/view/screens/authentication/sign_up/widgets/business_vendor_from.dart';
import 'package:local/app/view/screens/authentication/sign_up/widgets/client_sign_up_from.dart';
import 'package:local/app/view/screens/authentication/sign_up/widgets/sign_up_tab.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.createAccount,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //=============+Sign up Tab============
                  SIgnUpTab(controller: controller),

                  SizedBox(height: 20.h),
                  controller.isClientSelected.value
                      ? ClientSignUpForm(controller: controller)
                      : BusinessVendorForm(controller: controller),
                ],
              )),
        ),
      ),
    );
  }
}
