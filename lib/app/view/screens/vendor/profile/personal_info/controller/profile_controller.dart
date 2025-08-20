import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../../../data/local/shared_prefs.dart';
import '../../../../../../services/api_check.dart';
import '../../../../../../services/api_client.dart';
import '../../../../../../services/app_url.dart';
import '../../../../../../utils/app_constants/app_constants.dart';
import '../../../../../../utils/enums/status.dart';
import '../model/profile_model.dart';
import '../../model/user_profile_model.dart';
import '../services/profile_edit_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final Rx<Status> rxRequestStatus = Status.loading.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  //>>>>>>>>>>>>>>>>>>✅✅Profile Section✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  final Rx<ProfileData> profileModel = ProfileData().obs; // Holds profile data
  final RxList<UserProfileData> profileList = <UserProfileData>[].obs; // Store as list
  // Text controllers for Edit Profile (kept here to avoid Stateful widget)
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final RxString selectedGender = ''.obs;
  final Rx<File?> pickedImage = Rx<File?>(null);
  final RxList<File> pickedDocuments = <File>[].obs;
  final RxString selectedDelivery = ''.obs;

  Future<void> getProfile({required String userId}) async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.getProfile(userId: userId));
    setRxRequestStatus(Status.completed);

    if (response.statusCode == 200) {
      // Parse into existing single-object model
      profileModel.value = ProfileData.fromJson(response.body["data"]);
      // Also parse into new list model for convenience/consistency
      final parsed = UserProfileModel.fromJson(response.body).data;
      profileList
        ..clear()
        ..addIf(parsed != null, parsed!);
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
    final String userId = await SharePrefsHelper.getString(AppConstants.id);
    if (userId.isEmpty) {
      debugPrint("No ID found, skipping profile load.");
      return;
    }
    debugPrint("Saved ID from SharedPreferences: $userId");
    await getProfile(userId: userId);
    // Prefill controllers when data arrives
    final data = profileModel.value;
    final id = data.profile?.id;
    fullNameController.text = id?.name ?? '';
    phoneController.text = data.phone ?? '';
    emailController.text = data.email ?? '';
    // Optional gender mapping if present
    try {
      final dynamic dynId = id;
      final String? gender = dynId?.gender?.toString();
      if (gender != null && gender.isNotEmpty) {
        final g = gender.toLowerCase();
        genderController.text = g == 'male'
            ? 'Male'
            : g == 'female'
                ? 'Female'
                : 'Other';
        selectedGender.value = genderController.text;
      }
    } catch (_) {}

    // Prefill delivery option if available (take the first one if list)
    try {
      if (id?.deliveryOption != null && id!.deliveryOption!.isNotEmpty) {
        selectedDelivery.value = id.deliveryOption!.first;
      }
    } catch (_) {}
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      pickedImage.value = File(xFile.path);
    }
  }

  Future<void> pickDocuments() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> files = await picker.pickMultipleMedia();
    if (files.isNotEmpty) {
      pickedDocuments.assignAll(files.map((e) => File(e.path)));
    }
  }

  Future<bool> saveProfile() async {
    final String userId = await SharePrefsHelper.getString(AppConstants.id);
    if (userId.isEmpty) return false;

    final body = {
      'name': fullNameController.text.trim(),
      'phone': phoneController.text.trim(),
      'gender': selectedGender.value.isEmpty
          ? genderController.text
          : selectedGender.value,
      'status': profileModel.value.status ?? 'active',
      'deliveryOption': selectedDelivery.value.isEmpty
          ? null
          : selectedDelivery.value,
    };

    final res = await ProfileEditService.updateProfile(
      userId: userId,
      body: body,
      imageFile: pickedImage.value,
      documentFiles: pickedDocuments,
    );

    if (res.statusCode == 200) {
      await getProfile(userId: userId);
      return true;
    }
    return false;
  }

  @override
  void onInit() {
    getUserId();
    super.onInit();
  }
}
