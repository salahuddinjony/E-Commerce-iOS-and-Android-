import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/common_screen/controller/info_controller.dart';

import '../../../../utils/custom_assets/assets.gen.dart';
import '../../../../utils/enums/status.dart';
import '../../../common_widgets/custom_loader/custom_loader.dart';
import '../../../common_widgets/custom_text/custom_text.dart';
import '../../../common_widgets/genarel_screen/genarel_screen.dart';
import '../../../common_widgets/no_internet/no_internet.dart';

class NotificationScreen extends StatelessWidget {
   NotificationScreen({super.key});

final InfoController controller = Get.find<InfoController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: "Notification",
          iconData: Icons.arrow_back,
        ),
        body:
        Obx(() {
      switch (controller.rxRequestStatus.value) {
        case Status.loading:
          return const CustomLoader(); // Show loading indicator
        case Status.internetError:
          return NoInternetScreen(onTap: () {
            controller.getNotification();
          });
        case Status.error:
          return GeneralErrorScreen(
            onTap: () {
              controller.getNotification();

            },
          );
        case Status.completed:
          return
        ListView.builder(
            itemCount: controller.notificationList.length,
            itemBuilder: (context, index) {

              var data = controller.notificationList[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Assets.images.notification.image(),
                SizedBox(
                  width: 8.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: data.content?.title??"",
                      font: CustomFont.inter,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkNaturalGray,
                      bottom: 6.h,
                    ),
                    CustomText(
                      text: data.content?.message??"",
                      font: CustomFont.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.naturalGray,
                    ),
                  ],
                ),
              ],
            ),
          );
        });}
        }));
  }
}
