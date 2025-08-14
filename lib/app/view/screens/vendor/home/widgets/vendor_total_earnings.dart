import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/view/screens/vendor/home/controller/home_page_controller.dart';

import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../common_widgets/custom_button/custom_button.dart';
import '../../../../common_widgets/custom_text/custom_text.dart';

class VendorTotalEarnings extends StatelessWidget {
  final HomePageController controller;
  const VendorTotalEarnings({
    super.key,
    required this.controller,
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
          Obx(
            () => CustomText(
              font: CustomFont.poppins,
              color: AppColors.white,
              text: controller.amount.toString(),
              fontWeight: FontWeight.w600,
              fontSize: 30.sp,
              bottom: 10.h,
            ),
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
      barrierColor: Colors.black.withOpacity(0.5), // semi-transparent background
      transitionDuration: const Duration(milliseconds: 300),
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
                          onPressed: () => context.pop(),
                          icon: Icon(Icons.cancel, size: 35),
                        ),
                      ],
                    ),
                    TextField(
                      controller: controller.widrawAmount,
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
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                      ),
                      style: TextStyle(
                        color: AppColors.darkNaturalGray,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomButton(title: "Get Withdraw", onTap: () {}),
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
