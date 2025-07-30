import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../../../data/local/shared_prefs.dart';
import '../../../../../../services/api_check.dart';
import '../../../../../../services/api_client.dart';
import '../../../../../../services/app_url.dart';
import '../../../../../../utils/app_constants/app_constants.dart';
import '../../../../../../utils/enums/status.dart';
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  final Rx<Status> rxRequestStatus = Status.loading.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  //>>>>>>>>>>>>>>>>>>✅✅Profile Section✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  final Rx<ProfileData> profileModel = ProfileData().obs; // Holds profile data

  Future<void> getProfile({required String userId}) async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.getProfile(userId: userId));
    setRxRequestStatus(Status.completed);

    if (response.statusCode == 200) {
      profileModel.value = ProfileData.fromJson(response.body["data"]);
      refresh();
      debugPrint("ProfileData=========${profileModel.value.profile?.id?.name}");
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        setRxRequestStatus(Status.internetError);
      } else {
        setRxRequestStatus(Status.error);
      }
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getUserId() async {
    String? userId = await SharePrefsHelper.getString(AppConstants.id);
    if (userId == null || userId.isEmpty) {
      debugPrint("No ID found, skipping profile load.");
      return;
    }
    debugPrint("Saved ID from SharedPreferences: $userId");
    await getProfile(userId: userId ?? "");
  }

  @override
  void onInit() {
    getUserId();
    super.onInit();
  }
}
