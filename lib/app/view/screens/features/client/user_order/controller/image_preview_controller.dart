import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePreviewController extends GetxController {
  late PageController pageController;
  final RxInt currentIndex = 0.obs;

  void initializeController(int initialIndex) {
    currentIndex.value = initialIndex;
    pageController = PageController(initialPage: initialIndex);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void animateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}