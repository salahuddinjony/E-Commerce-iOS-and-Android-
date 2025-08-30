import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/core/routes.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';

class NavBarController extends GetxController {
  final RxInt currentIndex = 0.obs;

  // NavBarController({int initialIndex = 0}) {
  //   currentIndex.value = initialIndex;
  // }
  final List<
      ({
        String route,
        Widget selectedIcon,
        Widget unselectedIcon,
        String label
      })> navItems = [
        //===============Home================
    (
      route: RoutePath.userHomeScreen, 
      selectedIcon: Assets.images.homeSelected.image(),
      unselectedIcon: Assets.images.homeSelected.image(color: Colors.black),
      label: AppStrings.home,
    ),

    //===============Order================
    (
      route: RoutePath.userOrderScreen,
      selectedIcon:
          Assets.images.orderUnselected.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.orderUnselected.image(),
      label: AppStrings.order,
    ),
    //===============Inbox================
    (
      route: RoutePath.inboxScreen,
      selectedIcon:
          Assets.images.chatUnselected.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.chatUnselected.image(),
      label: AppStrings.chat,
    ),

    //===============Support================
    (
      route: RoutePath.supportScreen,
      selectedIcon:
          Assets.images.supportUnselected.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.supportUnselected.image(),
      label: AppStrings.support,
    ),
  ];
  void setIndex(int index) {
    currentIndex.value = index;
  }

  void onTap(int index, String route) {
    if (currentIndex.value != index) {
      AppRouter.route.goNamed(route);
      currentIndex.value = index;
    }
  }
}
