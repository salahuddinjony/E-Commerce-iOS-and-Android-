import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';
import 'package:local/app/view/common_widgets/custom_auth_container/custom_auth_container.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';

class ChooseAuthScreen extends StatelessWidget {
  const ChooseAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 74.h, horizontal: 20.w),
        child: Column(
          children: [
            Center(child: Assets.images.logo.image()),
            SizedBox(
              height: 46.h,
            ),
            CustomButton(
              onTap: () {
                context.pushNamed(RoutePath.signInScreen,);

              },
              title: AppStrings.logIn,
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomButton(
              onTap: () {
                context.pushNamed(RoutePath.signUpScreen,);

              },
              title: AppStrings.newAccount,
            ),
            SizedBox(
              height: 25.h,
            ),
            // CustomAuthContainer(
            //   buttonText: AppStrings.signUpWithGoogle,  // Text for the button
            //   onPressed: () {
            //     // Handle Google authentication logic here
            //     print('Google Sign-Up button pressed');
            //   }, image: Assets.images.google.image(),
            // ),
            // SizedBox(
            //   height: 14.h,
            // ),
            // CustomAuthContainer(
            //   buttonText: AppStrings.signUpWithApple,  // Text for the button
            //   onPressed: () {
            //     // Handle Google authentication logic here
            //     print('Google Sign-Up button pressed');
            //   }, image: Assets.images.apple.image(),
            // ),

          ],
        ),
      ),
    );
  }
}


