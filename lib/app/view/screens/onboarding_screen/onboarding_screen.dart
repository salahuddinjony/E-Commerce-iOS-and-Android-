import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/global/controller/Onboarding_Controller.dart';
import 'onboarding_model.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final OnboardingController controller = Get.find<OnboardingController>();

  final List<OnboardingModel> pages = [
    OnboardingModel(
      title: "Welcome",
      description: "Discover new experiences with our app.",
      image: "assets/images/onboard1.png",
    ),
    OnboardingModel(
      title: "Order Easily",
      description: "Find and book services in just a few clicks.",
      image: "assets/images/onboard2.png",
    ),
    OnboardingModel(
      title: "Stay Updated",
      description: "Receive notifications and track updates in real time.",
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
                      SizedBox(height: 40),
                      Text(page.title,
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text(page.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              final isLast = controller.currentPage.value == pages.length - 1;
              return ElevatedButton(
                onPressed: () {
                  if (isLast) {
                    // Navigate to next screen
                    Get.offAllNamed('/home');
                  } else {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.ease);
                  }
                },
                child: Text(isLast ? "Get Started" : "Next"),
              );
            }),
          ),
        ],
      ),
    );
  }
}
