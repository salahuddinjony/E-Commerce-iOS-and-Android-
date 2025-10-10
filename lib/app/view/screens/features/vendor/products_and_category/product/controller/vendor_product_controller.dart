import 'dart:async';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:local/app/view/common_widgets/product_color_list/mixin_product_color.dart';

import 'package:local/app/view/screens/features/vendor/products_and_category/category/services/category_services.dart';
// import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/services/product_services.dart';

class VendorProductController extends GetxController
    with CategoryServices, ProductServices, ProductColorMixin {
  var userIndex = "product".obs;

  void toggleUserIndex({required String selectedIndex}) {
    userIndex.value = selectedIndex;
  }

  // RxList<ProductItem> productItems = <ProductItem>[].obs;
  final searchController = TextEditingController();
  final RxList<dynamic> filteredCategories = <dynamic>[].obs;

  // Pagination variables
  ScrollController scrollController = ScrollController();
  int currentPage = 1;
  RxBool hasMoreData = true.obs;
  RxBool isPaginating = false.obs;
  final int itemsPerPage =
      12; // Number of items to load per page (matching API limit)
  Timer? _scrollDebounce;

  @override
  void onInit() {
    scrollController.addListener(_onScroll);
    super.onInit();
    refreshProducts();
    fetchCategories();
    filteredCategories.assignAll(categoriesData);
  }

  void _onScroll() {
    // Debounce scroll events to prevent rapid fire, but keep it responsive
    if (_scrollDebounce?.isActive ?? false) _scrollDebounce!.cancel();

    _scrollDebounce = Timer(const Duration(milliseconds: 50), () {
      _handleScrollEvent();
    });
  }

  void _handleScrollEvent() {
    // Check if we can scroll (avoid division by zero)
    if (!scrollController.position.hasContentDimensions) return;

    final currentPosition = scrollController.position.pixels;
    final maxExtent = scrollController.position.maxScrollExtent;

    // Use multiple thresholds to make pagination more responsive
    final threshold50 = maxExtent * 0.5; // 50% threshold for easier testing
    final threshold80 = maxExtent * 0.8; // 80% threshold
    final threshold90 = maxExtent * 0.9; // 90% threshold
    final thresholdNearBottom = maxExtent - 100; // Within 100 pixels of bottom

    print(
        'Product scroll event - pixels: $currentPosition, maxExtent: $maxExtent');
    print(
        'Thresholds - 50%: $threshold50, 80%: $threshold80, 90%: $threshold90, nearBottom: $thresholdNearBottom');
    print(
        'isPaginating: ${isPaginating.value}, hasMoreData: ${hasMoreData.value}');

    // Check if we should paginate
    bool shouldPaginate = !isPaginating.value &&
        hasMoreData.value &&
        maxExtent > 0 &&
        (currentPosition >= threshold50 || // 50% scrolled (easier for testing)
            currentPosition >= threshold80 || // 80% scrolled
            currentPosition >= thresholdNearBottom || // Near bottom
            (maxExtent > 0 &&
                (currentPosition / maxExtent) >=
                    0.5)); // Alternative percentage check

    if (shouldPaginate) {
      final percentage = (currentPosition / maxExtent * 100).toStringAsFixed(1);
      print('Triggering product pagination - $percentage% scrolled');
      // Set paginating flag immediately to show loader
      isPaginating.value = true;
      getMoreProducts();
    }
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

  // Load more products for pagination
  Future<void> getMoreProducts() async {
    print(
        'getMoreProducts called - hasMoreData: ${hasMoreData.value}, isPaginating: ${isPaginating.value}');

    if (!hasMoreData.value) {
      print('Pagination blocked - no more data available');
      isPaginating.value = false;
      return;
    }

    print('Starting product pagination - loading page ${currentPage + 1}');
    try {
      final nextPage = currentPage + 1;
      final previousCount = productItems.length;

      await fetchProducts(page: nextPage, itemsPerPage: itemsPerPage);

      final newCount = productItems.length;
      final newItemsLoaded = newCount - previousCount;

      print(
          'Previous count: $previousCount, New count: $newCount, New items: $newItemsLoaded');

      // If no new items were loaded, we've reached the end
      if (newItemsLoaded == 0) {
        hasMoreData.value = false;
        print('No new items loaded - reached end of data');
      } else {
        currentPage = nextPage;
        // If we got fewer items than expected (9), we might be at the end
        if (newItemsLoaded < 9) {
          hasMoreData.value = false;
          print(
              'Loaded fewer items than expected ($newItemsLoaded < 9) - might be at end');
        }
      }

      print(
          'Product pagination completed successfully. Current page: $currentPage, hasMoreData: ${hasMoreData.value}');
    } catch (e) {
      print('Product pagination failed: $e');
    } finally {
      isPaginating.value = false;
    }
  }

  // Refresh products method
  Future<void> refreshProducts() async {
    currentPage = 1;
    hasMoreData.value = true;
    await fetchProducts(isRefresh: true);
  }

  @override
  void onClose() {
    productNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    searchController.dispose();
    scrollController.dispose();
    _scrollDebounce?.cancel();
    super.onClose();
  }
}
