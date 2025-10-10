import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/model/product_response.dart';

mixin class ProductServices {
  //create product and update product
  RxList<ProductItem> productItems = <ProductItem>[].obs;
  // Loading flags
  final RxBool isProductsLoading = false.obs;
  final RxBool isProductMutating = false.obs;
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController(); // Added for quantity

  // For category selection
  RxString selectedCategory = ''.obs;

  // For color, size, and isFeatured options
  RxList<String> selectedColor = <String>[].obs;
  RxList<String> selectedSize = <String>[].obs;

  RxString isFeatured = 'false'.obs;
  RxString selectedProductId = ''.obs;
  RxBool isLoading =
      false.obs; // (legacy) keep if referenced elsewhere, but prefer new flags
  var imagePath = ''.obs;
  RxString categoryNameIs = ''.obs;

  final isNetworkImage = false.obs;

  final List<String> sizes = ["S", "M", "L", "XL", "XXL"];
  final List<String> isFeaturedOptions = ["true", "false"];

  Future<void> pickImage({required String source}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile != null) {
        print("New image picked: ${pickedFile.path}");
        imagePath.value = pickedFile.path;
        isNetworkImage.value = false;
      } else {
        print("No image selected");
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      Get.snackbar('Product', 'Failed to pick image');
    }
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  void setSelectedColor(List<String> color) {
    selectedColor.assignAll(color);
  }

  void setSelectedSize(List<String> size) {
    selectedSize.assignAll(size);
  }

  void setIsFeatured(String value) {
    isFeatured.value = value;
  }

  void getAllData() {
    print("Selected Category: ${selectedCategory.value}");
    print("Selected Colors: ${selectedColor.join(', ')}");
    print("Selected Sizes: ${selectedSize.join(', ')}");
    print("Is Featured: ${isFeatured.value}");
    print("Image Paths: ${imagePath.value}");
    print("Product Name: ${productNameController.text}");
    print("Price: ${priceController.text}");
    print("Quantity: ${quantityController.text}");
  }

  void clearImage() {
    imagePath.value = '';
    isNetworkImage.value = false;
  }

  void clear() {
    productNameController.clear();
    priceController.clear();
    quantityController.clear();
    selectedCategory.value = '';
    selectedColor.clear();
    selectedSize.clear();
    isFeatured.value = 'false';
    imagePath.value = '';
    isNetworkImage.value = false;
  }

//Product create and update
  Future<bool> createOrUpdateProduct({
    required String method, // "POST" or "PATCH"
    String? productId,
    Map<String, dynamic>? originalData,
  }) async {
    if (productNameController.text.isEmpty) {
      EasyLoading.showInfo('Name required');
      return false;
    }
    if (double.tryParse(priceController.text) == null) {
      EasyLoading.showInfo('Invalid price');
      return false;
    }
    if (int.tryParse(quantityController.text) == null) {
      EasyLoading.showInfo('Invalid quantity');
      return false;
    }
    if (method == "POST" && imagePath.isEmpty) {
      EasyLoading.showInfo('Image required');
      return false;
    }
    if (selectedCategory.value.isEmpty) {
      EasyLoading.showInfo('Select category');
      return false;
    }
    if (selectedColor.isEmpty) {
      EasyLoading.showInfo('Select color');
      return false;
    }
    if (selectedSize.isEmpty) {
      EasyLoading.showInfo('Select size');
      return false;
    }

    if (method == "PATCH" && originalData != null) {
      final noChanges = originalData['name'] == productNameController.text &&
          originalData['category'] == selectedCategory.value &&
          originalData['isFeatured'].toString() == isFeatured.value &&
          originalData['price'].toString() == priceController.text &&
          originalData['quantity'].toString() == quantityController.text &&
          listEquals(
              List<String>.from(originalData['size'] ?? []), selectedSize) &&
          listEquals(
              List<String>.from(originalData['colors'] ?? []), selectedColor) &&
          imagePath.isEmpty;
      if (noChanges) {
        Get.snackbar('Product', 'No changes');
        return false;
      }
    }

    isProductMutating.value = true;
    try {
      EasyLoading.show(
          status: method == 'POST' ? 'Creating...' : 'Updating...');
      final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
      if (token.isEmpty) {
        toastMessage(message: 'Token missing');
        return false;
      }
      if (JwtDecoder.isExpired(token)) {
        toastMessage(message: 'Session expired');
        return false;
      }

      // Build relative endpoint (assumes ApiUrl.* are relative for multipart endpoints)
      // If ApiUrl.createProduct / updateProduct already return FULL url (start with http),
      // set useDirect = true and pass trimmed path accordingly.
      String endpoint = method == 'POST'
          ? ApiUrl.createProduct
          : ApiUrl.updateProduct(productId: productId!);

      final bool isFull = endpoint.startsWith('http');
      // ApiClient.postMultipartData / patchMultipart internally prepend baseUrl,
      // so if endpoint is full, strip baseUrl to avoid double.
      if (isFull && endpoint.startsWith(ApiUrl.baseUrl)) {
        endpoint = endpoint.substring(ApiUrl.baseUrl.length);
      }

      final Map<String, dynamic> body = {
        'name': productNameController.text,
        'category': selectedCategory.value,
        'isFeatured': (isFeatured.value.toLowerCase() == "true").toString(),
        'price': priceController.text,
        'quantity': quantityController.text,
        'size': selectedSize,
        'colors': selectedColor,
      };

      List<MultipartBody>? files;
      if (imagePath.isNotEmpty &&
          (method == 'POST' ||
              (method == 'PATCH' && isNetworkImage.value == false))) {
        files = [MultipartBody('images', File(imagePath.value))];
      }

      final Response resp = method == 'POST'
          ? await ApiClient.postMultipartData(
              endpoint,
              body,
              multipartBody: files,
              requestType: 'POST',
            )
          : await ApiClient.patchMultipart(
              endpoint,
              body,
              multipartBody: files,
              requestType: 'PATCH',
            );

      final status = resp.statusCode ?? 0;
      dynamic decoded;
      try {
        decoded = (resp.body is String) ? jsonDecode(resp.body) : resp.body;
      } catch (_) {
        decoded = resp.body;
      }

      if (status == 200) {
        EasyLoading.showSuccess(
            method == 'POST' ? 'Product created' : 'Product updated');
        clear();
        await fetchProducts(isRefresh: true); // refresh list
        return true;
      } else {
        final msg = (decoded is Map && decoded['message'] != null)
            ? decoded['message'].toString()
            : 'Failed ($status)';
        EasyLoading.showError(msg);
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Error: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
      isProductMutating.value = false;
    }
  }

  Future<void> fetchProducts(
      {String? vendorId,
      int page = 1,
      bool isRefresh = false,
      int itemsPerPage = 12}) async {
    try {
      print('fetchProducts called with page: $page, isRefresh: $isRefresh');

      // Only set isLoading for initial load (page 1) or refresh
      if (page == 1) {
        isProductsLoading.value = true;
      }

      if (isRefresh) {
        productItems.clear();
      }

      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': itemsPerPage.toString(),
      };

      vendorId ??= await SharePrefsHelper.getString(AppConstants.userId);

      final resp = await ApiClient.getData(ApiUrl.productList(userId: vendorId),
          query: queryParams);

      if (resp.statusCode == 200) {
        final raw = resp.body;
        final root = (raw is String) ? jsonDecode(raw) : raw;
        if (root == null || root['data'] == null) {
          Get.snackbar('Product', 'Unexpected response');
          if (page == 1 || isRefresh) {
            productItems.clear();
          }
          return;
        }

        final productResponse = ProductResponse.fromJson(root['data']);
        final newProducts = productResponse.data;

        if (page == 1 || isRefresh) {
          // First page or refresh - replace all products
          productItems.value = newProducts;
        } else {
          // Additional pages - append to existing products
          productItems.addAll(newProducts);
        }

        print(
            'Loaded ${newProducts.length} products for page $page. Total products: ${productItems.length}');

        if (productItems.isEmpty && (page == 1 || isRefresh)) {
          debugPrint('No products found');
        }
      } else if (resp.statusCode == 404) {
        if (page == 1 || isRefresh) {
          productItems.clear();
        }
        debugPrint('Products 404');
      } else {
        debugPrint('Fetch products failed (${resp.statusCode})');
      }
    } catch (e) {
      debugPrint('fetchProducts error: $e');
    } finally {
      // Always reset loading state for initial load or refresh
      if (page == 1) {
        isProductsLoading.value = false;
      }
    }
  }

  Future<bool> deleteProduct(String productId) async {
    if (productId.isEmpty) return false;
    isProductMutating.value = true;
    try {
      EasyLoading.show(status: 'Deleting...');
      final fullUrl = '${ApiUrl.baseUrl}/product/delete/$productId';
      final resp = await ApiClient.deleteData(fullUrl);
      if (resp.statusCode == 200) {
        fetchProducts(isRefresh: true); // refresh list
        productItems.removeWhere((p) => p.id == productId);
        EasyLoading.showSuccess('Product deleted');
        return true;
      } else {
        EasyLoading.showError('Delete failed');
        dynamic decoded;
        try {
          decoded = (resp.body is String) ? jsonDecode(resp.body) : resp.body;
        } catch (_) {}
        final msg = (decoded is Map && decoded['message'] != null)
            ? decoded['message'].toString()
            : 'Delete failed (${resp.statusCode})';
        EasyLoading.showError(msg);
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Delete error: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
      isProductMutating.value = false;
    }
  }
}
