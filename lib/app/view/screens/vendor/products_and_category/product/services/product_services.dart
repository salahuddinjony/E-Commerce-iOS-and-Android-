import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';

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
  RxBool isLoading = false.obs; // (legacy) keep if referenced elsewhere, but prefer new flags
  var imagePath = ''.obs;
  RxString categoryNameIs = ''.obs;

  final isNetworkImage = false.obs;

  final Map<String, String> colors = {
    "Black": "#000000",
    "White": "#FFFFFF",
    "Red": "#FF0000",
    "Green": "#00FF00",
    "Blue": "#0000FF",
    "Yellow": "#FFFF00",
    "Pink": "#FFC0CB",
    "Purple": "#800080",
    "Orange": "#FFA500",
  };
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
      Get.snackbar('Product', 'Name required');
      return false;
    }
    if (double.tryParse(priceController.text) == null) {
      Get.snackbar('Product', 'Invalid price');
      return false;
    }
    if (int.tryParse(quantityController.text) == null) {
      Get.snackbar('Product', 'Invalid quantity');
      return false;
    }
    if (method == "POST" && imagePath.isEmpty) {
      Get.snackbar('Product', 'Image required');
      return false;
    }
    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Product', 'Select category');
      return false;
    }
    if (selectedColor.isEmpty) {
      Get.snackbar('Product', 'Select color');
      return false;
    }
    if (selectedSize.isEmpty) {
      Get.snackbar('Product', 'Select size');
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
      final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
      if (token.isEmpty) {
        Get.snackbar('Auth', 'Token missing');
        return false;
      }
      if (JwtDecoder.isExpired(token)) {
        Get.snackbar('Auth', 'Session expired');
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
        Get.snackbar('Product',
            method == "POST" ? 'Created successfully' : 'Updated successfully');
        clear();
        await fetchProducts(); // refresh list
        return true;
      } else {
        final msg = (decoded is Map && decoded['message'] != null)
            ? decoded['message'].toString()
            : 'Failed ($status)';
        Get.snackbar('Product', msg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Product', 'Error: $e');
      return false;
    } finally {
      isProductMutating.value = false;
    }
  }

  Future<void> fetchProducts() async {
    isProductsLoading.value = true;
    try {
      final userId =
          await SharePrefsHelper.getString(AppConstants.userId);
      final resp =
          await ApiClient.getData(ApiUrl.productList(userId: userId));
      if (resp.statusCode == 200) {
        final raw = resp.body;
        final root = (raw is String) ? jsonDecode(raw) : raw;
        if (root == null || root['data'] == null) {
          Get.snackbar('Product', 'Unexpected response');
          productItems.clear();
          return;
        }
        final productResponse = ProductResponse.fromJson(root['data']);
        productItems.value = productResponse.data;
        if (productItems.isEmpty) {
          debugPrint('No products found');
        }
      } else if (resp.statusCode == 404) {
        productItems.clear();
        debugPrint('Products 404');
      } else {
        debugPrint('Fetch products failed (${resp.statusCode})');
      }
    } catch (e) {
      debugPrint('fetchProducts error: $e');
    } finally {
      isProductsLoading.value = false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    if (productId.isEmpty) return false;
    isProductMutating.value = true;
    try {
      final fullUrl = '${ApiUrl.baseUrl}/product/delete/$productId';
      final resp = await ApiClient.deleteData(fullUrl);
      if (resp.statusCode == 200) {
        productItems.removeWhere((p) => p.id == productId);
        Get.snackbar('Product', 'Deleted');
        return true;
      } else {
        dynamic decoded;
        try {
          decoded = (resp.body is String) ? jsonDecode(resp.body) : resp.body;
        } catch (_) {}
        final msg = (decoded is Map && decoded['message'] != null)
            ? decoded['message'].toString()
            : 'Delete failed (${resp.statusCode})';
        Get.snackbar('Product', msg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Product', 'Delete error: $e');
      return false;
    } finally {
      isProductMutating.value = false;
    }
  }
}
