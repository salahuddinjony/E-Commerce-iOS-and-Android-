import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/model/profile_model.dart';
import '../../../../../../../utils/enums/status.dart';

mixin ProfileStateMixin on GetxController {
  // Request status
  final Rx<Status> rxRequestStatus = Status.loading.obs;
  void setRxRequestStatus(Status v) => rxRequestStatus.value = v;

  // Data
  final Rx<ProfileData> profileModel = ProfileData().obs;

  // Text controllers
  final fullNameController = TextEditingController();
  final genderController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  // Reactive fields
  final RxString selectedGender = ''.obs;
  final RxString pickedImage = ''.obs;
  final RxList<File> pickedDocuments = <File>[].obs;
  final RxList<String> serverDocuments = <String>[].obs;
  final RxString selectedDelivery = ''.obs;
  final RxBool isSaving = false.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    genderController.dispose();
    phoneController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.onClose();
  }
}