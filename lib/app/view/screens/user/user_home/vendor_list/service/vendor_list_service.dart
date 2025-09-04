import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/view/screens/user/user_home/vendor_list/model/nearest_vendor_response.dart';

mixin class VendorListService {
  final RxList<UserItem> nearestVendors = <UserItem>[].obs;
  final RxBool isLoadingVendorList = false.obs;

  Future<void> fetchNearestVendor() async {
    try {
      isLoadingVendorList.value = true;
      final queryParams = <String, dynamic>{
          'profile.role': 'vendor',
      };
    

      final response = await ApiClient.getData(ApiUrl.getNearestVendorlist,
          query: queryParams);
      if (response.statusCode == 200) {
        isLoadingVendorList.value = false;
        final data = NearestVendorResponse.fromJson(response.body);
        nearestVendors.value = data.data ?? [];
        debugPrint('Nearest vendors fetched: ${nearestVendors.length}');
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
