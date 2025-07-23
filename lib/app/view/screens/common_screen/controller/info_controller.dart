import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/common_screen/model/privacy.dart';

import '../../../../services/api_check.dart';
import '../../../../services/api_client.dart';
import '../../../../services/app_url.dart';
import '../../../../utils/enums/status.dart';
import '../model/terms.dart';

class InfoController extends GetxController {
  final rxRequestStatus = Status.loading.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  var selectedIndex = Rx<int?>(null);

// Toggle the selected FAQ item
  void toggleItem(int index) {
    selectedIndex.value = selectedIndex.value == index ? null : index;
  }

//>>>>>>>>>>>>>>>>>>✅✅Get Terms ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  Rx<TermsData> termsData = TermsData().obs;

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

  Rx<PrivacyData> privacyData = PrivacyData().obs;

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

  @override
  void onInit() {
    getTerms();
    getPrivacy();
    super.onInit();
  }
}
