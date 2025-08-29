import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/services/profile_edit_service.dart';
import '../../../../../../../data/local/shared_prefs.dart';
import '../../../../../../../services/api_check.dart';
import '../../../../../../../utils/app_constants/app_constants.dart';
import 'profile_state_mixin.dart';
import 'profile_fetch_mixin.dart';

mixin SaveProfileMixin on ProfileStateMixin, ProfileFetchMixin {
  Future<bool> saveProfile() async {
    if (isSaving.value) return false;
    final userId = await SharePrefsHelper.getString(AppConstants.userId);
    if (userId.isEmpty) return false;

    final data = profileModel.value;
    final id = data.profile?.id;

    bool changed = false;
    final trimmedName = fullNameController.text.trim();
    if (trimmedName != (id?.name ?? '')) changed = true;
    if (phoneController.text.trim() != (data.phone ?? '')) changed = true;
    if (descriptionController.text.trim() != (id?.description ?? '')) changed = true;

    final currentGender =
        (selectedGender.value.isEmpty ? genderController.text : selectedGender.value).trim();
    final currentDelivery = selectedDelivery.value;
    final serverDelivery = (id?.deliveryOption != null && id!.deliveryOption!.isNotEmpty)
        ? id.deliveryOption!.first
        : '';
    if (currentDelivery.isNotEmpty && currentDelivery != serverDelivery) changed = true;

    if (pickedImage.value.isNotEmpty) changed = true;
    if (pickedDocuments.isNotEmpty) changed = true;

    if (latitude.value.isNotEmpty && longitude.value.isNotEmpty) changed = true;

    if (!changed) {
      EasyLoading.showInfo('No changes to save');
      return false;
    }


    // if (latitude.value.isNotEmpty && longitude.value.isNotEmpty) {
  
    //   if (latitude.value != (id?.location?.coordinates?[1].toString() ?? '') ||
    //       longitude.value != (id?.location?.coordinates?[0].toString() ?? '')) {
    //     changed = true;
    //   }
    // }

    final body = <String, dynamic>{
      'name': trimmedName,
      'phone': phoneController.text.trim(),
      'description': descriptionController.text.trim(),
      'deliveryOption':
          selectedDelivery.value.isEmpty ? null : selectedDelivery.value,
      'lat': latitude.value,
      'lng': longitude.value,
      'gender': currentGender.isEmpty ? null : currentGender,
    }..removeWhere((k, v) => v == null || (v is String && v.trim().isEmpty));

    try {
      isSaving.value = true;
      EasyLoading.show(status: 'Saving...');
      final res = await ProfileEditService.updateProfile(
        userId: userId,
        body: body,
        imageFile: pickedImage.value.isNotEmpty ? File(pickedImage.value) : null,
        documentFiles: pickedDocuments.isEmpty ? null : pickedDocuments,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        await getProfile(userId: userId);
        pickedDocuments.clear();
        pickedImage.value = '';
        EasyLoading.showSuccess('Updated');
        return true;
      } else {
        // Show the full error JSON if present
        String errorMessage = 'Update failed';
        if (res.body != null) {
          errorMessage = jsonDecode(res.body)['error']?.toString() ?? errorMessage;
        }
        EasyLoading.showError(errorMessage);
        ApiChecker.checkApi(res);
      }
    } catch (e) {
    EasyLoading.showError('An error occurred');
      // Log the error if needed
      print('Error in saveProfile: $e');
    } finally {
      EasyLoading.dismiss();
      isSaving.value = false;
    }
    return false;
  }
}