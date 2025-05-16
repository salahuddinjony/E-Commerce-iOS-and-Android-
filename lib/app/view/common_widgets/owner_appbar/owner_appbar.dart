import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';

class OwnerAppbar extends StatelessWidget implements PreferredSizeWidget {
  const OwnerAppbar({
    super.key,
    required this.scaffoldKey,
    required this.notificationOnTap,
  });

  final VoidCallback notificationOnTap;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 150.h,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 26.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Assets.images.logo.image(height: 113.h, width: 100.w),
            Assets.images.uTee.image(),
            GestureDetector(
                onTap: notificationOnTap,
                child: Assets.images.notification
                    .image(height: 40.h, width: 40.w)),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150.h);
}
