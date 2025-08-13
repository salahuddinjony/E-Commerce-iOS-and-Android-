import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/services/category_services.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/services/create_and_update_product.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';

class VendorProductController extends GetxController
    with CategoryServices,CreateAndUpdateProduct {
  var userIndex = "product".obs;

  void toggleUserIndex({required String selectedIndex}) {
    userIndex.value = selectedIndex;
  }

  RxList<ProductItem> productItems = <ProductItem>[].obs;
  final searchController = TextEditingController();
  final RxList<dynamic> filteredCategories = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCategories();
    filteredCategories.assignAll(categoriesData);
  }
  

  // Method to filter categories based on search input
  void filterCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(categoriesData);
    } else {
      filteredCategories.assignAll(
        categoriesData
            .where((category) =>
                category.name.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  void initializeForEdit({
    String? productName,
    List<String>? colors,
    List<String>? sizes,
    String? price,
    String? quantity,
    String? isFeaturedValue,
    String? categoryId,
    String? categoryName,
    required String image,
  }) {
    productNameController.text = productName ?? '';
    selectedColor.value = colors ?? [];
    selectedSize.value = sizes ?? [];
    priceController.text = price ?? '';
    quantityController.text = quantity ?? '';
    isFeatured.value = isFeaturedValue ?? 'false';
    selectedCategory.value = categoryId ?? '';
    categoryNameIs.value = categoryName ?? '';
    imagePath.value = image;
    isNetworkImage.value = image.startsWith('http');
    
  }

  @override
  void onClose() {
    productNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchProducts() async {
    EasyLoading.show(
      status: 'Loading products...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      // Get the authentication token
      final token = await SharePrefsHelper.getString(AppConstants.bearerToken);

      if (token.isEmpty) {
        EasyLoading.showError(
            'Authentication token is missing. Please log in again.');
        return;
      }

      final response = await http.get(
        Uri.parse(ApiUrl.productList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Products loaded successfully');
        final responseData = json.decode(response.body);

        // Check if the response has the expected structure
        if (responseData['data'] == null) {
          print("Warning: Response data is null or missing");
          print("Full response: $responseData");
          return;
        }

        final productResponse = ProductResponse.fromJson(responseData['data']);
        print(responseData['message']);
        print(
            "Products fetched successfully: ${productResponse.data.length} items");
        print("Product Response: ${responseData['data']}");
        print("Product Items: ${productResponse.data}");
        print("Product Items Value: ${productItems.value}");

        // Debug: Check individual product images
        for (int i = 0; i < productResponse.data.length; i++) {
          final product = productResponse.data[i];
          print("Product $i (${product.name}):");
          print("  - Images count: ${product.images.length}");
          print("  - Images: ${product.images}");
          if (product.images.isNotEmpty) {
            print("  - First image: ${product.images.first}");
          }
        }

        productItems.value = productResponse.data;
      } else if (response.statusCode == 404) {
        EasyLoading.showError('No products found');
        print("No products found");
      } else {
        EasyLoading.showError(
            'Failed to load products (Status: ${response.statusCode})');
        print("Error: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      EasyLoading.showError('Failed to load products: $e');
      print("Error fetching products: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
