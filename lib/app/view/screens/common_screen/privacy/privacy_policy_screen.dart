import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';

import '../../../../utils/enums/status.dart';
import '../../../common_widgets/custom_loader/custom_loader.dart';
import '../../../common_widgets/genarel_screen/genarel_screen.dart';
import '../../../common_widgets/no_internet/no_internet.dart';
import '../controller/info_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
   PrivacyPolicyScreen({super.key});
  final InfoController controller = Get.find<InfoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.privacyPolicy,
        iconData: Icons.arrow_back,
      ),
      body:
      Obx(() {
        switch (controller.rxRequestStatus.value) {
          case Status.loading:
            return const CustomLoader();

          case Status.internetError:
            return NoInternetScreen(onTap: controller.getPrivacy);

          case Status.error:
            return GeneralErrorScreen(onTap: controller.getPrivacy);

          case Status.completed:
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Html(
                data: controller.privacyData.value.privacyPolicy ?? "",
                style: {
                  "body": Style(
                    fontSize: FontSize(16.sp),
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.start,
                  ),
                },
              ),
            );
        }
      }),

    );
  }
}


// TextSection(
//                 title: "Introduction",
//                 content:
//                     "Briefly explain why the Privacy Policy exists.\nMention that you value customer privacy and data security.",
//               ),