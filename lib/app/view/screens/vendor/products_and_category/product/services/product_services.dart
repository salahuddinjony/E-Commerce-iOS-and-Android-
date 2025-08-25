import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  RxBool isLoading = false.obs;
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
      print("Error picking image: $e");
      EasyLoading.showError('Failed to pick image: $e');
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
      EasyLoading.showError('Product name is required');
      return false;
    }
    if (double.tryParse(priceController.text) == null) {
      EasyLoading.showError('Invalid price format');
      return false;
    }
    if (int.tryParse(quantityController.text) == null) {
      EasyLoading.showError('Invalid quantity format');
      return false;
    }
    if (method == "POST" && imagePath.isEmpty) {
      EasyLoading.showError('Please select at least one image');
      return false;
    }
    if (selectedCategory.value.isEmpty) {
      EasyLoading.showError('Please select a category');
      return false;
    }
    if (selectedColor.isEmpty) {
      EasyLoading.showError('Please select a Color');
      return false;
    }
    if (selectedSize.isEmpty) {
      EasyLoading.showError('Please select Size');
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
        EasyLoading.showInfo('No changes to update');
        return false;
      }
    }

    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
      if (token.isEmpty) {
        EasyLoading.showError('Authentication token missing');
        return false;
      }
      if (JwtDecoder.isExpired(token)) {
        EasyLoading.showError('Session expired');
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

      Response resp;
      if (method == 'POST') {
        resp = await ApiClient.postMultipartData(
          endpoint,
          body,
          multipartBody: files,
          requestType: 'POST',
        );
      } else {
        resp = await ApiClient.patchMultipart(
          endpoint,
          body,
          multipartBody: files,
          requestType: 'PATCH',
        );
      }

      final status = resp.statusCode ?? 0;
      dynamic decoded;
      try {
        decoded = (resp.body is String) ? jsonDecode(resp.body) : resp.body;
      } catch (_) {
        decoded = resp.body;
      }

      if (status == 200) {
        EasyLoading.showSuccess(method == "POST"
            ? 'Product created successfully'
            : 'Product updated successfully');
        clear();
        return true;
      } else {
        final msg = (decoded is Map && (decoded['message'] != null))
            ? decoded['message'].toString()
            : 'Failed (Status: $status)';
        EasyLoading.showError(msg);
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

//fetch product details

  Future<void> fetchProducts() async {
    EasyLoading.show(
        status: 'Loading products...', maskType: EasyLoadingMaskType.black);
    try {
      final resp = await ApiClient.getData(ApiUrl.productList(
          userId: await SharePrefsHelper.getString(AppConstants.userId)));
      if (resp.statusCode == 200) {
        final data = resp.body;
        final root = (data is String) ? jsonDecode(data) : data;
        if (root == null || root['data'] == null) {
          EasyLoading.showError('Unexpected response');
          return;
        }
        final productResponse = ProductResponse.fromJson(root['data']);
        productItems.value = productResponse.data;

        if (productItems.isEmpty) {
          EasyLoading.showInfo('No products found');
        } else {
          EasyLoading.showSuccess('Products loaded');
        }
      } else if (resp.statusCode == 404) {
        EasyLoading.showError('No products found');
      } else {
        EasyLoading.showError('Failed (Status: ${resp.statusCode})');
      }
    } catch (e) {
      EasyLoading.showError('Failed: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // delete product
  static Future<bool> deleteProduct(String productId) async {
    EasyLoading.show(
        status: 'Deleting...', maskType: EasyLoadingMaskType.black);
    try {
      // Build full URL for delete since ApiClient.deleteData does NOT prepend base
      final fullUrl = '${ApiUrl.baseUrl}/product/delete/$productId';
      final resp = await ApiClient.deleteData(fullUrl);
      if (resp.statusCode == 200) {
        EasyLoading.showSuccess('Product deleted');
        return true;
      } else {
        dynamic decoded;
        try {
          decoded = (resp.body is String) ? jsonDecode(resp.body) : resp.body;
        } catch (_) {}
        final msg = (decoded is Map && decoded['message'] != null)
            ? decoded['message'].toString()
            : 'Delete failed (Status: ${resp.statusCode})';
        EasyLoading.showError(msg);
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Error: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
