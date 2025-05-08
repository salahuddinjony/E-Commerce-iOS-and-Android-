import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/global/controller/Onboarding_Controller.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'onboarding_model.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final OnboardingController controller = Get.find<OnboardingController>();

  final List<OnboardingModel> pages = [
    OnboardingModel(
      title: AppStrings.gpsTracking,
      description: AppStrings.trackYourLovedOnes,
      image: "assets/images/onboard1.png",
    ),
    OnboardingModel(
      title: AppStrings.quickDelivery,
      description: AppStrings.needSomeTingDelivered,
      image: "assets/images/onboard2.png",
    ),
    OnboardingModel(
      title: AppStrings.grow,
      description: AppStrings.joinTheLargestLocal,
      image: "assets/images/onboard3.png",
    ),
  ];

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: controller.updatePage,
              itemBuilder: (_, index) {
                final page = pages[index];
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(page.image, height: 300),
                      const SizedBox(height: 40),

                      CustomText(
                        text: page.title,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkNaturalGray,
                      ),
                      // Text(page.title,
                      //     style: const TextStyle(
                      //         fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Text(page.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.all(5),
                  width: controller.currentPage.value == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.currentPage.value == index
                        ? Colors.blue
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            );
          }),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              final isLast = controller.currentPage.value == pages.length - 1;
              return CustomButton(
                onTap: () {
                  if (isLast) {
                    context.pushNamed(RoutePath.chooseAuthScreen,);
                  } else {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease);
                  }
                },
                title: AppStrings.continues,
                fillColor: AppColors.brightCyan,
              );
            }),
          ),
        ],
      ),
    );
  }
}
