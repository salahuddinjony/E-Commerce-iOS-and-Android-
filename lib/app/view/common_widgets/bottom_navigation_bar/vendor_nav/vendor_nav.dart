import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/core/routes.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/bottom_navigation_bar/vendor_nav/controller/verndor_nav_controller.dart';



class OwnerNav extends StatelessWidget {
  final int currentIndex;

   OwnerNav({required this.currentIndex, super.key});


  @override
  Widget build(BuildContext context) {

    final OwnerNavController controller = Get.find<OwnerNavController>();
       

    // // ensure initial index is in sync if widget was recreated with a different initial value
    // if (controller.selectedIndex.value != currentIndex) {
    //   controller.setIndex(currentIndex);
    // }

    return Container(
      decoration: const BoxDecoration(color: AppColors.white),
      height: 112.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 13.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          controller.navItems.length,
          (index) => Obx(
            () {
              final bottomNavIndex = controller.selectedIndex.value;
              return InkWell(
                onTap: () {
                  if (bottomNavIndex != index) {
                    controller.setIndex(index);
                    AppRouter.route.goNamed(controller.navItems[index].route);
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: index == 2 ? 74.h : 50.h,
                      child: bottomNavIndex == index
                          ? controller.navItems[index].selectedIcon
                          : controller.navItems[index].unselectedIcon,
                    ),
                    SizedBox(height: 4.h),
                    if (controller.navItems[index].label.isNotEmpty)
                      CustomText(
                        text: controller.navItems[index].label,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: bottomNavIndex == index ? AppColors.brightCyan : AppColors.black,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
