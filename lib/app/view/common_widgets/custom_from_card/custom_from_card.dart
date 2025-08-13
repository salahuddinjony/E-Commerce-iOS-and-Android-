
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';


class CustomFromCard extends StatelessWidget {
  final String title;
  final String? hinText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool isPassword;
  final bool isRead;
  final bool? isBgColor;
  final int? maxLine;

  const CustomFromCard({
    super.key,
    required this.title,
    required this.controller,
    required this.validator,
    this.isPassword = false,
    this.isRead = false,
    this.hinText,
    this.maxLine, this.isBgColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          font: CustomFont.inter,
          color: AppColors.darkNaturalGray,
          text: title,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          bottom: 8.h,
        ),
        CustomTextField(
          maxLines: isPassword ? 1 : (maxLine ?? 1), // Ensure single line for password
          hintStyle: const TextStyle(color: AppColors.black),
          readOnly: isRead,
          validator: validator,
          isPassword: isPassword,
          textEditingController: controller,
          hintText: hinText,
          inputTextStyle: const TextStyle(color: AppColors.black),
          fillColor:isBgColor ==true? AppColors.black:AppColors.white,
          fieldBorderColor: AppColors.borderColor,
          keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.text,
        ),

        SizedBox(height: 14.h,)
      ],
    );
  }
}
