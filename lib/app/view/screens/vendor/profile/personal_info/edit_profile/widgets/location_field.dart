import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/edit_profile/screen/edit_profile_screen.dart';
import '../../controller/profile_controller.dart';

class LocationField extends StatelessWidget {
  final ProfileController controller;
  const LocationField({super.key, required this.controller});

  Future<void> _pickLocation(BuildContext context) async {
    // Show address based on latitude and longitude before opening the map
    final lat = double.tryParse(controller.latitude.value.toString()) ?? 24.7136;
    final lng = double.tryParse(controller.longitude.value.toString()) ?? 46.6753;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        controller.address.value = [
          place.name,
          place.street,
          place.locality,
          place.administrativeArea,
          place.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      } else {
        controller.address.value = 'Unknown location';
      }
    } catch (e) {
      controller.address.value = 'Unknown location';
    }

    final picked = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(
          initialPosition: LatLng(lat, lng),
        ),
      ),
    );
    if (picked != null && picked is LatLng) {
      controller.latitude.value = picked.latitude.toString();
      controller.longitude.value = picked.longitude.toString();

      // Reverse geocode to get address name
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          picked.latitude,
          picked.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          controller.address.value = [
            place.name,
            place.street,
            place.locality,
            place.administrativeArea,
            place.country
          ].where((e) => e != null && e.isNotEmpty).join(', ');
        } else {
          controller.address.value = 'Unknown location';
        }
      } catch (e) {
        controller.address.value = 'Unknown location';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickLocation(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() => Text(
                    controller.address.value.isNotEmpty
                        ? controller.address.value
                        : ('Lat: ${controller.latitude.value}, Lng: ${controller.longitude.value}'),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}