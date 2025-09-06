import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

import '../../../../../../../core/route_path.dart';

class PaymentMethodsScreen extends StatelessWidget {
  PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "U Tee Hub Payment Methods",
              fontSize: 18,
              font: CustomFont.poppins,
              fontWeight: FontWeight.w500,
              color: AppColors.darkNaturalGray,
              bottom: 10,
            ),
            Row(
              children: [
                Assets.icons.gg.image(),SizedBox(width: 20.w,),
                Assets.icons.pay.image(),SizedBox(width: 20.w,),
                Assets.icons.paypal.image(),
              ],
            ),
            CustomText(
              textAlign: TextAlign.start,
              top: 10,
              maxLines: 10,
              text:
                  "U TEE HUB offers multiple secure and convenient payment options to ensure a seamless checkout experience. The available payment methods may vary based on:",
              fontSize: 14,
              font: CustomFont.poppins,
              fontWeight: FontWeight.w400,
              color: AppColors.naturalGray,
              bottom: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Assets.icons.gg.image(),
                Expanded(
                  child: CustomText(
                    textAlign: TextAlign.start,
                    left: 8,
                    text: "Fast, secure, and globally accepted",
                    fontSize: 18,
                    font: CustomFont.poppins,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkNaturalGray,
                    bottom: 10,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Assets.icons.pay.image(),
                Expanded(
                  child: CustomText(
                    textAlign: TextAlign.start,
                    left: 8,
                    text: "One-tap checkout for a seamless shopping experience",
                    fontSize: 18,
                    font: CustomFont.poppins,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkNaturalGray,
                    bottom: 10,
                    maxLines: 2,
                  ),
                ),
              ],
            ),

            SizedBox(height: 80,),
            CustomButton(onTap: (){
              context.pushNamed(
                RoutePath.helpCenterScreen,
              );
            },title: "Contact Us",)

          ],
        ),
      ),
    );
  }
}
