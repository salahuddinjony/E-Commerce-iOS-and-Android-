
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/services/category_services.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/services/product_services.dart';

class VendorProductController extends GetxController
    with CategoryServices, ProductServices {
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

}
