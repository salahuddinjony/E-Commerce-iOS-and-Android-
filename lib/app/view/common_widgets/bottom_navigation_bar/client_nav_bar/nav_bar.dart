import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'controller/nav_bar_controller.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;

  CustomNavBar({required this.currentIndex, super.key});

  final NavBarController controller = Get.find<NavBarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final idx = controller.currentIndex.value;
      return Container(
        decoration: const BoxDecoration(color: AppColors.white),
        height: 88.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 13.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            controller.navItems.length,
            (index) => InkWell(
              onTap: () => controller.onTap(index, controller.navItems[index].route),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  idx == index
                      ? controller.navItems[index].selectedIcon
                      : controller.navItems[index].unselectedIcon,
                  SizedBox(height: 4.h),
                  CustomText(
                    text: controller.navItems[index].label,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color:
                        idx == index ? AppColors.brightCyan : AppColors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
