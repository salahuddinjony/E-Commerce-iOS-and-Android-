import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class CustomHubScreen extends StatelessWidget {
  const CustomHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          CustomText(
            textAlign: TextAlign.start,
            maxLines: 2,
            text: "Custom Hub – Design Your Own Tee",
            fontWeight: FontWeight.w600,
            font: CustomFont.poppins,
            fontSize: 20.sp,
            color: AppColors.brightCyan,
          ),
          CustomText(
            textAlign: TextAlign.start,
            maxLines: 10,
            text:
                "Welcome to the Custom Hub! Upload your design, choose colors, and personalize your T-shirt exactly how you want.",
            fontWeight: FontWeight.w400,
            font: CustomFont.poppins,
            fontSize: 14.sp,
            color: AppColors.naturalGray,
          ),
          SizedBox(
            height: 20.h,
          ),
          CustomButton(
            onTap: () {
              context.pushNamed(RoutePath.customDesignScreen,
                  extra: {
                    "vendorId": "",
                    "isFromCustomHub": true
                    }
              );
               
            },
            title: "Custom Hub",
          ),
        ],
      );
  }
}
