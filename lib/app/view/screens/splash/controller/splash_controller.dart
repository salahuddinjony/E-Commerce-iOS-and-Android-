import 'package:get/get.dart';
import 'package:local/app/core/routes.dart';

import 'package:local/app/view/screens/authentication/controller/auth_controller.dart'; // assuming you have this

class SplashController extends GetxController {

  @override
  void onReady() {
    super.onReady();
    checkLogin();
  }

  void checkLogin() async {
    
    // Wait a bit to show splash
    await Future.delayed(const Duration(seconds: 1));

    // Decide the initial route
    final route = await AuthController.getInitialRoute();
    AppRouter.route.goNamed(route);
  }
}
