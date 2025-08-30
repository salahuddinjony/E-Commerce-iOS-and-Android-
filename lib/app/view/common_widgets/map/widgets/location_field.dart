import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/map/screen/map_picker_screen.dart';
import 'package:local/app/view/common_widgets/map/show_address_based_on_latLng.dart';

class LocationField<T> extends StatelessWidget {
  final T controller;
  const LocationField({super.key, required this.controller});

  Future<void> pickLocation(BuildContext context) async {
    // cast to dynamic to access expected members without an interface
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
    if (picked != null && picked is LatLng) {
      dyn.latitude.value = picked.latitude.toString();
      dyn.longitude.value = picked.longitude.toString();

      dyn.address.value = await ShowAddressBasedOnLatlng.updateAddress(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dyn = controller as dynamic;

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
                        dyn.address.value.isNotEmpty
                            ? dyn.address.value
                            : ('Lat: ${dyn.latitude.value}, Lng: ${dyn.longitude.value}'),
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
