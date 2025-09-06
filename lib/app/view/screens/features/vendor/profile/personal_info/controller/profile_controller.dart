
import 'package:get/get.dart';
import 'mixins/profile_state_mixin.dart';
import 'mixins/profile_fetch_mixin.dart';
import 'mixins/document_mixin.dart';
import 'mixins/save_profile_mixin.dart';

class ProfileController extends GetxController
    with
        ProfileStateMixin,
        ProfileFetchMixin,
        DocumentMixin,
        SaveProfileMixin {
  // final Rx<Status> rxRequestStatus = Status.loading.obs;

  // void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  //>>>>>>>>>>>>>>>>>>✅✅Profile Section✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  // final Rx<ProfileData> profileModel = ProfileData().obs; // Holds profile data

  // final RxList<UserProfileData> profileList =
  //     <UserProfileData>[].obs; // Store as list

      
  // Text controllers for Edit Profile (kept here to avoid Stateful widget)





 

  @override
  void onInit() {
    getUserId();
    super.onInit();
  }
  @override
  void onClose(){
    super.onClose();
  }
}
