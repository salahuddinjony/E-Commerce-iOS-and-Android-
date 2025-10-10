import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A reusable mixin for implementing pagination functionality across different controllers
/// 
/// Usage:
/// 1. Mix this into your controller: `class MyController extends GetxController with PaginationMixin`
/// 2. Override the abstract methods to define your specific pagination behavior
/// 3. Call `initializePagination()` in your controller's `onInit()` method
/// 4. Call `disposePagination()` in your controller's `onClose()` method
/// 5. Use the scroll controller in your UI widgets
mixin PaginationMixin on GetxController {
  // Pagination variables
  late ScrollController scrollController;
  int currentPage = 1;
  RxBool hasMoreData = true.obs;
  RxBool isPaginating = false.obs;
  int get itemsPerPage => 10; // Override this in your controller if needed
  Timer? _scrollDebounce;

  /// Initialize pagination - call this in your controller's onInit()
  void initializePagination() {
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    currentPage = 1;
    hasMoreData.value = true;
    isPaginating.value = false;
  }

  /// Dispose pagination resources - call this in your controller's onClose()
  void disposePagination() {
    scrollController.dispose();
    _scrollDebounce?.cancel();
  }

  /// Abstract method to implement fetching more data
  /// This method should be implemented by the mixing controller
  Future<Map<String, dynamic>> fetchMoreData(int page);

  /// Abstract method to implement refreshing data
  /// This method should be implemented by the mixing controller
  Future<Map<String, dynamic>> refreshData();

  void _onScroll() {
    // Debounce scroll events to prevent rapid fire
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
    
    print('Pagination scroll event - pixels: $currentPosition, maxExtent: $maxExtent');
    print('Thresholds - 50%: $threshold50, 80%: $threshold80, 90%: $threshold90, nearBottom: $thresholdNearBottom');
    print('isPaginating: ${isPaginating.value}, hasMoreData: ${hasMoreData.value}');
    
    // Check if we should paginate
    bool shouldPaginate = !isPaginating.value &&
        hasMoreData.value &&
        maxExtent > 0 &&
        (currentPosition >= threshold50 || // 50% scrolled (easier for testing)
         currentPosition >= threshold80 || // 80% scrolled
         currentPosition >= thresholdNearBottom || // Near bottom
         (maxExtent > 0 && (currentPosition / maxExtent) >= 0.5)); // Alternative percentage check
    
    if (shouldPaginate) {
      final percentage = (currentPosition / maxExtent * 100).toStringAsFixed(1);
      print('Triggering pagination - $percentage% scrolled');
      // Set paginating flag immediately to show loader
      isPaginating.value = true;
      getMoreData();
    }
  }

  /// Load more data for pagination
  Future<void> getMoreData() async {
    print('getMoreData called - hasMoreData: ${hasMoreData.value}, isPaginating: ${isPaginating.value}');
    
    if (!hasMoreData.value) {
      print('Pagination blocked - no more data available');
      isPaginating.value = false;
      return;
    }

    print('Starting pagination - loading page ${currentPage + 1}');
    try {
      final nextPage = currentPage + 1;
      
      final result = await fetchMoreData(nextPage);
      
      if (result['success'] == true) {
        currentPage = nextPage;
        hasMoreData.value = result['hasMoreData'] ?? false;
        
        final newItemsLoaded = result['newItemsCount'] ?? 0;
        print('Pagination completed successfully. Current page: $currentPage, hasMoreData: ${hasMoreData.value}, newItems: $newItemsLoaded');
      } else {
        print('Pagination failed - API returned success: false');
        hasMoreData.value = false;
      }
    } catch (e) {
      print('Pagination failed: $e');
      hasMoreData.value = false;
    } finally {
      isPaginating.value = false;
    }
  }

  /// Refresh data and reset pagination
  Future<void> refreshPaginatedData() async {
    currentPage = 1;
    hasMoreData.value = true;
    final result = await refreshData();
    if (result['success'] == true) {
      hasMoreData.value = result['hasMoreData'] ?? false;
    }
  }

  /// Get a loading indicator widget for pagination
  Widget getPaginationLoadingIndicator({Color? color}) {
    return Obx(() => isPaginating.value
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: color,
                strokeWidth: 2,
              ),
            ),
          )
        : const SizedBox.shrink());
  }

  /// Get the item count including pagination loading indicator
  int getPaginatedItemCount(int baseItemCount) {
    return baseItemCount + (isPaginating.value ? 1 : 0);
  }

  /// Check if the current index is the loading indicator
  bool isLoadingIndicatorIndex(int index, int baseItemCount) {
    return index == baseItemCount && isPaginating.value;
  }
}