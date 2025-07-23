import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/custom_assets/assets.gen.dart';
import '../custom_button/custom_button.dart';
import '../custom_text/custom_text.dart';


class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 100.h,),

            Assets.images.noInternet.image(),
            const CustomText(
              top: 12,
              text: "Woops",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.googleAuthButton,
              bottom:12 ,
            ), const CustomText(
              text: "No Internet",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.googleAuthButton,
              maxLines: 2,
            ),
            SizedBox(height: 24.h,),

            ///=====================TryAgain Button===================
            CustomButton(
              onTap:onTap,
              title: "Try Again",
            )
          ],
        ),
      ),
    );
  }
}
