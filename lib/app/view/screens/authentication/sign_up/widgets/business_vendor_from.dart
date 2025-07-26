import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';

import '../../../../../core/routes.dart';

class BusinessVendorForm extends StatelessWidget {
  final AuthController controller;

   BusinessVendorForm({super.key, required this.controller});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Business Name',
            fontSize: 16.sp,
            bottom: 8.h,
            fontWeight: FontWeight.w500,
            color: AppColors.darkNaturalGray,
          ),
          CustomTextField(
            inputTextStyle: const TextStyle(color: AppColors.black),
            fieldBorderColor: AppColors.borderColor,
            textEditingController: TextEditingController(),
            prefixIcon: const Icon(Icons.business_center_rounded),
            hintText: "Business Name",
          ),

          CustomText(
            top: 8.h,
            text: 'Owner\'s Name',
            fontSize: 16.sp,
            bottom: 8.h,
            fontWeight: FontWeight.w500,
            color: AppColors.darkNaturalGray,
          ),
          CustomTextField(
            inputTextStyle: const TextStyle(color: AppColors.black),
            fieldBorderColor: AppColors.borderColor,
            textEditingController: TextEditingController(),
            prefixIcon: const Icon(Icons.person),
            hintText: "Owner's Name",
          ),

          CustomText(
            top: 8.h,
            text: 'Business E-mail',
            fontSize: 16.sp,
            bottom: 8.h,
            fontWeight: FontWeight.w500,
            color: AppColors.darkNaturalGray,
          ),
          CustomTextField(
            inputTextStyle: const TextStyle(color: AppColors.black),
            fieldBorderColor: AppColors.borderColor,
            textEditingController: TextEditingController(),
            prefixIcon: const Icon(Icons.email),
            hintText: "Business E-mail",
          ),

          CustomText(
            top: 8.h,
            text: 'Federal ID',
            fontSize: 16.sp,
            bottom: 8.h,
            fontWeight: FontWeight.w500,
            color: AppColors.darkNaturalGray,
          ),
          CustomTextField(
            inputTextStyle: const TextStyle(color: AppColors.black),
            fieldBorderColor: AppColors.borderColor,
            textEditingController: TextEditingController(),
            prefixIcon: const Icon(Icons.image),
            hintText: "Upload Federal ID",
          ),

          CustomText(
            top: 8.h,
            text: 'Both State License',
            fontSize: 16.sp,
            bottom: 8.h,
            fontWeight: FontWeight.w500,
            color: AppColors.darkNaturalGray,
          ),
          CustomTextField(
            inputTextStyle: const TextStyle(color: AppColors.black),
            fieldBorderColor: AppColors.borderColor,
            textEditingController: TextEditingController(),
            prefixIcon: const Icon(Icons.image),
            hintText: "Upload both state license",
          ),

          SizedBox(height: 20.h),

          CustomButton(
            onTap: () {
              AppRouter.route.pushNamed(RoutePath.nextScreen);

            },
            title: "Next",
          ),
        ],
      ),
    );
  }
}
