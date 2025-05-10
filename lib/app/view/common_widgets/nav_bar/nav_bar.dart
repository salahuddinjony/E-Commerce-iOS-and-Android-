import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/core/routes.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;

  const CustomNavBar({required this.currentIndex, super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  late int bottomNavIndex;

  final List<
      ({
        String route,
        Widget selectedIcon,
        Widget unselectedIcon,
        String label
      })> _navItems = [
    //===============Home================
    (
      route: RoutePath.userHomeScreen,
      selectedIcon: Assets.images.homeSelected.image(),
      unselectedIcon: Assets.images.homeSelected.image(color: Colors.black),
      label: AppStrings.home,
    ),

    //===============Inbox================
    (
      route: RoutePath.userOrderScreen,
      selectedIcon:
          Assets.images.orderUnselected.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.orderUnselected.image(),
      label: AppStrings.order,
    ),
    //===============My Shop================
    (
      route: RoutePath.inboxScreen,
      selectedIcon:
          Assets.images.chatUnselected.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.chatUnselected.image(),
      label: AppStrings.chat,
    ),
    (
      route: RoutePath.supportScreen,
      selectedIcon:
          Assets.images.supportUnselected.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.supportUnselected.image(),
      label: AppStrings.support,
    ),
  ];

  @override
  void initState() {
    bottomNavIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.white),
      height: 88.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 13.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          _navItems.length,
          (index) => InkWell(
            onTap: () => _onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                bottomNavIndex == index
                    ? _navItems[index].selectedIcon
                    : _navItems[index].unselectedIcon,
                SizedBox(height: 4.h),
                CustomText(
                  text: _navItems[index].label,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: bottomNavIndex == index
                      ? AppColors.brightCyan
                      : AppColors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    if (widget.currentIndex != index) {
      AppRouter.route.goNamed(_navItems[index].route);
    }
  }
}
