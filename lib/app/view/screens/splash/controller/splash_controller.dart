

import 'package:get/get.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/core/routes.dart';


class SplashController extends GetxController{



  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 2), (){
      AppRouter.route.goNamed(RoutePath.homeScreen);
    });
    super.onReady();
  }

}