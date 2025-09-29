import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/map/screen/map_picker_screen.dart';
import 'package:local/app/view/common_widgets/map/show_address_based_on_latLng.dart';
import 'package:local/app/view/screens/features/client/user_home/controller/user_home_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/controller/delivery_locations_controller.dart';

class LocationField<T> extends StatelessWidget {
  final T controller;
  final bool isUser;
  
  final bool isDeliveryLocation;
  LocationField({super.key, required this.controller, this.isUser = false, this.isDeliveryLocation = false});
  final RxBool isLoading = false.obs;

  Future<void> pickLocation(BuildContext context) async {
    final dyn = controller as dynamic;
     
    final lat = double.tryParse(dyn.latitude.value) ?? 24.7136;
    final lng = double.tryParse(dyn.longitude.value) ?? 46.6753;

    final picked = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(
          initialPosition: LatLng(lat, lng),
        ),
      ),
    );

    // If a location was picked from the map, use it.
    if (picked != null && picked is LatLng) {
      dyn.latitude.value = picked.latitude.toString();
      dyn.longitude.value = picked.longitude.toString();
      dyn.address.value = await ShowAddressBasedOnLatlng.updateAddress(picked);
      // If this field is the delivery location, propagate the selected
      // coordinates to the main UserHomeController so its vendor search
      // and markers update (UserHomeController listens to its latitude/longitude).
      try {
        if (controller is MixInDeliveryLocation) {
          final userHome = Get.find<UserHomeController>();
          userHome.latitude.value = picked.latitude.toString();
          userHome.longitude.value = picked.longitude.toString();
          userHome.address.value = dyn.address.value;
        }
      } catch (_) {
        // If UserHomeController is not found, ignore silently.
      }
      return;
    }
  }

  // Future<void> setCurrentLocationAndAddress(BuildContext context) async {
  //    final dyn = controller as dynamic;
   
 
  //    try {
  //     // show loader while resolving permission and obtaining location
  //     isLoading.value = true;
  //     // check/request permission
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //     }
  //     if (permission == LocationPermission.denied ||
  //         permission == LocationPermission.deniedForever) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Location permission denied')),
  //       );
  //       return;
  //     }

  //     // try to get current position with a timeout, otherwise fall back to last known
  //     Position? position;
  //     try {
  //       position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       ).timeout(const Duration(seconds: 10));
  //     } catch (_) {
  //       position = await Geolocator.getLastKnownPosition();
  //     }

  //     if (position == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Could not determine device location')),
  //       );
  //       return;
  //     }

  //     final latLng = LatLng(position.latitude, position.longitude);

  //     // update map camera if a controller is registered (safe lookup)
  //     GoogleMapController? mapController;
  //     try {
  //       if (Get.isRegistered<GoogleMapController>()) {
  //         mapController = Get.find<GoogleMapController>();
  //       }
  //     } catch (_) {
  //       mapController = null;
  //     }
  //     await mapController?.animateCamera(CameraUpdate.newLatLng(latLng));

  //     // update controller values and address
  //     dyn.latitude.value = latLng.latitude.toString();
  //     dyn.longitude.value = latLng.longitude.toString();
  //     dyn.address.value = await ShowAddressBasedOnLatlng.updateAddress(latLng);
  //    } catch (e) {
  //      ScaffoldMessenger.of(context).showSnackBar(
  //        const SnackBar(content: Text('Failed to get current location')),
  //      );
  //    }
  //    finally {
  //     isLoading.value = false;
  //   }
  //  }


  @override
  Widget build(BuildContext context) {
    final dyn = controller as dynamic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text:isUser ? "Your Location" : isDeliveryLocation? "Delivery Location" : "Location",
          textAlign: TextAlign.start,
          font: CustomFont.inter,
          color: AppColors.darkNaturalGray,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          bottom: 12.h,   
        ),
        GestureDetector(
          onTap: () => isUser ? dyn.setCurrentLocationAndAddress(context) : pickLocation(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:isUser? AppColors.brightCyan.withValues(alpha: .3) : isDeliveryLocation ? Colors.red.withValues(alpha: .3) : Colors.transparent,
              border: Border.all(color:isUser? isDeliveryLocation ? Colors.blue : Colors.transparent : Colors.grey), 
              borderRadius: BorderRadius.circular(8), 
            ),
            child: Row( 
              children: [
                isUser ? const Icon(Icons.my_location) : isDeliveryLocation ? const Icon(Icons.delivery_dining) : const Icon(Icons.map),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() => Text(
                        dyn.address.value.isNotEmpty
                            ? dyn.address.value
                            : ('Lat: ${dyn.latitude.value}, Lng: ${dyn.longitude.value}'),
                      )),
                ),
                isUser
                    ? Obx(() => dyn.isLoading.value == false
                        ? SizedBox.shrink()
                        : const SizedBox(
                            width: 16,
                            height: 16,
                            child: LinearProgressIndicator(
                              backgroundColor: AppColors.brightCyan,
                              valueColor: AlwaysStoppedAnimation(Colors.deepOrangeAccent),
                            ),
                          ))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
