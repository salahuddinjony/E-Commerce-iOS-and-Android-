import 'package:get/get.dart';
import 'package:local/app/global/controller/Onboarding_Controller.dart';
import 'package:local/app/global/controller/genarel_controller.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import 'package:local/app/view/screens/splash/controller/splash_controller.dart';
import 'package:local/app/view/screens/vendor/home/controller/home_page_controller.dart';
import 'package:local/app/view/screens/vendor/orders/controller/order_controller.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/controller/category_controller.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/map/controller/map_picker_controller.dart';
import '../view/screens/common_screen/controller/info_controller.dart';
import '../view/screens/common_screen/notification/controller/notification_controller.dart';
import '../view/screens/vendor/products_and_category/product/controller/vendor_product_controller.dart';
import '../view/screens/vendor/profile/personal_info/controller/profile_controller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => OnboardingController(), fenix: true);
    Get.lazyPut(() => InfoController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => GeneralController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(()=> VendorProductController(), fenix: true);
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(()=> HomePageController(), fenix: true);
    Get.lazyPut(()=> OrdersController(), fenix: true);
    // Get.lazyPut(() => MapPickerController(), fenix: true);
  }
}