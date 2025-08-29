import 'package:geocoding/geocoding.dart' show Placemark, placemarkFromCoordinates;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowAddressBasedOnLatlng {
  static final address = ''.obs;

  static Future<String> updateAddress(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return address.value = [
          place.name,
          place.street,
          place.locality,
          place.administrativeArea,
          place.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      } else {
        return address.value = 'Unknown location';
      }
    } catch (e) {
      return address.value = 'Unknown location';
    }
  }
}
