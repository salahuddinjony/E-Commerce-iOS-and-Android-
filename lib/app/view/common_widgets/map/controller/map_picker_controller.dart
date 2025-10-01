import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' show Location, locationFromAddress;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
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
  // cached custom marker for vendors
  final Rxn<BitmapDescriptor> customVendorMarker = Rxn<BitmapDescriptor>();

  MapPickerController(LatLng initialPosition) {
    pickedLocation.value = initialPosition;
    updateAddress(initialPosition);
  }

  Future<BitmapDescriptor> getCustomMarkerIcon() async {
    // Render a Material Icon (storefront) to an image and create a BitmapDescriptor
    return await _bitmapDescriptorFromIcon(
      Icons.shopping_bag,
      color: Colors.white,
      size: 30,
      
    );
  }

  Future<BitmapDescriptor> _bitmapDescriptorFromIcon(IconData icon,
      {Color color = Colors.black, int size = 64}) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final textStyle = TextStyle(
      fontSize: size.toDouble(),
      fontFamily: icon.fontFamily,
      color: color,
    );
    final span = TextSpan(text: String.fromCharCode(icon.codePoint), style: textStyle);
    textPainter.text = span;
    textPainter.layout();

    // paint background rounded rect for better visibility
    final double padding = 6.0;
    final double width = textPainter.width + padding * 2;
    final double height = textPainter.height + padding * 2;

    final paint = Paint()..color = AppColors.brightCyan;
    final rrect = RRect.fromRectAndRadius(Offset.zero & Size(width, height), const Radius.circular(12));
    canvas.drawRRect(rrect, paint);

    // paint the icon centered
    final offset = Offset(padding, padding);
    textPainter.paint(canvas, offset);

    final img = await pictureRecorder.endRecording().toImage(width.ceil(), height.ceil());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
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
    // Fetch nearest vendors whenever pickedLocation changes so markers update.
    ever<LatLng>(pickedLocation, (loc) {
      try {
        fetchNearestVendor(latLng: pickedLocation.value);
      } catch (_) {
        // ignore errors here; fetchNearestVendor already logs.
      }
    });
    // Load custom vendor marker once
    getCustomMarkerIcon().then((icon) {
      customVendorMarker.value = icon;
    }).catchError((_) {
      // ignore; fallback marker used in UI
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
        desiredAccuracy: LocationAccuracy.high,
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