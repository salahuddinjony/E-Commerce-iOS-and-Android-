import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/common_screen/model/privacy.dart';

import '../../../../services/api_check.dart';
import '../../../../services/api_client.dart';
import '../../../../services/app_url.dart';
import '../../../../utils/enums/status.dart';
import '../model/about_us.dart';
import '../model/terms.dart';

class InfoController extends GetxController {
  final rxRequestStatus = Status.loading.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  var selectedIndex = Rx<int?>(null);

// Toggle the selected FAQ item
  void toggleItem(int index) {
    selectedIndex.value = selectedIndex.value == index ? null : index;
  }

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

  // @override
  // void onInit() {
  //   getTerms();
  //   getPrivacy();
  //   getAbout();
  //   super.onInit();
  // }
}
