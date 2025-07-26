import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.icon,
    this.readOnly = false,
    this.validator,
    this.keyboardType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          top: 8.h,
          text: label,
          fontSize: 16.sp,
          bottom: 8.h,
          fontWeight: FontWeight.w500,
          color: AppColors.darkNaturalGray,
        ),
        CustomTextField(
          readOnly: readOnly,
          inputTextStyle: const TextStyle(color: AppColors.black),
          fieldBorderColor: AppColors.borderColor,
          textEditingController: controller,
          prefixIcon: Icon(icon),
          hintText: hintText,
          validator: validator,
          onTap: onTap,
        ),
      ],
    );
  }
}
