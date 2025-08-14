import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:http/http.dart' as http;

mixin class CreateAndUpdateProduct {
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
  RxString categoryNameIs=''.obs;

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
  final List<String> isFeaturedOptions = [
    "true",
    "false"
  ];

  // Future<void> pickImage() async {
  //   try {
  //     final picker = ImagePicker();
  //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       print("New image picked: ${pickedFile.path}");
  //       imagePath.value = pickedFile.path;
  //       isNetworkImage.value = false;
  //     } else {
  //       print("No image selected");
  //     }
  //   } catch (e) {
  //     print("Error picking image: $e");
  //     EasyLoading.showError('Failed to pick image: $e');
  //   }
  // }
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
  if(selectedColor.isEmpty){
     EasyLoading.showError('Please select a Color');
    return false;
  }
  if(selectedSize.isEmpty){
     EasyLoading.showError('Please select Size');
    return false;
  }

  // Change detection for PATCH
  if (method == "PATCH" && originalData != null) {
    bool noChanges =
        originalData['name'] == productNameController.text &&
        originalData['category'] == selectedCategory.value &&
        originalData['isFeatured'].toString() == isFeatured.value &&
        originalData['price'].toString() == priceController.text &&
        originalData['quantity'].toString() == quantityController.text &&
        listEquals(originalData['size'], selectedSize) &&
        listEquals(originalData['colors'], selectedColor) &&
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
      EasyLoading.showError('Authentication token is missing. Please log in again.');
      return false;
    }
    if (JwtDecoder.isExpired(token)) {
      EasyLoading.showError('Session expired. Please log in again.');
      return false;
    }

    final url = (method == 'POST'
        ? ApiUrl.createProduct
        : ApiUrl.updateProduct(productId: productId!));

    var request = http.MultipartRequest(method, Uri.parse(url))
      ..headers.addAll({
        'Authorization': 'Bearer $token',
      })
      ..fields['name'] = productNameController.text
      ..fields['category'] = selectedCategory.value
      ..fields['isFeatured'] = (isFeatured.value.toLowerCase() == "true").toString()
      ..fields['price'] = priceController.text
      ..fields['quantity'] = quantityController.text
      ..fields['size'] = selectedSize.isNotEmpty ? jsonEncode(selectedSize) : '[]'
      ..fields['colors'] = selectedColor.isNotEmpty ? jsonEncode(selectedColor) : '[]';

    // ✅ Handle image upload logic
    if (imagePath.isNotEmpty) {
      if (method == "POST") {
        // Always upload image for new product
        final imageFile = await http.MultipartFile.fromPath('images', imagePath.value);
        request.files.add(imageFile);
      } else if (method == "PATCH" && isNetworkImage.value == false) {
        // Only upload if new local image is picked
        final imageFile = await http.MultipartFile.fromPath('images', imagePath.value);
        request.files.add(imageFile);
      }
      // else: Skip adding image if it's already a network image
    }

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final jsonResponse = responseBody.isNotEmpty ? jsonDecode(responseBody) : {};

    if (response.statusCode == 200) {
      EasyLoading.showSuccess(
          method == "POST" ? 'Product created successfully' : 'Product updated successfully');
      clear();
      return true;
    } else {
      final errorMessage = jsonResponse['error']?.toString() ??
          jsonResponse['message']?.toString() ??
          'Unknown error (Status: ${response.statusCode})';
      EasyLoading.showError('Failed: $errorMessage');
      return false;
    }
  } catch (e) {
    EasyLoading.showError('Error: $e');
    return false;
  } finally {
    isLoading.value = false;
  }
}


}
