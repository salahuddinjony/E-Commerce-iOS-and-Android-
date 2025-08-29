// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/utils/enums/status.dart';

import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/controller/profile_controller.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/edit_profile/widgets/location_field.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/edit_profile/widgets/select_documents_button/select_documents.dart';

// New widget parts
import '../widgets/profile_header.dart';
import '../widgets/gender_dropdown.dart';
import '../widgets/contact_address_section.dart';
import '../widgets/delivery_dropdown.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final data = profileController.profileModel.value;
    final id = data.profile?.id;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.editProfile,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Obx(() {
          if (profileController.rxRequestStatus.value == Status.loading)
            return const CustomLoader();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(
                  controller: profileController,
                  imageUrl: id?.image ?? AppConstants.demoImage,
                  name: id?.name ?? 'User',
                  email: data.email ?? '',
                ),
                SizedBox(height: 20.h),
                ContactAddressSection(
                  controller: profileController,
                  id: id,
                ),
                SizedBox(height: 16.h),
                GenderDropdown(controller: profileController),
                SizedBox(height: 16.h),
                LocationField(controller: profileController),
                SizedBox(height: 16.h),
                DeliveryDropdown(controller: profileController),
                SizedBox(height: 12.h),
                SelectDocuments(
                  data: id,
                  profileController: profileController,
                ),
                SizedBox(height: 16.h),
                Obx(() => CustomButton(
                      onTap: profileController.isSaving.value
                          ? null
                          : () async {
                              final ok = await profileController.saveProfile();
                              if (ok && context.mounted) context.pop();
                            },
                      title: profileController.isSaving.value
                          ? 'Saving...'
                          : AppStrings.save,
                    )),
                SizedBox(height: 20.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class MapPickerController extends GetxController {
  var pickedLocation = LatLng(24.7136, 46.6753).obs; // Default to Riyadh
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var pickedAddress = ''.obs;
  GoogleMapController? mapController;

  MapPickerController(LatLng initialPosition) {
    pickedLocation.value = initialPosition;
    updateAddress(initialPosition);
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
        
          desiredAccuracy: LocationAccuracy.high);
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

  Future<void> updateAddress(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        pickedAddress.value = [
          place.name,
          place.street,
          place.locality,
          place.administrativeArea,
          place.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      } else {
        pickedAddress.value = 'Unknown location';
      }
    } catch (e) {
      pickedAddress.value = 'Unknown location';
    }
  }
}

class MapPickerScreen extends StatelessWidget {
  final LatLng initialPosition;
  const MapPickerScreen({super.key, required this.initialPosition});

  @override
  Widget build(BuildContext context) {
    final mapPickerController = Get.put(MapPickerController(initialPosition));
    final searchController = TextEditingController();

    // Listen to pickedAddress and update searchController text
    mapPickerController.pickedAddress.listen((address) {
      searchController.text = address;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Address'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Google Map
          Obx(() => GoogleMap(
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
              )),
          // Floating Search Bar (shows picked address)
          Positioned(
            top: 24,
            left: 16,
            right: 16,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() => TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: mapPickerController.pickedAddress.value.isNotEmpty
                                  ? mapPickerController.pickedAddress.value
                                  : 'Search location',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                mapPickerController.searchAndMove(value);
                              }
                            },
                          )),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.blue),
                      onPressed: () {
                        if (searchController.text.isNotEmpty) {
                          mapPickerController.searchAndMove(searchController.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // GPS Button (bottom right above FAB)
          Positioned(
            bottom: 160,
            right: 16,
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
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          // Error Message
          Obx(() => mapPickerController.errorMessage.value.isNotEmpty
              ? Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
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
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        margin: const EdgeInsets.only(bottom:70, right: 5),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: const Icon(Icons.check, color: Colors.white),
          onPressed: () {
            // Update lat/lng in ProfileController before popping
            final profileController = Get.find<ProfileController>();
            final picked = mapPickerController.pickedLocation.value;
            profileController.latitude.value = picked.latitude.toString();
            profileController.longitude.value = picked.longitude.toString();
            Navigator.pop(context, picked);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


