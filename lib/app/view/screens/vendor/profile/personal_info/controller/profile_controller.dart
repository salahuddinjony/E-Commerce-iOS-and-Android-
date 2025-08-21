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
  final RxString latitude = ''.obs;
  final RxString longitude = ''.obs;
  final RxBool isSaving = false.obs;



  // Get Profile
  // Future<void> getProfile({required String userId}) async {
  //   setRxRequestStatus(Status.loading);
  //   // refresh();
  //   var response = await ApiClient.getData(ApiUrl.getProfile(userId: userId));
  //   setRxRequestStatus(Status.completed);

  //   if (response.statusCode == 200) {
  //     profileModel.value = ProfileData.fromJson(response.body["data"]);
  //     // final parsed = UserProfileModel.fromJson(response.body).data;
  //     // profileList
  //     //   ..clear()
  //     //   ..addIf(parsed != null, parsed!);

  //     // Extract server documents (adjust path according to real JSON)
  //     try {
  //       final id = profileModel.value.profile?.id;
  //       final docs = (id?.documents is List)
  //           ? List<String>.from(id!.documents as Iterable)
  //           : <String>[];
  //       serverDocuments
  //         ..clear()
  //         ..addAll(docs);
  //     } catch (_) {
  //       serverDocuments.clear();
  //     }

  //     // refresh();
  //   } else {
  //     if (response.statusText == ApiClient.noInternetMessage) {
  //       setRxRequestStatus(Status.internetError);
  //     } else {
  //       setRxRequestStatus(Status.error);
  //     }
  //     ApiChecker.checkApi(response);
  //   }
  // }


  // Get User ID
  // Future<void> getUserId() async {
  //   final String userId = await SharePrefsHelper.getString(AppConstants.id);
  //   if (userId.isEmpty) {
  //     debugPrint("No ID found, skipping profile load.");
  //     return;
  //   }
  //   debugPrint("Saved ID from SharedPreferences: $userId");
  //   await getProfile(userId: userId);
  //   // Prefill controllers when data arrives
  //   final data = profileModel.value;
  //   final id = data.profile?.id;
  //   fullNameController.text = id?.name ?? '';
  //   phoneController.text = data.phone ?? '';

  //   // Optional gender mapping if present
  //   try {
  //     final dynamic dynId = id;
  //     final String? gender = dynId?.gender?.toString();
  //     if (gender != null && gender.isNotEmpty) {
  //       final g = gender.toLowerCase();
  //       genderController.text = g == 'male'
  //           ? 'Male'
  //           : g == 'female'
  //               ? 'Female'
  //               : 'Other';
  //       selectedGender.value = genderController.text;
  //     }
  //   } catch (_) {}

  //   // Prefill delivery option if available (take the first one if list)
  //   try {
  //     if (id?.deliveryOption != null && id!.deliveryOption!.isNotEmpty) {
  //       selectedDelivery.value = id.deliveryOption!.first;
  //     }
  //   } catch (_) {}
  // }

  // // Open / download document then open locally
  // Future<void> openDocument(String url) async {
  //   final myUrl='https://gmosley-uteehub-backend.onrender.com'+url.split('10.10.20.19:5007').last;  //use just for testing purpose
  //   if (myUrl.isEmpty) {
  //     EasyLoading.showInfo('Invalid document url');
  //     return;
  //   }
  //   // Local file?
  //   if (myUrl.startsWith('file://') || myUrl.startsWith('/')) {
  //     final path = myUrl.replaceFirst('file://', '');
  //     await OpenFilex.open(path);
  //     return;
  //   }

  //   try {
  //     EasyLoading.show(status: 'Waiting for preview...');
  //     debugPrint('[openDocument] GET $myUrl');

  //     // Include auth headers if your ApiClient uses a token
  //     final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
  //     final headers = <String, String>{
  //       'Accept': '*/*',
  //       if (token.isNotEmpty) 'Authorization': 'Bearer $token',
  //     };

  //     final uri = Uri.parse(myUrl);
  //     final response = await http.get(uri, headers: headers);

  //     debugPrint('[openDocument] status=${response.statusCode}');
  //     if (response.statusCode != 200) {
  //       EasyLoading.showError('Preview failed (${response.statusCode})');
  //       debugPrint('[openDocument] body=${response.body}');
  //       return;
  //     }

  //     // Determine filename (content-disposition > path segment)
  //     String fileName = 'document';
  //     try {
  //       final dispo = response.headers['content-disposition'];
  //       if (dispo != null && dispo.contains('filename=')) {
  //         final part = dispo.split('filename=').last.trim();
  //         fileName = part.replaceAll('"', '').replaceAll("'", '');
  //       } else if (uri.pathSegments.isNotEmpty) {
  //         fileName = uri.pathSegments.last;
  //       }
  //       if (!fileName.contains('.')) {
  //         final ct = response.headers['content-type'] ?? '';
  //         if (ct.contains('pdf')) fileName += '.pdf';
  //         else if (ct.contains('png')) fileName += '.png';
  //         else if (ct.contains('jpeg') || ct.contains('jpg')) fileName += '.jpg';
  //         else if (ct.contains('plain')) fileName += '.txt';
  //       }
  //     } catch (_) {}

  //     final dir = await getTemporaryDirectory();
  //     final filePath = '${dir.path}/$fileName';
  //     final file = File(filePath);
  //     await file.writeAsBytes(response.bodyBytes);

  //     EasyLoading.dismiss();
  //     final result = await OpenFilex.open(filePath);
  //     if (result.type != ResultType.done) {
  //       if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
  //         EasyLoading.showError('Cannot open file');
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('[openDocument] error=$e');
  //     EasyLoading.dismiss();
  //     EasyLoading.showError('Open failed');
  //   }
  // }

  // Future<void> pickImage({required String source}) async {
  //   try {
  //     final picker = ImagePicker();
  //     final pickedFile = await picker.pickImage(
  //       source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
  //     );

  //     if (pickedFile != null) {
  //       print("New image picked: ${pickedFile.path}");
  //       pickedImage.value = pickedFile.path;
  //       // isNetworkImage.value = false;
  //     } else {
  //       print("No image selected");
  //     }
  //   } catch (e) {
  //     print("Error picking image: $e");
  //     EasyLoading.showError('Failed to pick image: $e');
  //   }
  // }

