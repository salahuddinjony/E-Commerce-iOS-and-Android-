import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import '../../../../../global/helper/validators/validators.dart';
import '../../../../common_widgets/loading_button/loading_button.dart';
import 'label_text_field.dart';

class ClientSignUpForm extends StatelessWidget {
  final AuthController controller;

  ClientSignUpForm({super.key, required this.controller});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
              label: AppStrings.name,
              hintText: 'Enter Your Name',
              controller: controller.nameController,
              icon: Icons.person,
              validator: Validators.nameValidator),
          LabeledTextField(
              label: AppStrings.name,
              hintText: 'Enter Your Email',
              controller: controller.clientEmailController,
              icon: Icons.email,
              validator: Validators.emailValidator),
          LabeledTextField(
              label: AppStrings.phone,
              hintText: 'Enter Your Phone',
              controller: controller.clientPhoneNumberController,
              icon: Icons.phone,
              validator: Validators.phoneNumberValidator),
          LabeledTextField(
              label: AppStrings.password,
              hintText: 'Enter Your Password',
              controller: controller.clientPasswordController,
              icon: Icons.lock,
              validator: Validators.passwordValidator),
          LabeledTextField(
            label: AppStrings.confirmPassword,
            hintText: 'Enter Your Confirm Password',
            controller: controller.clientConfirmPasswordController,
            icon: Icons.lock,
            validator: (value) {
              return Validators.confirmPasswordValidator(
                  value, controller.clientPasswordController.text);
            },
          ),
          SizedBox(height: 8.h),
          Text(
            "• Minimum 8-12 characters\n"
            "• At least one uppercase letter (A-Z)\n"
            "• Special characters (!, @, #, \$, etc.)\n"
            "• At least one number (0-9)",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.darkNaturalGray,
            ),
          ),
          SizedBox(height: 20.h),
          LoadingButton(
            isLoading: controller.isClient,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                controller.clientSIgnUp(context);
              }
            },
            title: "Continue",
          ),

        ],
      ),
    );
  }
}
