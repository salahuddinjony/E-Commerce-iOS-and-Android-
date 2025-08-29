import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:io';
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

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();


  final RxString selectedGender = ''.obs;
  final RxString pickedImage = ''.obs;
  final RxList<File> pickedDocuments = <File>[].obs;
  final RxList<String> serverDocuments = <String>[].obs; // URLs/paths from API
  final RxString selectedDelivery = ''.obs;
 
  final RxBool isSaving = false.obs;

 

  @override
  void onInit() {
    getUserId();
    super.onInit();
  }
  @override
  void onClose(){
    fullNameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    genderController.dispose();
    super.onClose();
  }
}
