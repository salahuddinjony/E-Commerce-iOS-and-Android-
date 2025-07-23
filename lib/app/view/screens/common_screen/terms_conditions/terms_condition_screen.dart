import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/text_section/text_section.dart';
import 'package:local/app/view/screens/common_screen/controller/info_controller.dart';

import '../../../../utils/enums/status.dart';
import '../../../common_widgets/custom_loader/custom_loader.dart';
import '../../../common_widgets/genarel_screen/genarel_screen.dart';
import '../../../common_widgets/no_internet/no_internet.dart';

class TermsConditionScreen extends StatelessWidget {
   TermsConditionScreen({super.key});

  final InfoController controller = Get.find<InfoController>();
  @override
  Widget build(BuildContext context) {
    controller.getTerms();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.termsOfService,
        iconData: Icons.arrow_back,
      ),
      body:
      Obx(() {
        switch (controller.rxRequestStatus.value) {
          case Status.loading:
            return const CustomLoader();

          case Status.internetError:
            return NoInternetScreen(onTap: controller.getTerms);

          case Status.error:
            return GeneralErrorScreen(onTap: controller.getTerms);

          case Status.completed:
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Html(
                data: controller.termsData.value.termsCondition ?? "",
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
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
      //   child: const SingleChildScrollView(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         TextSection(
      //           title: "Introduction",
      //           content:
      //               "Welcome to T-Shirt Hub! By accessing our website or mobile application, you agree to comply with the following terms and conditions. If you do not agree with any part of these terms, please do not use our services.",
      //         ),
      //         TextSection(
      //           title: "User Eligibility",
      //           content:
      //               "You must be at least 18 years old to place an order. By using our platform, you confirm that the information you provide is accurate and complete.",
      //         ),
      //         TextSection(
      //           title: "Account Registration & Security",
      //           content:
      //               "Users must create an account to access certain features. You are responsible for maintaining the confidentiality of your account credentials. T-Shirt Hub is not liable for unauthorized access due to a compromised password.",
      //         ),
      //         TextSection(
      //           title: "Shipping & Delivery",
      //           content:
      //               "Estimated delivery times are provided at checkout but may vary due to unforeseen circumstances. T-Shirt Hub is not responsible for delays caused by third-party delivery services. If your order is delayed beyond the estimated delivery date, please contact customer support.",
      //         ),
      //         TextSection(
      //           title: "User Conduct",
      //           content:
      //               "Users must not engage in fraudulent activities, abuse the platform, or violate laws. Any misuse of the platform may result in account suspension or legal action.",
      //         ),
      //         TextSection(
      //           title: "Limitation of Liability",
      //           content:
      //               "T-Shirt Hub is not responsible for indirect, incidental, or consequential damages arising from the use of our platform. Our total liability for any claim shall not exceed the amount paid for the purchased product.",
      //         ),
      //
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
