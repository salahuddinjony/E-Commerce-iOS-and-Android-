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

class NextScreen extends StatefulWidget {
  const NextScreen({super.key});

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _passwordError;
  String? _confirmPasswordError;

  bool _isValidPassword(String password) {
    final lengthValid = password.length >= 8 && password.length <= 12;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    return lengthValid && hasUppercase && hasSpecialChar && hasNumber;
  }

  void _validatePassword(String password) {
    if (password.isEmpty) {
      _passwordError = 'Password cannot be empty';
    } else if (password.length < 8 || password.length > 12) {
      _passwordError = 'Password must be 8-12 characters long';
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      _passwordError = 'Must contain at least one uppercase letter';
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      _passwordError = 'Must contain at least one special character';
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      _passwordError = 'Must contain at least one number';
    } else {
      _passwordError = null;
    }
  }

  void _validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'Confirm Password cannot be empty';
    } else if (confirmPassword != _passwordController.text) {
      _confirmPasswordError = 'Passwords do not match';
    } else {
      _confirmPasswordError = null;
    }
  }

  bool get _isFormValid =>
      _passwordError == null &&
          _confirmPasswordError == null &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      setState(() {
        _validatePassword(_passwordController.text);
        _validateConfirmPassword(_confirmPasswordController.text);
      });
    });

    _confirmPasswordController.addListener(() {
      setState(() {
        _validateConfirmPassword(_confirmPasswordController.text);
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: AppStrings.createAccount,
          iconData: Icons.arrow_back,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100.h,
                ),
                // Password
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
                  textEditingController: _passwordController,
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  hintText: "Enter Your Password",
                ),
                if (_passwordError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      _passwordError!,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),

                SizedBox(height: 20.h),

                // Confirm Password
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
                  textEditingController: _confirmPasswordController,
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  hintText: "Confirm Your Password",
                ),
                if (_confirmPasswordError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      _confirmPasswordError!,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),

                SizedBox(
                  height: 12.h,
                ),


                // Add the password requirements info below the button for user reference
                SizedBox(height: 30.h),
                Text(
                  "Password Requirements:",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: AppColors.darkNaturalGray),
                ),
                SizedBox(height: 8.h),
                Text(
                  "• Minimum 8-12 characters\n"
                      "• At least one uppercase letter (A-Z)\n"
                      "• At least one special character (!, @, #, \$, etc.)\n"
                      "• At least one number (0-9)",
                  style: TextStyle(fontSize: 13.sp, color: AppColors.darkNaturalGray),
                ),
                SizedBox(height: 30.h),

                CustomButton(
                  onTap: _isFormValid
                      ? () {
                    context.pushNamed(RoutePath.homeScreen);
                  }
                      : null,
                  title: "Submit",
                ),

              ],
            ),
          ),
        ));
  }
}
