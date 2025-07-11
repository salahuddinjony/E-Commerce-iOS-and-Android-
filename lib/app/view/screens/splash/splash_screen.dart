
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';

import 'controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});
final SplashController splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
  return  Scaffold(
    backgroundColor: AppColors.white,
    body: Center(child: Assets.images.logo.image()),
  );
  }
}












