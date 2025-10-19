import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';

import '../../../../../../core/route_path.dart';

class AccountSecurityScreen extends StatelessWidget {
  const AccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Account Security Features'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Account Security Features for U TEE HUB',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'To ensure user safety and protect personal data, U TEE HUB offers multiple security features. Below are the key security measures users can enable:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Secure Login & Authentication',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const _BulletPoint(
              text:
                  'Strong Password Protection – Users must create a strong password with a mix of letters, numbers, and symbols.',
            ),
            const _BulletPoint(
              text:
                  'Account Lockout System – Multiple failed login attempts will temporarily lock the account to prevent unauthorized access.',
            ),
            const _BulletPoint(
              text:
                  'Account Lockout System – Multiple failed login attempts will temporarily lock the account to prevent unauthorized access.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Account Recovery Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const _BulletPoint(
              text:
                  'Email & Phone Verification – Users can reset their password via a verified email or phone number.',
            ),
            const _BulletPoint(
              text:
                  'Backup Codes – Generate and save backup codes for account recovery in case of lost access.',
            ),
            const _BulletPoint(
              text:
                  'Secure Account Recovery Support – Contact customer support with identity verification for account recovery assistance.',
            ),
            SizedBox(
              height: 20.h,
            ),
           CustomButton(
              onTap: () {
                 context.pushNamed(RoutePath.helpCenterScreen);
              },
              title: "Contact Us",
            )
          ],
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
