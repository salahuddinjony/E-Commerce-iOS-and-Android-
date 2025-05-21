import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/route_path.dart';
import '../../../../common_widgets/custom_log_out_button/custom_log_out_button.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/sunset_background.png"),
              // Your background image path
              fit: BoxFit.cover,
            ),
          ),
        ),
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
                      // Navigate to Order History screen
                    },
                  ),
                  _buildListItem(
                    icon: Icons.support_agent,
                    label: "Support",
                    onTap: () {
                      // Navigate to Support screen
                    },
                  ),
                  _buildListItem(
                    icon: Icons.help_outline,
                    label: "FAQ",
                    onTap: () {
                      // Navigate to FAQ screen
                    },
                  ),
                  _buildListItem(
                    icon: Icons.lock_outline,
                    label: "Change password",
                    onTap: () {
                      // Navigate to Change Password screen
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