// Document Picker
  // Future<void> pickDocuments() async {
  //   final ImagePicker picker = ImagePicker();
  //   final List<XFile> files = await picker.pickMultipleMedia();
  //   if (files.isNotEmpty) {
  //     pickedDocuments.assignAll(files.map((e) => File(e.path)));
  //   }
  // }

  // Future<bool> saveProfile() async {
  //   if (isSaving.value) return false;
  //   final String userId = await SharePrefsHelper.getString(AppConstants.id);
  //   if (userId.isEmpty) return false;

  //   final data = profileModel.value;
  //   final id = data.profile?.id;

  //   // Detect changes vs server data
  //   bool changed = false;
  //   String trimmedName = fullNameController.text.trim();
  //   if (trimmedName != (id?.name ?? '')) changed = true;
  //   if (phoneController.text.trim() != (data.phone ?? '')) changed = true;
  //   if (addressController.text.trim() != (id?.address ?? '')) changed = true;
  //   if (descriptionController.text.trim() != (id?.description ?? '')) changed = true;

  //   final currentGender = (selectedGender.value.isEmpty ? genderController.text : selectedGender.value).trim();
  //   // final serverGender = (id?.gender ?? '').toString();
  //   // if (currentGender.isNotEmpty && currentGender != serverGender) changed = true;

  //   final currentDelivery = selectedDelivery.value;
  //   final serverDelivery = (id?.deliveryOption != null && id!.deliveryOption!.isNotEmpty)
  //       ? id.deliveryOption!.first
  //       : '';
  //   if (currentDelivery.isNotEmpty && currentDelivery != serverDelivery) changed = true;

  //   // If new image or new documents picked
  //   if (pickedImage.value.isNotEmpty) changed = true;
  //   if (pickedDocuments.isNotEmpty) changed = true;

  //   // Location (lat,lng) – compare only if user entered something
  //   String rawLoc = locationController.text.trim();
  //   if (rawLoc.isNotEmpty) {
  //     final parts = rawLoc.split(',');
  //     final newLat = parts.isNotEmpty ? parts[0].trim() : '';
  //     final newLng = parts.length > 1 ? parts[1].trim() : '';
  //     // final serverLat = (id?.lat ?? '').toString();
  //     // final serverLng = (id?.lng ?? '').toString();
  //     // if (newLat.isNotEmpty && newLat != serverLat) changed = true;
  //     // if (newLng.isNotEmpty && newLng != serverLng) changed = true;
  //   }

  //   if (!changed) {
  //     EasyLoading.showInfo('No changes to save');
  //     return false;
  //   }

  //   // Safe location parsing (only include if user entered)
  //   String? lat;
  //   String? lng;
  //   if (rawLoc.isNotEmpty) {
  //     final parts = rawLoc.split(',');
  //     if (parts.isNotEmpty && parts[0].trim().isNotEmpty) lat = parts[0].trim();
  //     if (parts.length > 1 && parts[1].trim().isNotEmpty) lng = parts[1].trim();
  //   }

  //   final Map<String, dynamic> body = {
  //     'name': trimmedName,
  //     'phone': phoneController.text.trim(),
  //     'address': addressController.text.trim(),
  //     'description': descriptionController.text.trim(),
  //     'deliveryOption': selectedDelivery.value.isEmpty ? null : selectedDelivery.value,
  //     'lat': lat,
  //     'lng': lng,
  //     'gender': currentGender.isEmpty ? null : currentGender,
  //   };
  //   body.removeWhere((k, v) => v == null || (v is String && v.trim().isEmpty));

  //   try {
  //     isSaving.value = true;
  //     EasyLoading.show(status: 'Saving...');
  //     final res = await ProfileEditService.updateProfile(
  //       userId: userId,
  //       body: body,
  //       imageFile: pickedImage.value.isNotEmpty ? File(pickedImage.value) : null,
  //       documentFiles: pickedDocuments.isEmpty ? null : pickedDocuments,
  //     );

  //     if (res.statusCode == 200 || res.statusCode == 201) {
  //       await getProfile(userId: userId);
  //       pickedDocuments.clear();
  //       pickedImage.value = '';
  //       EasyLoading.showSuccess('Updated');
  //       return true;
  //     } else {
  //       final msg = (res.body is Map && res.body['message'] != null)
  //           ? res.body['message'].toString()
  //           : 'Update failed (${res.statusCode})';
  //       EasyLoading.showError(msg);
  //       ApiChecker.checkApi(res);
  //     }
  //   } catch (e) {
  //     EasyLoading.showError('Update failed');
  //   } finally {
  //     EasyLoading.dismiss();
  //     isSaving.value = false;
  //   }
  //   return false;
  // }

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
