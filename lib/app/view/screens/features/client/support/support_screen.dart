import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/route_path.dart';

import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/bottom_navigation_bar/client_nav_bar/nav_bar.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar:  CustomNavBar(currentIndex: 3),
      appBar: const CustomAppBar(
        appBarContent: AppStrings.howCanWeHelp,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  CategoryCard(
                    icon: Icons.person_outline,
                    title: 'Your U Tee Hub Account',
                    onTap: () {
                      context.pushNamed(RoutePath.uTeeHubAccount);
                    },
                  ),
                  CategoryCard(
                    onTap: () {
                      context.pushNamed(RoutePath.paymentMethodsScreen);
                    },
                    icon: Icons.payment_outlined,
                    title: 'Payment Methods',
                  ),
                  CategoryCard(
                    onTap: () {
                      context.pushNamed(RoutePath.accountSecurityScreen);
                    },
                    icon: Icons.security_outlined,
                    title: 'Account Security',
                    isBold: true,
                  ),
                  CategoryCard(
                    onTap: () {
                      context.pushNamed(RoutePath.orderManegmentScreen);
                    },
                    icon: Icons.assignment_turned_in_outlined,
                    title: 'Order Management',
                  ),
                ],
              ),
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

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isBold;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    this.isBold = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.teal),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
