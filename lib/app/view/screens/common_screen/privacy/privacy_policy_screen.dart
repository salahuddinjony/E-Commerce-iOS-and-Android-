import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/text_section/text_section.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.privacyPolicy,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextSection(
                title: "Introduction",
                content:
                    "Briefly explain why the Privacy Policy exists.\nMention that you value customer privacy and data security.",
              ),
              TextSection(
                title: "Information We Collect",
                content:
                    "Personal Data: Name, email, phone number, shipping address. Payment Information: Credit card, mobile wallet details (encrypted). Usage Data: Browsing history, device type, IP address. Cookies & Tracking Technologies: Used for personalization and analytics.",
              ),
              TextSection(
                title: "How We Use Your Information",
                content:
                    "To process and deliver orders. To improve the shopping experience. For fraud prevention and security. To send promotional offers (with user consent).",
              ),
              TextSection(
                title: "How We Share Your Information",
                content:
                    "With trusted third-party services (payment gateways, delivery partners). For legal compliance (if required by law). No selling of user data to third parties.",
              ),
              TextSection(
                title: "Data Security Measures",
                content:
                    "Encryption of payment details. Secure storage of user data. Protection against unauthorized access.",
              ),
              TextSection(
                title: "Cookies & Tracking Policy",
                content:
                    "Explanation of how cookies are used for site functionality. How users can disable cookies.",
              ),
              TextSection(
                title: "Contact Information",
                content:
                    "Customer support contact for privacy-related inquiries.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
