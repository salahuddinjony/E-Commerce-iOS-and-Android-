import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/global/controllers/password_constraint_controller.dart';
import '../../../../core/route_path.dart';
import '../../../../core/routes.dart';
import '../../../../data/local/shared_prefs.dart';
import '../../../../global/helper/toast_message/toast_message.dart';
import '../../../../services/api_check.dart';
import '../../../../services/api_client.dart';
import '../../../../services/api_url.dart';
import '../../../../utils/app_constants/app_constants.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController with PasswordConstraintController {
  // for vendor
  
  // final emailController = TextEditingController(text: "videostore06@gmail.com");
  // final passWordController = TextEditingController(text: "salahAbc@1");



  // final emailController = TextEditingController(text: "fahadhossaim24@gmail.com");
  // final passWordController = TextEditingController(text: "12345678"); 

  // for client
  final emailController =
      TextEditingController(text: "salahuddin0758@gmail.com");
  final passWordController = TextEditingController(text: "Abcd1234@");

  final confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController clientEmailController = TextEditingController();
  final TextEditingController clientPasswordController =
      TextEditingController();
  final TextEditingController clientConfirmPasswordController =
      TextEditingController();
  final TextEditingController clientPhoneNumberController =
      TextEditingController();

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

      // Safely parse response body (handle empty / non-JSON)
      dynamic resBody;
      try {
        if (response.body == null) {
          resBody = null;
        } else if (response.body is String &&
            (response.body as String).trim().isEmpty) {
          resBody = null;
        } else if (response.body is String) {
          resBody = jsonDecode(response.body);
        } else {
          resBody = response.body;
        }
      } catch (e) {
        debugPrint("Failed to parse response body: $e");
        resBody = null;
      }

      if (response.statusCode == 200 && resBody != null) {
        debugPrint("Response body: $resBody");

        final accessToken = resBody["data"]?['accessToken'];
        if (accessToken == null) {
          toastMessage(message: AppStrings.someThing);
          return;
        }
        final userEmail = resBody['data']?['email'] ?? '';

        // Save token & user info
        await SharePrefsHelper.setString(AppConstants.userEmail, userEmail);
        await SharePrefsHelper.setString(AppConstants.bearerToken, accessToken);
        await SharePrefsHelper.setString(
            AppConstants.userId, resBody['data']?["_id"] ?? '');
        await SharePrefsHelper.setString(
            AppConstants.role, resBody['data']?["role"] ?? '');

        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        String role = decodedToken['role'] ?? '';
      

        if (role == 'vendor') {
          AppRouter.route.goNamed(RoutePath.homeScreen);
        } else if (role == 'client') {
          AppRouter.route.goNamed(RoutePath.userHomeScreen);
        }

        toastMessage(message: resBody["message"] ?? AppStrings.someThing);
      } else if (response.statusCode == 400) {
        final errorMsg = (resBody != null && resBody["error"] != null)
            ? resBody["error"]
            : AppStrings.someThing;
        toastMessage(message: errorMsg);
      } else {
        // ApiChecker may expect a valid response body; guard it to avoid crashes
        try {
          ApiChecker.checkApi(response);
        } catch (e) {
          debugPrint("ApiChecker failed: $e");
          toastMessage(message: AppStrings.someThing);
        }
      }
    } catch (e) {
      toastMessage(message: AppStrings.someThing);
      debugPrint("SignIn Error: $e");
    } finally {
      isSignInLoading.value = false;
    }
  }

//==============Initial route for the app lunching-============

  static Future<String> getInitialRoute() async {
    await SharePrefsHelper.init();

    final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
    final role = await SharePrefsHelper.getString(AppConstants.role);

    if (token.isNotEmpty) {
      if (role == 'vendor') {
        return RoutePath.homeScreen;
      } else if (role == 'client') {
        return RoutePath.userHomeScreen;
      }
    }
    return RoutePath.chooseAuthScreen;
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

  //>>>>>>>>>>>>>>>>>>✅✅Sign up Client✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  // form type toggle
  RxBool isClientSelected = true.obs;

  void toggleClientVendor(bool isClient) {
    isClientSelected.value = isClient;
  }

  RxBool isClient = false.obs;

  void clearClientSIgnUpMethodFromClear() {
    nameController.clear();
    clientPasswordController.clear();
    clientConfirmPasswordController.clear();
    clientPhoneNumberController.clear();
  }

  Future<void> clientSIgnUp(BuildContext context) async {
    if (!areTrue.value) {
      toastMessage(
          message: "Please make sure your password meets all requirements.");
      return;
    }
    isClient.value = true;
    refresh();

    Map<String, dynamic> body = {
      "name": nameController.text.trim(),
      "email": clientEmailController.text.trim(),
      "password": clientPasswordController.text.trim(),
      "phone": clientPhoneNumberController.text.trim(),
      "role": "client",
      "isSocial": "false",
    };

    var response = await ApiClient.postMultipartData(
      ApiUrl.register,
      body,
      // multipartBody: [
      //   MultipartBody("image", File(generalController.image.value)),
      // ],
    );
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      clearClientSIgnUpMethodFromClear();
      AppRouter.route.pushNamed(
        RoutePath.otpScreen,
        extra: {
          "isForget": true,
          "email": clientEmailController.text,
        },
      );
      toastMessage(message: responseData["message"]); 
    } else if (response.statusCode == 400) {
     EasyLoading.showError(responseData["error"]);
    } else {
      ApiChecker.checkApi(response);
    }

    isClient.value = false;
    refresh();
  }

