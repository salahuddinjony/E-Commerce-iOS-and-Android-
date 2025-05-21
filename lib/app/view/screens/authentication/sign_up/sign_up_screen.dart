import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isClientSelected = true; // Default to 'Client'

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle buttons for Client and Business Vendor
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Client'),
                    selected: isClientSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        isClientSelected = true;
                      });
                    },
                    selectedColor: Colors.teal,
                  ),
                  SizedBox(width: 16.w),
                  ChoiceChip(
                    label: const Text('Business Vendor'),
                    selected: !isClientSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        isClientSelected = false;
                      });
                    },
                    selectedColor: Colors.teal,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Display corresponding form based on selection
              isClientSelected ? _buildClientForm() : _buildBusinessVendorForm(),
            ],
          ),
        ),
      ),
    );
  }

  // Client Sign-Up Form
  Widget _buildClientForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //==========Name=============
        CustomText(
          text: AppStrings.name,
          fontSize: 16.sp,
          bottom: 8.h,
          fontWeight: FontWeight.w500,
          color: AppColors.darkNaturalGray,
        ),
        CustomTextField(
          inputTextStyle: const TextStyle(color: AppColors.black),
          fieldBorderColor: AppColors.borderColor,
          textEditingController: nameController,
          prefixIcon: const Icon(Icons.person),
          hintText: "Enter Your Name",
        ),

        //==========Email=============
        CustomText(
          top: 8.h,
          text: 'E-mail/phone number',
          fontSize: 16.sp,
          bottom: 8.h,
          fontWeight: FontWeight.w500,
          color: AppColors.darkNaturalGray,
        ),
        CustomTextField(
          inputTextStyle: const TextStyle(color: AppColors.black),

          fieldBorderColor: AppColors.borderColor,
          textEditingController: emailPhoneController,
          prefixIcon: const Icon(Icons.email),
          hintText: "Enter Your Name",
        ),

        //==========Name=============
        CustomText(
          top: 8.h,
          text: AppStrings.password,
          fontSize: 16.sp,
          bottom: 8.h,
          fontWeight: FontWeight.w500,
          color: AppColors.darkNaturalGray,
        ),
        CustomTextField(
          inputTextStyle: const TextStyle(color: AppColors.black),

          isPassword: true,
          fieldBorderColor: AppColors.borderColor,
          textEditingController: passwordController,
          prefixIcon: const Icon(Icons.lock),
          hintText: "Enter Your Password",
        ),
        //==========Phone Number=============
        CustomText(
          top: 8.h,
          text: AppStrings.confirmPassword,
          fontSize: 16.sp,
          bottom: 8.h,
          fontWeight: FontWeight.w500,
          color: AppColors.darkNaturalGray,
        ),
        CustomTextField(
          inputTextStyle: const TextStyle(color: AppColors.black),

          isPassword: true,
          fieldBorderColor: AppColors.borderColor,
          textEditingController: confirmPasswordController,
          prefixIcon: const Icon(Icons.lock),
          hintText: "Enter Your ConfirmPassword",
        ),
        SizedBox(
          height: 20.h,
        ),
        CustomButton(
          onTap: () {},
          title: AppStrings.continues,
        )
      ],
    );
  }

  // Business Vendor Sign-Up Form
  Widget _buildBusinessVendorForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //==========Name=============
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
          textEditingController: nameController,
          prefixIcon: const Icon(
            Icons.business_center_rounded,
            color: Colors.grey,
          ),
          hintText: "Business Name",
        ),

        //==========Email=============
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
          textEditingController: emailPhoneController,
          prefixIcon: const Icon(Icons.person),
          hintText: "Owner\'s Name",
        ),

        //==========Name=============
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
          textEditingController: passwordController,
          prefixIcon: const Icon(Icons.email),
          hintText: "Business E-mail",
        ),
        //==========Phone Number=============
        CustomText(
          top: 8.h,
          text: ' Federal ID',
          fontSize: 16.sp,
          bottom: 8.h,
          fontWeight: FontWeight.w500,
          color: AppColors.darkNaturalGray,
        ),
        CustomTextField(
          inputTextStyle: const TextStyle(color: AppColors.black),

          fieldBorderColor: AppColors.borderColor,
          textEditingController: confirmPasswordController,
          prefixIcon: const Icon(Icons.image),
          hintText: "Upload Federal ID",
        ),

        //==========Phone Number=============
        CustomText(
          top: 8.h,
          text: ' Both State License',
          fontSize: 16.sp,
          bottom: 8.h,
          fontWeight: FontWeight.w500,
          color: AppColors.darkNaturalGray,
        ),
        CustomTextField(
          inputTextStyle: const TextStyle(color: AppColors.black),

          fieldBorderColor: AppColors.borderColor,
          textEditingController: confirmPasswordController,
          prefixIcon: const Icon(Icons.image),
          hintText: "Upload  both state license",
        ),
        SizedBox(
          height: 20.h,
        ),
        CustomButton(
          onTap: () {
            context.goNamed(
              RoutePath.nextScreen,
            );
          },
          title: "Next",
        )
      ],
    );
  }
}
