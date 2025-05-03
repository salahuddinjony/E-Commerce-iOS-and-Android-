
import 'package:get/get.dart';
import 'package:local/app/global/controller/Onboarding_Controller.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import 'package:local/app/view/screens/splash/controller/splash_controller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => OnboardingController(), fenix: true);


  }
}