//>>>>>>>>>>>>>>>>>>✅✅SIgn up Vendor✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController businessPhoneController = TextEditingController();
  final TextEditingController businessPasswordController =
      TextEditingController();
  final TextEditingController businessConfirmPasswordController =
      TextEditingController();
  // final TextEditingController businessAddressController =
  //     TextEditingController();
  final TextEditingController businessDescriptionController =
      TextEditingController();
  final TextEditingController businessDeliveryOptionController =
      TextEditingController();
  final TextEditingController businessGenderController =
      TextEditingController();
  TextEditingController docController = TextEditingController();

  Rx<File?> selectedDocument = Rx<File?>(null);
  final RxBool showAllExisting = false.obs;
  final RxList<File> pickedDocuments = <File>[].obs;

  Future<void> pickDocuments() async {
    final picker = ImagePicker();
    final files = await picker.pickMultipleMedia();
    if (files.isNotEmpty) {
      pickedDocuments.assignAll(files.map((e) => File(e.path)));
    }
  }

  RxBool isVendorLoading = false.obs;

  final RxString latitude = ''.obs;
  final RxString longitude = ''.obs;
  final RxString address = 'Pick Your Locations'.obs;

  Future<void> vendorSIgnUp(BuildContext context) async {
    if (!areTrue.value) {
      toastMessage(
          message: "Please make sure your password meets all requirements.");
      return;
    }
    isVendorLoading.value = true;
    refresh();
    if (pickedDocuments.isEmpty) {
      isVendorLoading.value = false;
      refresh();
      toastMessage(message: "Please upload a document before proceeding.");
      return;
    }
    Map<String, dynamic> body = {
      "name": businessNameController.text.trim(),
      "email": businessEmailController.text.trim(),
      "password": businessPasswordController.text.trim(),
      "phone": businessPhoneController.text.trim(),
      "role": "vendor",
      "isSocial": "false",
      "address": address.value,
      "lat": latitude.value,
      "lng": longitude.value,
      "description": businessDescriptionController.text.trim(),
      "deliveryOption":
          businessDeliveryOptionController.text.toLowerCase().trim(),
    };

    var response = await ApiClient.postMultipartData(
      ApiUrl.register,
      body,
      multipartBody: pickedDocuments
          .map((file) => MultipartBody("documents", file))
          .toList(),
    );
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      AppRouter.route.pushNamed(
        RoutePath.otpScreen,
        extra: {
          "isVendor": true,
          "email": businessEmailController.text,
        },
      );
      toastMessage(message: responseData["message"]);
    } else if (response.statusCode == 400) {
      EasyLoading.showError(responseData["error"]);
    } else {
      ApiChecker.checkApi(response);
    }

    isVendorLoading.value = false;
    refresh();
  }

  //>>>>>>>>>>>>>>>>>>✅✅Client Account Active Otp ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  String activationCode = "";
  RxBool isActiveLoading = false.obs;

  Future<void> userAccountActiveOtp() async {
    if (activationCode.isEmpty) {
      toastMessage(message: "Please enter the activation code.");
      return;
    }

    isActiveLoading.value = true;
    refresh();

    Map<String, String> body = {
      "email": clientEmailController.text.trim(),
      "code": activationCode
    };
    var response =
        await ApiClient.postData(ApiUrl.emailVerify, jsonEncode(body));
    isActiveLoading.value = false;
    refresh();

    if (response.statusCode == 200) {
      clientEmailController.clear();

      AppRouter.route.goNamed(RoutePath.signInScreen);
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["error"]);
    } else {
      ApiChecker.checkApi(response);
      debugPrint("Error: ${response.body["message"]}");
    }
    isActiveLoading.value = false;
    refresh();
  }

  //>>>>>>>>>>>>>>>>>>✅✅Vendor Account Active ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  String vendorActivationCode = "";
  RxBool vendorIsActiveLoading = false.obs;

  Future<void> vendorAccountActiveOtp() async {
    if (vendorActivationCode.isEmpty) {
      toastMessage(message: "Please enter the activation code.");
      return;
    }

    vendorIsActiveLoading.value = true;
    refresh();

    Map<String, String> body = {
      "email": businessEmailController.text.trim(),
      "code": vendorActivationCode
    };
    var response =
        await ApiClient.postData(ApiUrl.emailVerify, jsonEncode(body));
    vendorIsActiveLoading.value = false;
    refresh();

    if (response.statusCode == 200) {
      businessEmailController.clear();

      AppRouter.route.goNamed(RoutePath.signInScreen);
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      pinCodeController.clear();
      toastMessage(message: response.body["error"]);
    } else {
      ApiChecker.checkApi(response);
      debugPrint("Error: ${response.body["message"]}");
    }
    vendorIsActiveLoading.value = false;
    refresh();
  }

  @override
  void onInit() {
    super.onInit();
  }

  // @override
  // void onClose() {
  //   businessNameController.dispose();
  //   businessEmailController.dispose();
  //   businessPasswordController.dispose();
  //   businessPhoneController.dispose();
  //   businessDescriptionController.dispose();
  //   businessDeliveryOptionController.dispose();
  //   businessGenderController.dispose();
  //   clientEmailController.dispose();
  //   clientPasswordController.dispose();
  //   clientConfirmPasswordController.dispose();
  //   clientPhoneNumberController.dispose();
  //   nameController.dispose();
  //   confirmPasswordController.dispose();
  //   emailController.dispose();
  //   passWordController.dispose();
  //   docController.dispose();

  //   super.onClose();
  // }
}
