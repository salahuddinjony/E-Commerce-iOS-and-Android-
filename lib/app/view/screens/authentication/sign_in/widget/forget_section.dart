import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/route_path.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_strings/app_strings.dart';
import '../../../../common_widgets/custom_text/custom_text.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          context.pushNamed(RoutePath.forgetPasswordScreen);
        },
        child: CustomText(
          text: AppStrings.forgotPassword,
          font: CustomFont.inter,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.brightCyan,
        ),
      ),
    );
  }
}