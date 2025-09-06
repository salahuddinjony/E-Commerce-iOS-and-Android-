import 'package:get/get.dart';
import 'package:local/app/global/controller/Onboarding_Controller.dart';
import 'package:local/app/global/controller/genarel_controller.dart';
import 'package:local/app/view/common_widgets/client_nav_bar/controller/nav_bar_controller.dart';
import 'package:local/app/view/common_widgets/vendor_nav/controller/verndor_nav_controller.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import 'package:local/app/view/screens/splash/controller/splash_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/controller/delivery_locations_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/controller/user_home_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/controller/shop_details_controller.dart';
import 'package:local/app/view/screens/features/vendor/home/controller/home_page_controller.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/category/controller/category_controller.dart';
import '../view/screens/common_screen/controller/info_controller.dart';
import '../view/screens/common_screen/notification/controller/notification_controller.dart';
import '../view/screens/features/vendor/products_and_category/product/controller/vendor_product_controller.dart';
import '../view/screens/features/vendor/profile/personal_info/controller/profile_controller.dart';

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
    Get.lazyPut(() => VendorProductController(), fenix: true);
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => HomePageController(), fenix: true);
    Get.lazyPut(() => OrdersController(), fenix: true);
    // Get.lazyPut(() => MapPickerController(), fenix: true);
    Get.lazyPut(() => NavBarController(), fenix: true);
    Get.lazyPut(() => OwnerNavController(), fenix: true);
    Get.lazyPut(() => UserHomeController(), fenix: true);
    Get.lazyPut(() => MixInDeliveryLocation(), fenix: true);
    Get.lazyPut(() => ShopDetailsController(), fenix: true);
  }
}