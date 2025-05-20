import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';



class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';
    if (value.length < 8 || value.length > 12) return 'Password must be 8-12 characters long';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Must contain at least one uppercase letter';
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) return 'Must contain at least one special character';
    if (!RegExp(r'\d').hasMatch(value)) return 'Must contain at least one number';
    return null;
  }

  String? _validateRepeatPassword(String? value) {
    if (value == null || value.isEmpty) return 'Repeat Password cannot be empty';
    if (value != _newPasswordController.text) return 'Passwords do not match';
    return null;
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      context.pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully!')),
      );
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bullet = "• ";
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.changePassword,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomFromCard(
                  hinText: "Current Password",
                  isPassword: true,
                  title: AppStrings.currentPassword,
                  controller: _currentPasswordController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter current password';
                    }
                    return null;
                  },
                ),

                CustomFromCard(
                  hinText: "New Password",
                  isPassword: true,
                  title: AppStrings.newPassword,
                  controller: _newPasswordController,
                  validator: _validatePassword,
                ),

                CustomFromCard(
                  hinText: "Repeat Password",
                  isPassword: true,
                  title: AppStrings.repeatPassword,
                  controller: _repeatPasswordController,
                  validator: _validateRepeatPassword,
                ),
                SizedBox(height: 24.h),

                CustomButton(onTap: _onSave, title: AppStrings.save),

                SizedBox(height: 24.h),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$bullet Minimum 8-12 characters'),
                      Text('$bullet At least one uppercase letter (A-Z)'),
                      Text('$bullet Special characters (!, @, #, \$, etc.)'),
                      Text('$bullet At least one number (0-9)'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
