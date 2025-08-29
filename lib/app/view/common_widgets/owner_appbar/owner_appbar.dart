import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/common_screen/notification/controller/notification_controller.dart';

class OwnerAppbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback notificationOnTap;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final NotificationController? controller;

  OwnerAppbar({
    super.key,
    required this.scaffoldKey,
    required this.notificationOnTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: AppColors.white,
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
              child: Stack(children: [
                Assets.images.notification.image(height: 40.h, width: 40.w),
                Obx(() => (controller!.notificationList.isNotEmpty)
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            // color: AppColors.brightCyan,
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: CustomText(
                            text: controller!.notificationList.length
                                        .toString()
                                        .length >
                                    2
                                ? '9+'
                                : controller!.notificationList.length
                                    .toString(),
                            font: CustomFont.inter,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      )
                    : SizedBox.shrink()),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150.h);
}
