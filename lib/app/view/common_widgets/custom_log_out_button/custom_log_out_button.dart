import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class CustomLogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const CustomLogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: AppColors.brightCyan),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: AppColors.brightCyan),
            SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color:AppColors.brightCyan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
