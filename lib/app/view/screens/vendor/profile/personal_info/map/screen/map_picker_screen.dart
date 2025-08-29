import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/controller/profile_controller.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/map/controller/map_picker_controller.dart';

class MapPickerScreen extends StatelessWidget {
  final LatLng initialPosition;
  const MapPickerScreen({super.key, required this.initialPosition});
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MapPickerController>()) {
      Get.put(MapPickerController(initialPosition));
    }
    final mapPickerController = Get.find<MapPickerController>();

    // Listen to pickedAddress and update searchController text
    mapPickerController.pickedAddress.listen((address) {
      mapPickerController.searchController.text = address;
    });

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Pick Address'),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   foregroundColor: Colors.black,
      // ),
      body: Stack(
        children: [
          // Google Map
          Obx(
            () => GoogleMap(
              initialCameraPosition: CameraPosition(
                target: mapPickerController.pickedLocation.value,
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (controller) {
                mapPickerController.mapController = controller;
              },
              onTap: (latLng) async {
                mapPickerController.pickedLocation.value = latLng;
                await mapPickerController.updateAddress(latLng);
              },
              markers: {
                Marker(
                  markerId: const MarkerId('picked'),
                  position: mapPickerController.pickedLocation.value,
                ),
              },
            ),
          ),
          // Floating Search Bar (shows picked address)
          Positioned(
            top: 80,
            left: 16,
            right: 16,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: mapPickerController.searchController,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.location_on, color: Colors.blue),
                          hintText: 'Search location',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty &&
                              value !=
                                  mapPickerController.pickedAddress.value) {
                            mapPickerController.searchAndMove(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => mapPickerController.itsHasText.value
                          ? IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () {
                                mapPickerController.itsHasText.value = false;
                                mapPickerController.searchController.clear();
                                mapPickerController.errorMessage.value = '';
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                    Obx(
                      () => mapPickerController.itsHasText.value
                          ? IconButton(
                              icon:
                                  const Icon(Icons.search, color: Colors.blue),
                              onPressed: () {
                                if (mapPickerController
                                    .searchController.text.isNotEmpty) {
                                  mapPickerController.searchAndMove(
                                      mapPickerController
                                          .searchController.text);
                                }
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // GPS Button (bottom right above FAB)
          Positioned(
            bottom: 170,
            right: 10,
            child: FloatingActionButton(
              heroTag: 'gps',
              mini: true,
              backgroundColor: Colors.white,
              elevation: 6,
              child: const Icon(Icons.my_location, color: Colors.blue),
              onPressed: () {
                mapPickerController.getCurrentLocation();
              },
            ),
          ),
          // Loading Indicator
          Obx(() => mapPickerController.isLoading.value
              ? Positioned(
                  top: 130,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,  
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const CustomLoader(),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          // Error Message
          Obx(() => mapPickerController.errorMessage.value.isNotEmpty
              ? Positioned(
                  top: 150,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: .9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              mapPickerController.errorMessage.value,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
      floatingActionButton: Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.only(bottom: 80, right: 0),
        child: FloatingActionButton(
          backgroundColor: AppColors.brightCyan,
          child: const Icon(Icons.check, color: Colors.white),
          onPressed: () {
            // Update lat/lng in ProfileController before popping
            // final profileController = Get.find<ProfileController>();
            final picked = mapPickerController.pickedLocation.value;
            // profileController.latitude.value = picked.latitude.toString();
            // profileController.longitude.value = picked.longitude.toString();
            Navigator.pop(context, picked);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
