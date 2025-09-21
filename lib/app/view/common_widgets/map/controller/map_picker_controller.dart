import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart' show Location, locationFromAddress;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/app/view/common_widgets/map/show_address_based_on_latLng.dart';
import 'package:local/app/view/screens/features/client/user_home/vendor_list/service/vendor_list_service.dart';
class MapPickerController extends GetxController with VendorListService {
  Rx<LatLng> pickedLocation = LatLng(24.7136, 46.6753).obs; // Default to Riyadh
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var pickedAddress = ''.obs;
   final searchController = TextEditingController();
  GoogleMapController? mapController;
  RxBool itsHasText = false.obs;

  MapPickerController(LatLng initialPosition) {
    pickedLocation.value = initialPosition;
    updateAddress(initialPosition);
  }
  
  Future<BitmapDescriptor> getCustomMarkerIcon() async {
  return await BitmapDescriptor.asset(
    const ImageConfiguration(size: Size(48, 48)), // icon size
    'assets/icons/download.png',
  );
}
  
  @override
  void onInit() {
    super.onInit();
    // initialize flag based on current text
    itsHasText.value = searchController.text.isNotEmpty;

    // keep itsHasText in sync with the TextField content
    searchController.addListener(() {
      itsHasText.value = searchController.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    mapController?.dispose();
    super.onClose();
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        errorMessage.value = 'Location permission denied.';
        isLoading.value = false;
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        
          desiredAccuracy: LocationAccuracy.high
        );
      pickedLocation.value = LatLng(position.latitude, position.longitude);
      mapController?.animateCamera(
        CameraUpdate.newLatLng(pickedLocation.value),
      );
      await updateAddress(pickedLocation.value);
    } catch (e) {
      errorMessage.value = 'Could not get current location.';
    }
    isLoading.value = false;
  }

  Future<void> searchAndMove(String address) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        pickedLocation.value = LatLng(loc.latitude, loc.longitude);
        mapController?.animateCamera(
          CameraUpdate.newLatLng(pickedLocation.value),
        );
        await updateAddress(pickedLocation.value);
      } else {
        errorMessage.value = 'No location found for "$address".';
      }
    } catch (e) {
      errorMessage.value = 'No location found for "$address".';
    }
    isLoading.value = false;
  }
  updateAddress(LatLng initialPosition) async {
   pickedAddress.value = await ShowAddressBasedOnLatlng.updateAddress(initialPosition);
  }
}