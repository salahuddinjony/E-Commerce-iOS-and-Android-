import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/view/screens/common_screen/notification/controller/notification_controller.dart';
import 'package:local/app/view/screens/vendor/home/controller/home_page_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../common_widgets/custom_button/custom_button.dart';
import '../../../../common_widgets/custom_text/custom_text.dart';

class VendorTotalEarnings extends StatelessWidget {
  final HomePageController controller;
 final NotificationController notificationController;
  const VendorTotalEarnings({
    super.key,
    required this.controller, required this.notificationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 87.w, vertical: 30.h),
      decoration: BoxDecoration(
          color: AppColors.brightCyan,
          borderRadius: BorderRadius.all(Radius.circular(21.r))),
      child: Column(
        children: [
          CustomText(
            font: CustomFont.poppins,
            color: AppColors.white,
            text: 'Total Earnings',
            fontWeight: FontWeight.w600,
            fontSize: 24.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Refresh icon
              Container(
                margin: EdgeInsets.only(right: 12.w),
                child: IconButton(
                  onPressed: () async {
                    await notificationController.loadUserIdAndNotifications();
                    controller.balanceFetch.value = false; // Show shimmer immediately
                    await controller.fetchWalletData();
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: AppColors.white.withValues(alpha: 0.8),
                    size: 18.sp,
                  ),
                  padding: EdgeInsets.all(4.w),
                  constraints: BoxConstraints(
                    minWidth: 32.w,
                    minHeight: 32.h,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
              // Amount text - properly centered
              Expanded(
                child: Center(
                  child: Obx(() => 
                    controller.balanceFetch.value 
                    ? CustomText(
                        font: CustomFont.poppins,
                        color: AppColors.white,
                        text: "\$${controller.amount.toString()}",
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        textAlign: TextAlign.center,
                      )
                    : Shimmer.fromColors(
                        baseColor: AppColors.white.withValues(alpha: .6),
                        highlightColor: AppColors.white,
                        child: Container(
                          width: 80.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      )
                  ),
                ),
              ),
              // Invisible spacer to balance the refresh icon
              SizedBox(width: 44.w),
            ],
          ),
          // CustomButton(
          //   borderColor: AppColors.white,
          //   onTap: () {
          //     showDialog(
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //           backgroundColor: Colors.white,
          //           title: Row(
          //             children: [
          //               Text("Enter Amount"),
          //               Spacer(),
          //               IconButton(
          //                   onPressed: context.pop,
          //                   icon: Icon(Icons.cancel, size: 35)),
          //             ],
          //           ),
          //           content: TextField(
          //             controller: controller.widrawAmount,
          //             decoration: InputDecoration(
          //               hintText: "Enter Amount",
          //               hintStyle: TextStyle(
          //                 color: Colors.grey[600],
          //                 fontSize: 14.sp,
          //               ),
          //               filled: true,
          //               fillColor: AppColors.white,
          //               border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(8.r),
          //                 borderSide: BorderSide(color: Colors.grey.shade300),
          //               ),
          //               contentPadding: EdgeInsets.symmetric(
          //                   horizontal: 12.w, vertical: 8.h),
          //             ),
          //             style: TextStyle(
          //               color: AppColors.darkNaturalGray,
          //               fontSize: 14.sp,
          //             ),
          //             onChanged: (value) {},
          //           ),
          //           actions: [
          //             Center(
          //               child:
          //                   CustomButton(title: " Get Widthraw", onTap: () {}),
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //   },
          //   title: "Withdraw",
          // )
          CustomButton(
            borderColor: AppColors.white,
            onTap: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: "Withdraw",
                barrierColor: Colors.black.withValues(alpha: .5),
                transitionDuration: const Duration(milliseconds: 100),
                pageBuilder: (context, anim1, anim2) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 300.w,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const Text("Enter Amount"),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      controller.message.value =
                                          ''; // Clear message when canceling
                                      controller.withdrawAmount
                                          .clear(); // Clear input field
                                      context.pop();
                                    },
                                    icon: const Icon(Icons.cancel, size: 35),
                                  ),
                                ],
                              ),
                              TextField(
                                controller: controller.withdrawAmount,
                                decoration: InputDecoration(
                                  hintText: "Enter Amount",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14.sp,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                ),
                                style: TextStyle(
                                  color: AppColors.darkNaturalGray,
                                  fontSize: 14.sp,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Restrict to digits
                              ),
                              SizedBox(height: 8.h),
                              Obx(() => controller.message.value.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Text(
                                        controller.message.value,
                                        style: TextStyle(
                                          color: controller.message.value.contains("Error") ||
                                                  controller.message.value.contains("error") ||
                                                  controller.message.value.contains("Insufficient") ||
                                                  controller.message.value.contains("valid")
                                              ? Colors.red
                                              : Colors.green,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                              SizedBox(height: 8.h),
                              CustomButton(
                                title: "Get Withdraw",
                                onTap: () {
                                  controller.withdraw();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            title: "Withdraw",
          )
        ],
      ),
    );
  }
}
