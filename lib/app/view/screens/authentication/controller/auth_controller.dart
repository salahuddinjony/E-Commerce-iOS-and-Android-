import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/route_path.dart';
import '../../../../core/routes.dart';
import '../../../../data/local/shared_prefs.dart';
import '../../../../global/helper/toast_message/toast_message.dart';
import '../../../../services/api_check.dart';
import '../../../../services/api_client.dart';
import '../../../../services/app_url.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController(text: "fahad123@gmail.com");
  final passWordController = TextEditingController(text: "12345678");

  //>>>>>>>>>>>>>>>>>>✅✅SIgn In Method✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isSignInLoading = false.obs;

  Future<void> signIn() async {
    isSignInLoading.value = true;

    try {
      final body = {
        "email": emailController.text.trim(),
        "password": passWordController.text.trim(),
      };

      final response = await ApiClient.postData(
        ApiUrl.login,
        jsonEncode(body),
      );

      if (response.statusCode == 200) {
        AppRouter.route.goNamed(RoutePath.userHomeScreen);
        // Save access token
        // SharePrefsHelper.setString(
        //   AppConstants.bearerToken,
        //   response.body['data']["accessToken"],
        // );

        toastMessage(message: response.body["message"]);
      } else if (response.statusCode == 400) {
        toastMessage(message: response.body["error"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      toastMessage(message: "Something went wrong. Please try again.");
      debugPrint("SignIn Error: $e");
    } finally {
      isSignInLoading.value = false;
    }
  }





}
