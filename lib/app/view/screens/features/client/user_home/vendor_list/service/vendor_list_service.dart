import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/view/screens/features/client/user_home/vendor_list/model/nearest_vendor_response.dart';

mixin class VendorListService {
  final RxList<Vendor> nearestVendors = <Vendor>[].obs;
  final RxBool isLoadingVendorList = false.obs;

  Future<void> fetchNearestVendor({required  latLng}) async {
    try {
      isLoadingVendorList.value = true;
     
      // First call: Always send clientLocation in body
      final Map<String, dynamic> body = {
        'clientLocation': '${latLng.latitude}, ${latLng.longitude}',
      };

      String endpoint = ApiUrl.getNearestVendorlist;
      final response = await ApiClient.getData(endpoint, body: body);
      
      if (response.statusCode == 200) {
        final data = VendorResponse.fromJson(response.body);
        final vendors = data.data ?? [];
        
        // If vendor list is empty, make a second call with empty body
        if (vendors.isEmpty) {
          debugPrint('No vendors found with location, trying without location...');
          final responseWithoutBody = await ApiClient.getData(endpoint, body: <String, dynamic>{});
          
          if (responseWithoutBody.statusCode == 200) {
            final dataWithoutBody = VendorResponse.fromJson(responseWithoutBody.body);
            nearestVendors.value = dataWithoutBody.data ?? [];
            debugPrint('Nearest vendors fetched (without location) length: ${nearestVendors.length}');
          } else {
            nearestVendors.value = [];
            debugPrint('Failed to load vendors without location: ${responseWithoutBody.statusText}');
          }
        } else {
          nearestVendors.value = vendors;
          debugPrint('Nearest vendors fetched length: ${nearestVendors.length}');
        }
        
        debugPrint('Response data: ${response.body}');
        isLoadingVendorList.value = false;
      } else {
        isLoadingVendorList.value = false;
        debugPrint(
            'Failed to load nearest vendors: ${response.statusText}');
        throw Exception(
            'Failed to load nearest vendors: ${response.statusText}');
      }
    } catch (error) {
      isLoadingVendorList.value = false;
      debugPrint('Error fetching nearest vendors: $error');
      throw Exception('Failed to load nearest vendors: $error');
    }
  }
}
