import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xCCEDC4AC), // First color (with opacity)
                    Color(0xFFE9864E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    const CustomText(
                      textAlign: TextAlign.start,
                      text: AppStrings.welcomeToTheCustomHUb,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: AppColors.black,
                    ),

                    SizedBox(
                      height: 10.h,
                    ),

                    //ToDo ==========✅✅ Email✅✅==========
                    CustomFromCard(
                        hinText: AppStrings.enterYourEmail,
                        title: AppStrings.email,
                        controller: TextEditingController(),
                        validator: (v) {}),
                    //ToDo ==========✅✅ password ✅✅==========
                    CustomFromCard(
                        isPassword: true,
                        hinText: AppStrings.email,
                        title: AppStrings.password,
                        controller: TextEditingController(),
                        validator: (v) {}),

                    ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡Forgot Password💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========

                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: authController.isRemember.value,
                    //       checkColor: AppColors.white50,
                    //       activeColor: AppColors.black,
                    //       onChanged: (value) {
                    //         authController.isRemember.value =
                    //             value ?? false;
                    //         debugPrint(
                    //             "Checkbox clicked, Remember value: ${authController.isRemember.value}");
                    //       },
                    //     ),
                    //     const CustomText(
                    //       top: 12,
                    //       text: AppStrings.rememberMe,
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w500,
                    //       color: AppColors.black,
                    //       bottom: 15,
                    //     ),
                    //     const Spacer(),
                    //     GestureDetector(
                    //       onTap: () {
                    //         AppRouter.route.pushNamed(
                    //             RoutePath.forgetPasswordScreen,
                    //             extra: userRole);
                    //       },
                    //       child: CustomText(
                    //         top: 12,
                    //         text: AppStrings.forgotPassword.tr,
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w500,
                    //         color: AppColors.black,
                    //         bottom: 15,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  //ToDo ==========✅✅ Sing In Button✅✅==========
                  CustomButton(
                    onTap: () {},
                    title: AppStrings.signUp,
                    fillColor: Colors.black,
                    textColor: Colors.white,
                  ),

                  SizedBox(
                    height: 50.h,
                  ),
                ],
              )),
        ],
      )),
    );
  }
}
