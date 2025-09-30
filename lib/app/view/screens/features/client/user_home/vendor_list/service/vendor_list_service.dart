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
     
    
      final body = {

        'clientLocation': '${latLng.latitude}, ${latLng.longitude}',
        
      };

      String endpoint = ApiUrl.getNearestVendorlist;
      final response = await ApiClient.getData(endpoint, body: body);
      if (response.statusCode == 200) {
        isLoadingVendorList.value = false;
        final data = VendorResponse.fromJson(response.body);
        nearestVendors.value = data.data ?? [];
        debugPrint('Nearest vendors fetched length: ${nearestVendors.length}');
        debugPrint('Response data: ${response.body}');
      } else {
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
