import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';

import '../../../../../core/route_path.dart';
import '../../../../common_widgets/custom_button/custom_button.dart';

class UTeeHubAccount extends StatelessWidget {
  const UTeeHubAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appBarContent: "Account and profile settings",
        iconData: Icons.arrow_back,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'How to change your',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const BulletList(items: [
            'Location',
            'User Name',
            'E-mail Address',
          ]),
          const SizedBox(height: 16),
          const Text(
            'How to Change Your Location in U TEE HUB',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your location is set when you register your account and is determined based on your current region. '
            'If you need to update your location for accurate deliveries, business operations, or personal preferences, '
            'follow these steps:',
          ),
          const SizedBox(height: 8),
          const BulletList(items: [
            'Go to Your Profile Settings',
            'Select Edit Location',
            'Verify Your Change',
            'Save and Update',
          ]),
          const SizedBox(height: 16),
          const Text(
            'How to Change Your Username in U TEE HUB',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your username is set during registration and is used to identify your account on U TEE HUB. '
            'If you need to update it, follow these steps:',
          ),
          const SizedBox(height: 8),
          const BulletList(items: [
            'Go to Your Profile Settings',
            'Select “Edit Username”',
            'Enter a New Username',
            'Save and Update',
          ]),
          const SizedBox(height: 16),
          const Text(
            'How to Change Your E-mail in U TEE HUB',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your email is linked to your U TEE HUB account for login, notifications, and order updates. '
            'If you need to update it, follow these steps:',
          ),
          const SizedBox(height: 8),
          const BulletList(items: [
            'Go to Your Profile Settings',
            'Select “Edit Email',
            'Enter a New Email',
            'Save and Update',

          ]),
          SizedBox(height: 15.h,),
          CustomButton(
            onTap: () {
              context.pushNamed(RoutePath.helpCenterScreen);
            },
            title: "Contact Us",
          ),
          SizedBox(height: 15.h,),

        ],
      ),
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;

  const BulletList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
