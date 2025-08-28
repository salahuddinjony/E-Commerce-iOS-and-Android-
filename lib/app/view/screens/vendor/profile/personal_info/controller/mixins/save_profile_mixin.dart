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
    if (addressController.text.trim() != (id?.address ?? '')) changed = true;
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

    final rawLoc = locationController.text.trim();
    if (rawLoc.isNotEmpty) changed = true; // treat any entered loc as change

    if (!changed) {
      EasyLoading.showInfo('No changes to save');
      return false;
    }

    String? lat;
    String? lng;
    if (rawLoc.isNotEmpty) {
      final parts = rawLoc.split(',');
      if (parts.isNotEmpty && parts[0].trim().isNotEmpty) lat = parts[0].trim();
      if (parts.length > 1 && parts[1].trim().isNotEmpty) lng = parts[1].trim();
    }

    final body = <String, dynamic>{
      'name': trimmedName,
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
      'description': descriptionController.text.trim(),
      'deliveryOption':
          selectedDelivery.value.isEmpty ? null : selectedDelivery.value,
      'lat': latitude.value,
      'lng': lng,
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
        EasyLoading.showError(
            (res.body is Map && res.body['message'] != null)
                ? res.body['message'].toString()
                : 'Update failed (${res.statusCode})');
        ApiChecker.checkApi(res);
      }
    } catch (_) {
      EasyLoading.showError('Update failed');
    } finally {
      EasyLoading.dismiss();
      isSaving.value = false;
    }
    return false;
  }
}