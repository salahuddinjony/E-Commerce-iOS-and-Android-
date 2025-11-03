import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/common_screen/controller/info_controller.dart';

import '../../../../utils/enums/status.dart';
import '../../../common_widgets/custom_loader/custom_loader.dart';
import '../../../common_widgets/genarel_screen/genarel_screen.dart';
import '../../../common_widgets/no_internet/no_internet.dart';

class PrivacyPolicyScreen extends StatelessWidget {
   PrivacyPolicyScreen({super.key});

  final InfoController controller = Get.find<InfoController>();
  @override
  Widget build(BuildContext context) {
    controller.getPrivacy();
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
            final privacyPolicy = controller.privacyData.value.privacyPolicy ?? "";
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Html(
                data: privacyPolicy.isEmpty ? "<p>No content available</p>" : privacyPolicy,
                style: {
                  "body": Style(
                    fontSize: FontSize(14.sp),
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.start,
                    lineHeight: LineHeight(1.6),
                  ),
                  "h1": Style(
                    fontSize: FontSize(20.sp),
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                    margin: Margins.only(top: 16.h, bottom: 8.h),
                  ),
                  "h2": Style(
                    fontSize: FontSize(18.sp),
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                    margin: Margins.only(top: 14.h, bottom: 6.h),
                  ),
                  "h3": Style(
                    fontSize: FontSize(16.sp),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    margin: Margins.only(top: 12.h, bottom: 6.h),
                  ),
                  "p": Style(
                    fontSize: FontSize(14.sp),
                    color: AppColors.black,
                    margin: Margins.only(bottom: 12.h),
                    lineHeight: LineHeight(1.6),
                    textAlign: TextAlign.justify,
                  ),
                  "ul": Style(
                    margin: Margins.only(left: 10.w, bottom: 12.h),
                  ),
                  "ol": Style(
                    margin: Margins.only(left: 10.w, bottom: 12.h),
                  ),
                  "li": Style(
                    fontSize: FontSize(14.sp),
                    color: AppColors.black,
                    margin: Margins.only(bottom: 6.h),
                    lineHeight: LineHeight(1.5),
                  ),
                  "strong": Style(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                  "b": Style(
                    fontWeight: FontWeight.bold,
                  ),
                  "em": Style(
                    fontStyle: FontStyle.italic,
                  ),
                  "i": Style(
                    fontStyle: FontStyle.italic,
                  ),
                  "a": Style(
                    color: AppColors.brightCyan,
                    textDecoration: TextDecoration.underline,
                  ),
                  "div": Style(
                    margin: Margins.only(bottom: 10.h),
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
      //               "Briefly explain why the Privacy Policy exists.\nMention that you value customer privacy and data security.",
      //         ),
      //         TextSection(
      //           title: "Information We Collect",
      //           content:
      //               "Personal Data: Name, email, phone number, shipping address. Payment Information: Credit card, mobile wallet details (encrypted). Usage Data: Browsing history, device type, IP address. Cookies & Tracking Technologies: Used for personalization and analytics.",
      //         ),
      //         TextSection(
      //           title: "How We Use Your Information",
      //           content:
      //               "To process and deliver orders. To improve the shopping experience. For fraud prevention and security. To send promotional offers (with user consent).",
      //         ),
      //         TextSection(
      //           title: "How We Share Your Information",
      //           content:
      //               "With trusted third-party services (payment gateways, delivery partners). For legal compliance (if required by law). No selling of user data to third parties.",
      //         ),
      //         TextSection(
      //           title: "Data Security Measures",
      //           content:
      //               "Encryption of payment details. Secure storage of user data. Protection against unauthorized access.",
      //         ),
      //         TextSection(
      //           title: "Cookies & Tracking Policy",
      //           content:
      //               "Explanation of how cookies are used for site functionality. How users can disable cookies.",
      //         ),
      //         TextSection(
      //           title: "Contact Information",
      //           content:
      //               "Customer support contact for privacy-related inquiries.",
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
