import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import 'package:local/app/view/screens/authentication/otp/widgets/otp_header.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../common_widgets/custom_rich_text/custom_rich_text.dart';
import '../../../common_widgets/loading_button/loading_button.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final AuthController controller = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra as Map<String, dynamic>?;
    final bool isForgetValue = extra?['isForget'] ?? false;
    final String email = extra?['email'] ?? '';
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OtpHeader(email: email),

              ///: <<<<<<====== OTP Pin Code Field ======>>>>>>>>
              PinCodeTextField(
                textStyle: TextStyle(color: AppColors.black, fontSize: 24.sp),
                keyboardType: TextInputType.number,
                autoDisposeControllers: false,
                cursorColor: AppColors.black,
                appContext: context,
                controller: controller.pinCodeController,
                onCompleted: (value) {
                  controller.resetCode = value;
                  // if (isForgetValue == true) {
                  //   // controller.activationCode = value;
                  // } else if (isForgetValue == false) {
                  //   // controller.resetCode = value;
                  // } else {
                  //   print('object');
                  // }
                },
                validator: (value) {
                  if (value == null || value.length != 4) {
                    return "Please enter a 6-digit OTP code";
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
              LoadingButton(
                isLoading: controller.isForgetOtp,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    controller.forgetOtp();
                  }
                },
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
      ),
    );
  }
}


