import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/model/profile_model.dart';
import '../../../../../../../services/api_client.dart';
import '../../../../../../../services/api_check.dart';
import '../../../../../../../services/app_url.dart';
import '../../../../../../../utils/enums/status.dart';
import '../../../../../../../data/local/shared_prefs.dart';
import '../../../../../../../utils/app_constants/app_constants.dart';
import 'profile_state_mixin.dart';

mixin ProfileFetchMixin on ProfileStateMixin {
  Future<void> getProfile({required String userId}) async {
    setRxRequestStatus(Status.loading);
    final response = await ApiClient.getData(ApiUrl.getProfile(userId: userId));
    setRxRequestStatus(Status.completed);

    if (response.statusCode == 200) {
      profileModel.value = ProfileData.fromJson(response.body["data"]);
      try {
        final id = profileModel.value.profile?.id;
        // longitude.value = id?.location?.coordinates?[0].toString() ?? '';
        // latitude.value = id?.location?.coordinates?[1].toString() ?? '';

        // Reverse-geocode lat/lng from profile data and update address
        try {
          final latStr = id?.location?.coordinates?[1].toString();
          final lngStr = id?.location?.coordinates?[0].toString();
          if (latStr != null && lngStr != null && latStr.isNotEmpty && lngStr.isNotEmpty) {
            latitude.value = latStr;
            longitude.value = lngStr;
            final lat = double.tryParse(latStr);
            final lng = double.tryParse(lngStr);
            if (lat != null && lng != null) {
              List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
              if (placemarks.isNotEmpty) {
                final place = placemarks.first;
                address.value = [
                  place.name,
                  place.street,
                  place.locality,
                  place.administrativeArea,
                  place.country
                ].where((e) => e != null && e.isNotEmpty).join(', ');
              } else {
                address.value = 'Unknown location';
              }
            } else {
              address.value = '';
            }
          } else {
            address.value = '';
          }
        } catch (_) {
          address.value = 'Unknown location';
        }

        final docs = (id?.documents is List)
            ? List<String>.from(id!.documents as Iterable)
            : <String>[];
        serverDocuments
          ..clear()
          ..addAll(docs);
      } catch (_) {
        serverDocuments.clear();
      }
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
    final String userId = await SharePrefsHelper.getString(AppConstants.userId);
    if (userId.isEmpty) {
      debugPrint("No ID found, skipping profile load.");
      return;
    }
    await getProfile(userId: userId);

    final data = profileModel.value;
    final id = data.profile?.id;
    fullNameController.text = id?.name ?? '';
    phoneController.text = data.phone ?? '';

    // try {
    //   // final String? gender = id?.gender?.toString();
    //   if (gender != null && gender.isNotEmpty) {
    //     final g = gender.toLowerCase();
    //     genderController.text = g == 'male'
    //         ? 'Male'
    //         : g == 'female'
    //             ? 'Female'
    //             : 'Other';
    //     selectedGender.value = genderController.text;
    //   }
    // } catch (_) {}

    try {
      if (id?.deliveryOption != null && id!.deliveryOption!.isNotEmpty) {
        selectedDelivery.value = id.deliveryOption!.first;
      }
    } catch (_) {}
  }
}