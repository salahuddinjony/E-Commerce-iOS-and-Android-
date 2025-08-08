import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:local/app/services/app_url.dart';
import 'package:local/app/view/screens/vendor/produtcs_and_category/product/model/product_response.dart';

class VendorProductController extends GetxController {
  var userIndex = "product".obs;

  void toggleUserIndex({required String selectedIndex}) {
    userIndex.value = selectedIndex;
  }
  RxList<ProductItem> productItems = <ProductItem>[].obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    EasyLoading.show(
        status: 'Loading products...',
        maskType: EasyLoadingMaskType.black,
      );
    try {
     
      final response = await http.get(
        Uri.parse(ApiUrl.productList),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Products loaded successfully');
        final responseData = json.decode(response.body);
        final productResponse = ProductResponse.fromJson(responseData['data']);
        print(responseData['message']);
        print(
            "Products fetched successfully: ${productResponse.data.length} items");
            print("Product Response: ${responseData['data']}");
        print("Product Items: ${productResponse.data}");
        print("Product Items Value: ${productItems.value}");

           

        productItems.value = productResponse.data;
      } else if (response.statusCode == 404) {
        EasyLoading.showError('Failed to load products');
        print("No products found");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      EasyLoading.showError('Failed to load products: $e');
      print("Error fetching products: $e");
    } finally {
      EasyLoading.dismiss();
     
    }
  }
}
