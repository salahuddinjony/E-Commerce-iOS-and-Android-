import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart' show Assets;

class ProfileCardRow extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  const ProfileCardRow({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppColors.profileCardColor,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: icon,
                ),
                const SizedBox(width: 15), // 15.w with screenutil
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const Spacer(),
               Assets.icons.arrow.svg()
              ],
            ),
            SizedBox(height: 12.h,)
          ],
        ),
      ),
    );
  }
}
