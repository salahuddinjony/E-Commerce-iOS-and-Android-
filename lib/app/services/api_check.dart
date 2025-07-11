import 'package:get/get.dart';


import '../data/local/shared_prefs.dart';
import '../global/helper/toast_message/toast_message.dart';
import '../utils/app_constants/app_constants.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) async {
    if (response.statusCode == 401) {
      toastMessage(
        message: response.body["message"],
      );
      await SharePrefsHelper.remove(AppConstants.bearerToken);

      await SharePrefsHelper.setBool(AppConstants.rememberMe, false);
      // AppRouter.route.goNamed(
      //   RoutePath.signInScreen,
      // );
    } else if (response.statusCode == 403) {
      toastMessage(
        message: response.body["message"],
      );
    } else {
      showCustomSnackBar(response.statusText, getXSnackBar: getXSnackBar);
    }
  }
}
