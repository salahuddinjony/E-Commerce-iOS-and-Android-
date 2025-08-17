import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import 'package:local/app/view/screens/common_screen/model/privacy.dart';

import '../../../../global/helper/toast_message/toast_message.dart';
import '../../../../services/api_check.dart';
import '../../../../services/api_client.dart';
import '../../../../services/app_url.dart';
import '../../../../utils/enums/status.dart';
import '../model/about_us.dart';
import '../model/faq_model.dart';
import '../model/terms.dart';

class InfoController extends GetxController {
  final rxRequestStatus = Status.loading.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  var selectedIndex = Rx<int?>(null);

// Toggle the selected FAQ item
  void toggleItem(int index) {
    selectedIndex.value = selectedIndex.value == index ? null : index;
  }
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  Rx<TermsData> termsData = TermsData().obs;
  Rx<PrivacyData> privacyData = PrivacyData().obs;
  Rx<AboutUsData> aboutUsData = AboutUsData().obs;

//>>>>>>>>>>>>>>>>>>✅✅Get Terms ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  Future<void> getTerms() async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.termsAndCondition);
    setRxRequestStatus(Status.completed);

    if (response.statusCode == 200) {
      termsData.value = TermsData.fromJson(response.body['data']);
      debugPrint(
          'termsData========================"${termsData.value.termsCondition}"');
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        setRxRequestStatus(Status.internetError);
      } else {
        setRxRequestStatus(Status.error);
      }
      ApiChecker.checkApi(response);
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Get Privacy ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  Future<void> getPrivacy() async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.privacyPolicy);
    setRxRequestStatus(Status.completed);

    if (response.statusCode == 200) {
      privacyData.value = PrivacyData.fromJson(response.body['data']);
      debugPrint(
          'PrivacyData========================"${privacyData.value.privacyPolicy}"');
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        setRxRequestStatus(Status.internetError);
      } else {
        setRxRequestStatus(Status.error);
      }
      ApiChecker.checkApi(response);
    }
  }


  //>>>>>>>>>>>>>>>>>>✅✅About Us ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  Future<void> getAbout() async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.aboutUs);
    setRxRequestStatus(Status.completed);

    if (response.statusCode == 200) {
      aboutUsData.value = AboutUsData.fromJson(response.body['data']);
      debugPrint(
          'AboutUsData========================"${aboutUsData.value.description}"');
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        setRxRequestStatus(Status.internetError);
      } else {
        setRxRequestStatus(Status.error);
      }
      ApiChecker.checkApi(response);
    }
  }

//>>>>>>>>>>>>>>>>>>✅✅Change password ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  RxBool isChange = false.obs;

 Future<void> changePassword(BuildContext context) async {
    isChange.value = true;
    refresh();
    Map<String, String> body = {
      "email": authController.emailController.text.trim(),
      "oldPassword": currentPasswordController.text.trim(),
      "newPassword": newPasswordController.text.trim()
    };
    var response = await ApiClient.postData(
      ApiUrl.changePassword,
      jsonEncode(body),
    );
    if (response.statusCode == 200) {
      currentPasswordController.clear();
      newPasswordController.clear();
      repeatPasswordController.clear();
      context.pop();
      toastMessage(
        message: response.body["message"],
      );
    } else if (response.statusCode == 400) {
      toastMessage(
        message: response.body["error"],
      );
    } else {
      ApiChecker.checkApi(response);
    }
    isChange.value = false;
    refresh();
  }

//>>>>>>>>>>>>>>>>>>✅✅Get Faq ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxList<FaqList> faqList = <FaqList>[].obs;

  Future<void> getFaq() async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.faq);

    if (response.statusCode == 200) {
      faqList.value = List<FaqList>.from(
          response.body["data"].map((x) => FaqList.fromJson(x)));

      setRxRequestStatus(Status.completed);
      refresh();
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        setRxRequestStatus(Status.internetError);
      } else {
        setRxRequestStatus(Status.error);
      }
      ApiChecker.checkApi(response);
    }
  }


  @override
  void onInit() {
    getFaq();
    super.onInit();
  }

}
