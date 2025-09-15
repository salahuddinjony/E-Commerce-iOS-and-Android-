import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';

class OwnerNavController extends GetxController {
  final RxInt selectedIndex=0.obs;

  void setIndex(int index) {
    selectedIndex.value = index;
  }
  
   List<(
    {
      String route,
      Widget selectedIcon,
      Widget unselectedIcon,
      String label
    }
  )> get navItems => [
    (
      route: RoutePath.homeScreen,
      selectedIcon: Assets.images.ownerHomeSelected.image(),
      unselectedIcon: Assets.images.ownerHomeSelected.image(color: Colors.grey),
      label: AppStrings.home,
    ),
    (
      route: RoutePath.ordersScreen,
      selectedIcon: Assets.images.simplification.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.simplification.image(),
      label: "Orders",
    ),
    (
      route: RoutePath.productScreen,
      selectedIcon: Assets.images.add.image(),
      unselectedIcon: Assets.images.unselected.image(),
      label: "",
    ),
    (
      route: RoutePath.inboxScreen,
      selectedIcon: Assets.images.message.image(color: AppColors.brightCyan, height: 35.h),
      unselectedIcon: Assets.images.message.image(),
      label: AppStrings.chat,
    ),
    (
      route: RoutePath.profileScreen,
      selectedIcon: Assets.images.profile.image(color: AppColors.brightCyan),
      unselectedIcon: Assets.images.profile.image(),
      label: AppStrings.profile,
    ),
  ];
@override
void onInit() {
  super.onInit();

}

@override
void onClose() {
  super.onClose();

}

} 