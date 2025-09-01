import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import '../../../../common_widgets/custom_appbar/custom_appbar.dart';

class ViewMapScreen extends StatelessWidget {
  ViewMapScreen({super.key});

  final Rx<LatLng> currentPosition =
      const LatLng(0.0, 0.0).obs;
  final Rx<Marker?> currentMarkerLocation =
  Rx<Marker?>(null);

  Future<void> getCurrentLocation(GoogleMapController controller) async {
    final LatLng position =
    await controller.getLatLng(const ScreenCoordinate(x: 0, y: 0));

    currentPosition.value = position;

    currentMarkerLocation.value = Marker(
      markerId: const MarkerId('current_location'),
      position: position,
      infoWindow: const InfoWindow(title: 'Your Location'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Map",
        iconData: Icons.arrow_back,
      ),
      body: Obx(() {
        return GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            getCurrentLocation(controller);
          },
          initialCameraPosition: CameraPosition(
            target: currentPosition.value,
            zoom: 14.0,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          cameraTargetBounds: CameraTargetBounds.unbounded,
          markers: currentMarkerLocation.value != null
              ? {currentMarkerLocation.value!}
              : {},
        );
      }),
    );
  }
}
