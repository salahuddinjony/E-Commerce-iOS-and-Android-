import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/services/category_services.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';

class VendorProductController extends GetxController with CategoryServices {
  var userIndex = "product".obs;

  void toggleUserIndex({required String selectedIndex}) {
    userIndex.value = selectedIndex;
  }

  RxList<ProductItem> productItems = <ProductItem>[].obs;
  final productNameController = TextEditingController();
  final priceController = TextEditingController();

  RxString selectedCategory = ''.obs;
  RxList<String> selectedColor = <String>[].obs; // Explicitly typed as RxList<String>
  RxList<String> selectedSize = <String>[].obs;  // Explicitly typed as RxList<String>
  RxString selectedCustomizable = ''.obs;

  RxString selectedImagePath = ''.obs;
  RxString selectedProductId = ''.obs;

  RxBool isLoading = false.obs;

    final isNetworkImage = false.obs;
      var imagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  final List<String> categoryOptions = [
    "Female T shirt",
    "Male T shirt",
    "Kids T shirt",
    "Accessories",
    "Hoodies",
  ];
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
  final List<String> sizes = [
    "S",
    "M",
    "L",
    "XL",
    "XXL",
  ];
  final List<String> customizable = [
    "Yes",
    "No",
  ];
  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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

  void setSelectedCustomizable(String customizable) {
    selectedCustomizable.value = customizable;
  }

  Future<void> fetchProducts() async {
    EasyLoading.show(
      status: 'Loading products...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.productList),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Products loaded successfully');
        final responseData = json.decode(response.body);
        final productResponse = ProductResponse.fromJson(responseData['data']);
        print(responseData['message']);
        print(
            "Products fetched successfully: ${productResponse.data.length} items");
        print("Product Response: ${responseData['data']}");
        print("Product Items: ${productResponse.data}");
        print("Product Items Value: ${productItems.value}");

        productItems.value = productResponse.data;
      } else if (response.statusCode == 404) {
        EasyLoading.showError('Failed to load(Randomly picked an emoji to add some fun 😄) products');
        print("No products found");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      EasyLoading.showError('Failed to load products: $e');
      print("Error fetching products: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}