import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/view/common_widgets/map/show_address_based_on_latLng.dart';

class UserHomeController extends GetxController {
  // For map
  final RxString latitude = ''.obs;
  final RxString longitude = ''.obs;
  RxString address = 'Loading...'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // wait for the first frame so Get.context is likely available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setCurrentLocationAndAddress(Get.context);
    });
  }

  Future<void> setCurrentLocationAndAddress(BuildContext? context) async {
    try {
     
      isLoading.value = true;
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
       address.value = 'Location permission denied';
       print('Location permission denied: ${address.value}');
       toastMessage(message: 'Location permission denied');
        isLoading.value = false;
        return;
      }

      // try to get current position with a timeout, otherwise fall back to last known
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(const Duration(seconds: 10));
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        address.value = 'Location permission denied';
       toastMessage(message: 'Could not determine device location');
        return;
      }

      final latLng = LatLng(position.latitude, position.longitude);

      // update map camera if a controller is registered (safe lookup)
      GoogleMapController? mapController;
      try {
        if (Get.isRegistered<GoogleMapController>()) {
          mapController = Get.find<GoogleMapController>();
        }
      } catch (_) {
        mapController = null;
      }
      await mapController?.animateCamera(CameraUpdate.newLatLng(latLng));

      // update controller values and address
      latitude.value = latLng.latitude.toString();
      longitude.value = latLng.longitude.toString();
      address.value = await ShowAddressBasedOnLatlng.updateAddress(latLng);
    } catch (e) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get current location')),
        );
      } else {
        Get.snackbar('Error', 'Failed to get current location');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
