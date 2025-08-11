import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

mixin class CreateProduct {
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController(); // Added for quantity

  // For category selection
  RxString selectedCategory = ''.obs;

  // For color, size, and isFeatured options
  RxList<String> selectedColor = <String>[].obs;
  RxList<String> selectedSize = <String>[].obs;
  RxString isFeatured = ''.obs; // Renamed from selectedCustomizable

  RxList<String> selectedImagePaths = <String>[].obs; // Updated to handle multiple images
  RxString selectedProductId = ''.obs;

  RxBool isLoading = false.obs;
  var imagePath = ''.obs;

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
  final List<String> isFeaturedOptions = ["true", "false"]; // Options for isFeatured

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print("New image picked: ${pickedFile.path}");
        selectedImagePaths.add(pickedFile.path);
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
    print("Image Paths: ${selectedImagePaths.join(', ')}");
    print("Product Name: ${productNameController.text}");
    print("Price: ${priceController.text}");
    print("Quantity: ${quantityController.text}");
  }

  void clearImage() {
    selectedImagePaths.clear();
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
    selectedImagePaths.clear();
    isNetworkImage.value = false;
  }

  Future<void> createProduct() async {
    isLoading.value = true;
    try {
      final token = SharePrefsHelper.getString(AppConstants.bearerToken);
      final url = Uri.parse(ApiUrl.createProduct);

      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({'Authorization': 'Bearer $token'})
        ..fields['name'] = productNameController.text
        ..fields['category'] = selectedCategory.value
        ..fields['isFeatured'] = isFeatured.value
        ..fields['price'] = priceController.text
        ..fields['quantity'] = quantityController.text
        ..fields['size'] = selectedSize.toString()
        ..fields['colors'] = selectedColor.toString();

      // Add images
      for (var imagePath in selectedImagePaths) {
        var file = await http.MultipartFile.fromPath('images', imagePath);
        request.files.add(file);
        print("Added image: $imagePath");
      }

      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Product created successfully');
        print("Product created successfully");
        clear();
      } else {
        EasyLoading.showError('Failed to create product');
      }
    } catch (e) {
      print("Error creating product: $e");
      EasyLoading.showError('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}