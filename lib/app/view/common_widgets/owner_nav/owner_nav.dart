import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/core/routes.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class OwnerNav extends StatefulWidget {
  final int currentIndex;

  const OwnerNav({required this.currentIndex, super.key});

  @override
  State<OwnerNav> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<OwnerNav> {
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
      route: RoutePath.homeScreen,
      selectedIcon: Assets.images.ownerHomeSelected.image(),
      unselectedIcon:
          Assets.images.ownerHomeSelected.image(color: Colors.black),
      label: AppStrings.home,
    ),

    //===============Inbox================
    (
      route: RoutePath.ordersScreen,
      selectedIcon:
          Assets.images.simplification.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.simplification.image(),
      label: "Orders",
    ),
    //===============My Shop================
    (
      route: RoutePath.addProductScreen,
      selectedIcon: Assets.images.apple.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.apple.image(),
      label: "",
    ),

    //=============== ================
    (
      route: RoutePath.orderRequestScreen,
      selectedIcon:
          Assets.images.checkOut.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.checkOut.image(),
      label: "Checkout",
    ),
    (
      route: RoutePath.profileScreen,
      selectedIcon: Assets.images.profile.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.profile.image(),
      label: AppStrings.profile,
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
