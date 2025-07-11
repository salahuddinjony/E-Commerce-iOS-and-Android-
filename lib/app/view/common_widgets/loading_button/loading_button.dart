import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class LoadingButton extends StatelessWidget {
  final RxBool isLoading;
  final VoidCallback? onTap;
  final String title;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomButton(
        onTap: isLoading.value ? null : onTap,
        child: isLoading.value
            ? const SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            color: AppColors.borderColor,
            strokeWidth: 2.5,
          ),
        )
            : CustomText(
          text: title,
          font: CustomFont.inter,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      );
    });
  }
}
