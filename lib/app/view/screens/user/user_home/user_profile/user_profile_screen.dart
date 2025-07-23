import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';

import '../../../../../core/route_path.dart';
import '../../../../common_widgets/custom_log_out_button/custom_log_out_button.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.profile,
        iconData: Icons.arrow_back,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          children: [
            // Profile picture
            CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.pink.shade100,
              child: CircleAvatar(
                radius: 47.r,
                backgroundImage: const NetworkImage(
                    "https://i.pravatar.cc/150?img=5"), // Sample profile picture
              ),
            ),
            SizedBox(height: 15.h),
            // Name
            const Text(
              "Gwen Stacy",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 5.h),
            // Username
            const Text(
              "@GwenStacy31",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 25.h),
            Expanded(
              child: ListView(
                children: [
                  _buildListItem(
                    icon: Icons.person,
                    label: "Personal Information",
                    onTap: () {
                      context.pushNamed(RoutePath.personalInfoScreen);
                    },
                  ),
                  _buildListItem(
                    icon: Icons.payment,
                    label: "Payment Methods",
                    onTap: () {
                      context.pushNamed(RoutePath.paymentMethodsScreen);
                    },
                  ),
                  _buildListItem(
                    icon: Icons.history,
                    label: "Order History",
                    onTap: () {
                      context.pushNamed(RoutePath.orderHistoryScreen);
                    },
                  ),
                  _buildListItem(
                    icon: Icons.support_agent,
                    label: "Support",
                    onTap: () {
                      context.pushNamed(RoutePath.helpCenterScreen);
                    },
                  ),
                  _buildListItem(
                    icon: Icons.help_outline,
                    label: "FAQ",
                    onTap: () {
                      context.pushNamed(RoutePath.faqScreen);
                    },
                  ),
                  _buildListItem(
                    icon: Icons.lock_outline,
                    label: "Change password",
                    onTap: () {
                      context.pushNamed(RoutePath.changePasswordScreen);
                    },
                  ),
                ],
              ),
            ),
            CustomLogoutButton(
              onTap: () {
                context.goNamed(RoutePath.signInScreen);
              },
            ),
            // Logout button
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 0),
    );
  }
}
