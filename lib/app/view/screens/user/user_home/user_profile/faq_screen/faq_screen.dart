
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/view/screens/user/user_home/user_profile/faq_screen/controller/faq_controller.dart';

import '../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../utils/app_strings/app_strings.dart';
import '../../../../../common_widgets/custom_appbar/custom_appbar.dart';
import '../../../../../common_widgets/custom_text/custom_text.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});
  final FaqController infoController = Get.find<FaqController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,

      ///============================ Header ===============================
      appBar: CustomAppBar(
        appBarBgColor: AppColors.white,
        appBarContent: AppStrings.faq,
        iconData: Icons.arrow_back,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(

        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.brightCyan,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  /// **Question**
                  ListTile(
                    title: const CustomText(
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      text: "No question available",
                      color: Colors.black,
                      fontSize: 14,
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
                      secondChild: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: CustomText(
                          maxLines: 50,
                          textAlign: TextAlign.start,
                          text: "No answer available",
                          color: Colors.black,
                          fontSize: 14,
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
        ),
      ),
    );
  }
}
