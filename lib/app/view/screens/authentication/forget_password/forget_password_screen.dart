import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/global/helper/validators/validators.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';

import '../../../common_widgets/loading_button/loading_button.dart';

class ForgetPasswordScreen extends StatelessWidget {
   ForgetPasswordScreen({super.key});


  final AuthController controller = Get.find<AuthController>();
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: AppStrings.forgotPassword,
          iconData: Icons.arrow_back,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                CustomText(
                  textAlign: TextAlign.start ,
                  maxLines: 2,
                  text: AppStrings.pleaseEnterYourEmailToReset,
                  font: CustomFont.inter,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.naturalGray,
                ),
                SizedBox(
                  height: 100.h,
                ),
                CustomFromCard(
                    hinText: AppStrings.enterYourEmail,
                    title: AppStrings.yourEmail,
                    controller: controller.emailController,
                    validator: Validators.emailValidator),
                SizedBox(
                  height: 12.h,
                ),


                LoadingButton(
                  isLoading: controller.isForgetLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.forgetMethod();
                    }
                  },
                  title: "Send Code",
                ),

              ],
            ),
          ),
        ));
  }
}
