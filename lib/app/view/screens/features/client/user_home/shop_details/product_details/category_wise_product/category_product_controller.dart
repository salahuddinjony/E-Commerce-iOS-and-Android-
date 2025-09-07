import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryProductsController extends GetxController {
  final RxList<dynamic> initialProducts = <dynamic>[].obs;

  CategoryProductsController({required List<dynamic> initialProducts}) {
    this.initialProducts.assignAll(initialProducts);
    filteredProducts.assignAll(initialProducts);
  }

  final RxList<dynamic> filteredProducts = <dynamic>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;

  /// Call this when new data arrives
  void updateProducts(List<dynamic> newProducts) {
    initialProducts.assignAll(newProducts);
    filter(searchController.text);
  }

  @override
  void onInit() {
    super.onInit();
    filteredProducts.assignAll(initialProducts);
    searchText.value = searchController.text;
    // searchController.addListener(onSearchChanged);
  }

  @override
  void onClose() {
    // searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  // void onSearchChanged() {
  //   searchText.value = searchController.text;
  //   filter(searchController.text);
  // }

  void filter(String query) {
    searchText.value = query;
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      filteredProducts.assignAll(initialProducts);
      return;
    }
    filteredProducts.assignAll(initialProducts.where((p) {
      final name = (p.name ?? '').toString().toLowerCase();
      return name.contains(q);
    }).toList());
  }
}