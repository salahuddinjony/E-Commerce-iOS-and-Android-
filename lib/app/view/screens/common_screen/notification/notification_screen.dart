import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/common_screen/notification/controller/notification_controller.dart';

import '../../../../utils/custom_assets/assets.gen.dart';
import '../../../../utils/enums/status.dart';
import '../../../common_widgets/custom_loader/custom_loader.dart';
import '../../../common_widgets/custom_text/custom_text.dart';
import '../../../common_widgets/genarel_screen/genarel_screen.dart';
import '../../../common_widgets/no_internet/no_internet.dart';

class NotificationScreen extends StatelessWidget {
   NotificationScreen({super.key});

final NotificationController controller = Get.find<NotificationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          appBarContent: "Notification",
          iconData: Icons.arrow_back,
        ),
        body: Obx(() {
          switch (controller.rxRequestStatus.value) {
            case Status.loading:
              return const CustomLoader(); // Show loading indicator
            case Status.internetError:
              return NoInternetScreen(onTap: () {
                controller.refreshNotificationsList();
              });
            case Status.error:
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.h),
                    GeneralErrorScreen(
                      onTap: () {
                        controller.refreshNotificationsList();
                      },
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {
                        controller.refreshNotificationsList();
                      },
                      child: const Text("Retry"),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              );
            case Status.completed:
              return controller.notificationList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: controller.notificationList.length,
                      itemBuilder: (context, index) {
                        var data = controller.notificationList[index];
                        return _buildNotificationItem(context, data);
                      },
                    );
          }
        }),
        floatingActionButton: Obx(() => controller.notificationList.isNotEmpty
            ? FloatingActionButton(
                onPressed: () => _showClearAllDialog(context),
                backgroundColor: AppColors.brightCyan,
                child: const Icon(Icons.clear_all, color: Colors.white),
              )
            : const SizedBox.shrink()),
      );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100.h), // Add top padding
              Assets.images.notification.image(
                width: 80.w,
                height: 80.h,
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: "No notifications",
                font: CustomFont.inter,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.darkNaturalGray,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: "You're all caught up!",
                font: CustomFont.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.naturalGray,
              ),

              SizedBox(height: 100.h), // Add bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, var data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Assets.images.notification.image(),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: data.content?.title ?? "",
                  font: CustomFont.inter,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkNaturalGray,
                  bottom: 6.h,
                ),
                CustomText(
                  text: data.content?.message ?? "",
                  font: CustomFont.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.naturalGray,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _showDismissDialog(context, data.id);
            },
            icon: const Icon(Icons.close, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showDismissDialog(BuildContext context, String? notificationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Dismiss Notification"),
          content: const Text("Are you sure you want to dismiss this notification?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (notificationId != null) {
                  controller.dismissNotificationById(notificationId);
                }
              },
              child: const Text("Dismiss"),
            ),
          ],
        );
      },
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clear All Notifications"),
          content: const Text("Are you sure you want to clear all notifications?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.clearAllNotificationsForConsumer();
              },
              child: const Text("Clear All"),
            ),
          ],
        );
      },
    );
  }
}
