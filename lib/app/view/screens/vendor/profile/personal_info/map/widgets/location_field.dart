import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/map/screen/map_picker_screen.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/map/show_address_based_on_latLng.dart';
import '../../controller/profile_controller.dart';

class LocationField extends StatelessWidget {
  final ProfileController controller;
  const LocationField({super.key, required this.controller});

  Future<void> pickLocation(BuildContext context) async {
    // Show address based on latitude and longitude before opening the map
    final lat =
        double.tryParse(controller.latitude.value) ?? 24.7136;
    final lng =
        double.tryParse(controller.longitude.value) ?? 46.6753;
    // try {
    //   List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    //   if (placemarks.isNotEmpty) {
    //     final place = placemarks.first;
    //     controller.address.value = [
    //       place.name,
    //       place.street,
    //       place.locality,
    //       place.administrativeArea,
    //       place.country
    //     ].where((e) => e != null && e.isNotEmpty).join(', ');
    //   } else {
    //     controller.address.value = 'Unknown location';
    //   }
    // } catch (e) {
    //   controller.address.value = 'Unknown location';
    // }

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
      
      controller.address.value = await ShowAddressBasedOnLatlng.updateAddress(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Address',
          textAlign: TextAlign.start,
          font: CustomFont.inter,
          color: AppColors.darkNaturalGray,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          bottom: 12.h,
        ),
        GestureDetector(
          onTap: () => pickLocation(context),
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
        ),
      ],
    );
  }
}
