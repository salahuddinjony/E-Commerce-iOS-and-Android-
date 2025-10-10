import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/app/core/routes.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/category/services/category_services.dart';

class CategoryController extends GetxController
    with CategoryServices {
  var name = ''.obs;
  var imagePath = ''.obs;
  final nameController = TextEditingController();
  final isNetworkImage = false.obs;

  final ScrollController scrollController = ScrollController();

  // Pagination variables
  int currentPage = 1;
  RxBool hasMoreData = true.obs;
  RxBool isPaginating = false.obs;
  final int itemsPerPage = 15; 
  Timer? _scrollDebounce;

  void setName(String value) => name.value = value;
  void setImagePath(String value) => imagePath.value = value;

  @override
  void onInit() {
    scrollController.addListener(_onScroll);
    super.onInit();
    refreshCategories();
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
    
    print('Category scroll event - pixels: $currentPosition, maxExtent: $maxExtent');
    print('Categories count: ${categoriesData.length}, hasMoreData: ${hasMoreData.value}, isPaginating: ${isPaginating.value}');
    print('Thresholds - 50%: $threshold50, 80%: $threshold80, 90%: $threshold90, nearBottom: $thresholdNearBottom');
    
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
      print('Triggering category pagination - $percentage% scrolled');
      print('Current state - categoriesCount: ${categoriesData.length}, currentPage: $currentPage, hasMoreData: ${hasMoreData.value}');
      // Set paginating flag immediately to show loader
      isPaginating.value = true;
      getMoreCategories();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    nameController.dispose();
    _scrollDebounce?.cancel();
    super.onClose();
  }

  void setInitialValues(String initialImagePath, String initialCategoryName) {
    print("Setting initial values: imagePath=$initialImagePath, categoryName=$initialCategoryName");
    imagePath.value = initialImagePath;
    isNetworkImage.value = initialImagePath.startsWith('http');
    nameController.text = initialCategoryName;
  }

  // Load more categories for pagination
  Future<void> getMoreCategories() async {
    print('getMoreCategories called - hasMoreData: ${hasMoreData.value}, isPaginating: ${isPaginating.value}');
    
    if (!hasMoreData.value) {
      print('Pagination blocked - no more data available');
      isPaginating.value = false;
      return;
    }

    print('Starting category pagination - loading page ${currentPage + 1}');
    try {
      final nextPage = currentPage + 1;
      
      final result = await fetchCategories(page: nextPage,itemsPerPage: itemsPerPage);
      
      if (result['success'] == true) {
        currentPage = nextPage;
        hasMoreData.value = result['hasMoreData'] ?? false;
        
        final newItemsLoaded = result['newItemsCount'] ?? 0;
        print('Category pagination completed successfully. Current page: $currentPage, hasMoreData: ${hasMoreData.value}, newItems: $newItemsLoaded');
      } else {
        print('Category pagination failed - API returned success: false');
        hasMoreData.value = false;
      }
    } catch (e) {
      print('Category pagination failed: $e');
      hasMoreData.value = false;
    } finally {
      isPaginating.value = false;
    }
  }

  // Refresh categories method
  Future<void> refreshCategories() async {
    currentPage = 1;
    hasMoreData.value = true;
    final result = await fetchCategories(isRefresh: true);
    if (result['success'] == true) {
      hasMoreData.value = result['hasMoreData'] ?? false;
    }
  }



// Image Picker
  Future<void> pickImage({required String source}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
       source: source == "camera"
          ? ImageSource.camera
          : ImageSource.gallery,
        );
        
      if (pickedFile != null) {
        print("New image picked: ${pickedFile.path}");
        imagePath.value = pickedFile.path;
        isNetworkImage.value = false;
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
      EasyLoading.showError('Failed to pick image: $e');
    }
  }

  void clearImage() {
    print("Clearing image");
    imagePath.value = '';
    isNetworkImage.value = false;
  }

  void clear() {
    print("Clearing all fields");
    nameController.clear();
    imagePath.value = '';
    isNetworkImage.value = false;
  }

  

  void reFresehData() async{
    print("Refreshing data");
    await refreshCategories();
    clear();
  }

// Create or Update Category
  Future<void> createCategoryPost(String method, String id, String passedImage, String passedName) async {
    String name = nameController.text.trim();
    String imagePath = this.imagePath.value.trim();

   
    if (method == 'PATCH') {
      if (name == passedName && imagePath == passedImage) {
        EasyLoading.showInfo('No changes detected');
        print("Validation failed: No changes detected (name=$name, imagePath=$imagePath)");
        return;
      }
    }

   
    if (name.isEmpty) {
      EasyLoading.showInfo('Name cannot be empty');
      print("Validation failed: name is empty");
      return;
    }
    if (method == 'POST' && imagePath.isEmpty) {
      EasyLoading.showInfo('Image cannot be empty');
      print("Validation failed: imagePath is empty for POST");
      return;
    }
    if (method == 'PATCH' && (id.isEmpty || id == 'null')) {
      EasyLoading.showInfo('Category ID is required for updating');
      print("Validation failed: categoryId is empty for PATCH");
      return;
    }

    print("Creating/Updating category: method=$method, id=$id, name=$name, imagePath=$imagePath, isNetworkImage=${isNetworkImage.value}");
    await createUpdateCategory(
      name: name,
      imagePath: imagePath,
      method: method,
      id: id,
    );
    
    reFresehData();
    AppRouter.route.pop();
  }
}