import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/global/helper/validators/validators.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import 'package:local/app/view/screens/authentication/sign_in/widget/forget_section.dart';
import 'package:local/app/view/screens/authentication/sign_in/widget/google_apple_section.dart';
import '../../../common_widgets/loading_button/loading_button.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final AuthController controller = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: AppStrings.logIn,
          iconData: Icons.arrow_back,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 100.h,
                  ),

                  //==================Email=============
                  CustomFromCard(
                      hinText: AppStrings.enterYourEmail,
                      title: AppStrings.yourEmail,
                      controller: controller.emailController,
                      validator: Validators.emailValidator),
                  //==============Password===========
                  CustomFromCard(
                      isPassword: true,
                      hinText: "Enter Your Password",
                      title: AppStrings.password,
                      controller: controller.passWordController,
                      validator: Validators.passwordValidator),
                  //==============Forget============
                  const ForgetPassword(),
                  SizedBox(
                    height: 12.h,
                  ),
                  //=================Button==============
                  LoadingButton(
                    isLoading: controller.isSignInLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        controller.signIn();
                      }
                    },
                    title: AppStrings.continues,
                  ),



                  SizedBox(
                    height: 25.h,
                  ),
                  //==============Google Apple Section===============
                  const GoogleAppleSection()
                ],
              ),
            ),
          ),
        ));
  }
}
