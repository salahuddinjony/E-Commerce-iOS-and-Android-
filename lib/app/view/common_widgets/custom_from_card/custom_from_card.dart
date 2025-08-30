import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';

class CustomFromCardController extends GetxController {
  final TextEditingController? externalController;
  late final TextEditingController controller;

  CustomFromCardController([this.externalController]) {
    controller = externalController ?? TextEditingController();
  }

  @override
  void onClose() {
    if (externalController == null) {
      controller.dispose();
    }
    super.onClose();
  }
}

class CustomFromCard extends StatelessWidget {
  final String title;
  final String? hinText;
  final TextEditingController? controller; // optional external controller
  final String? Function(String?) validator;
  final bool isPassword;
  final bool isRead;
  final bool? isBgColor;
  final int? maxLine;

  const CustomFromCard({
    super.key,
    required this.title,
    required this.validator,
    this.controller,
    this.isPassword = false,
    this.isRead = false,
    this.hinText,
    this.maxLine,
    this.isBgColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomFromCardController>(
      // init controller per widget instance so it manages lifecycle (disposes when removed)
      init: CustomFromCardController(controller),
      builder: (con) => Column(
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
            maxLines: isPassword ? 1 : (maxLine ?? 1),
            hintStyle: const TextStyle(color: AppColors.black),
            readOnly: isRead,
            validator: validator,
            isPassword: isPassword,
            textEditingController: con.controller,
            hintText: hinText,
            inputTextStyle: const TextStyle(color: AppColors.black),
            fillColor: isBgColor == true ? AppColors.black : AppColors.white,
            fieldBorderColor: AppColors.borderColor,
            keyboardType:
                isPassword ? TextInputType.visiblePassword : TextInputType.text,
          ),
          SizedBox(height: 14.h),
        ],
      ),
    );
  }
}
