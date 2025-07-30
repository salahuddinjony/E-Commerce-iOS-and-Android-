
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/common_screen/controller/info_controller.dart';

import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_strings/app_strings.dart';
import '../../../../utils/enums/status.dart';
import '../../../common_widgets/custom_appbar/custom_appbar.dart';
import '../../../common_widgets/custom_loader/custom_loader.dart';
import '../../../common_widgets/custom_text/custom_text.dart';
import '../../../common_widgets/genarel_screen/genarel_screen.dart';
import '../../../common_widgets/no_internet/no_internet.dart';


class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});
  final InfoController infoController = Get.find<InfoController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,

      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.white,
        appBarContent: AppStrings.faq,
        iconData: Icons.arrow_back,
      ),
      body:
      Obx(() {
        switch (infoController.rxRequestStatus.value) {
          case Status.loading:
            return const CustomLoader(); // Show loading indicator
          case Status.internetError:
            return NoInternetScreen(onTap: () {
              infoController.getFaq();
            });
          case Status.error:
            return GeneralErrorScreen(
              onTap: () {
                infoController.getFaq();

              },
            );
          case Status.completed:
            return
              ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: infoController.faqList.length,
              itemBuilder: (context, index) {
                final data = infoController.faqList[index];
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      /// **Question**
                      ListTile(
                        title: CustomText(
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          text: data.question??"",
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        trailing: Obx(() {
                          final isSelected =
                              infoController.selectedIndex.value == index;
                          return Icon(
                            isSelected
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.green,
                          );
                        }),
                        onTap: () => infoController.toggleItem(index),
                      ),

                      /// **Answer**
                      Obx(() {
                        final isSelected =
                            infoController.selectedIndex.value == index;
                        return AnimatedCrossFade(
                          firstChild: Container(),
                          secondChild: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: CustomText(
                              maxLines: 50,
                              textAlign: TextAlign.start,
                              text: data.answer??"",
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          crossFadeState: isSelected
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        );
                      }),
                    ],
                  ),
                );
              },
            );
        }
      })
    );

  }
}
