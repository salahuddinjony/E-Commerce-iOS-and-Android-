import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';

import '../../../../core/route_path.dart';
import '../../../../core/routes.dart';
import '../../../../global/helper/toast_message/toast_message.dart';
import '../../../../services/api_check.dart';
import '../../../../services/api_client.dart';
import '../../../../services/app_url.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController(text: "fahad123@gmail.com");
  final passWordController = TextEditingController(text: "12345678");
  final confirmPasswordController = TextEditingController();

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
        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(response.body["data"]['accessToken']);
        print("Decoded Token:========================== $decodedToken");
        String role = decodedToken['role'];

        print('Role:============================ $role');
        if (role == 'vendor') {
          AppRouter.route.goNamed(RoutePath.homeScreen);
        } else if (role == 'client') {
          AppRouter.route.goNamed(RoutePath.userHomeScreen);
        }

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
      toastMessage(message: AppStrings.someThing);
      debugPrint("SignIn Error: $e");
    } finally {
      isSignInLoading.value = false;
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Forget In Method✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isForgetLoading = false.obs;

  Future<void> forgetMethod() async {
    isForgetLoading.value = true;

    try {
      final body = {
        "email": emailController.text.trim(),
      };

      final response = await ApiClient.postData(
        ApiUrl.forgetPassword,
        jsonEncode(body),
      );

      if (response.statusCode == 200) {
        AppRouter.route.pushNamed(
          RoutePath.otpScreen,
          extra: {
            "isForget": false,
            "email": emailController.text,
          },
        );

        toastMessage(message: response.body["message"]);
      } else if (response.statusCode == 400) {
        toastMessage(message: response.body["error"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      toastMessage(message: AppStrings.someThing);
      debugPrint("SignIn Error: $e");
    } finally {
      isSignInLoading.value = false;
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Forget Otp ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  String resetCode = "";
  RxBool isForgetOtp = false.obs;
  final pinCodeController = TextEditingController();

  Future<void> forgetOtp() async {
    if (resetCode.isEmpty) {
      toastMessage(message: "Please enter the activation code.");
      return;
    }

    isForgetOtp.value = true;
    refresh();

    Map<String, String> body = {
      "email": emailController.text.trim(),
      "otp": resetCode
    };
    var response = await ApiClient.postData(ApiUrl.forgetOtp, jsonEncode(body));
    isForgetOtp.value = false;
    refresh();

    if (response.statusCode == 200) {
      AppRouter.route.goNamed(RoutePath.resetPasswordScreen);
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["error"]);
    } else {
      ApiChecker.checkApi(response);
      debugPrint("Error: ${response.body["message"]}");
    }
    isForgetOtp.value = false;
    refresh();
  }

  //>>>>>>>>>>>>>>>>>>✅✅Reset Password✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  RxBool isResetLoading = false.obs;

  Future<void> resetPassword() async {
    isResetLoading.value = true;
    refresh();
    Map<String, String> body = {
      "email": emailController.text.trim(),
      "newPassword": passWordController.text.trim()
    };
    var response = await ApiClient.postData(
      ApiUrl.resetPassword,
      jsonEncode(body),
    );
    if (response.statusCode == 200) {
      AppRouter.route.goNamed(
        RoutePath.signInScreen,
      );
      toastMessage(
        message: response.body["message"],
      );
    } else {
      ApiChecker.checkApi(response);
    }
    isResetLoading.value = false;
    refresh();
  }
}
